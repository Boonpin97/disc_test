import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/disc_profiles.dart';
import '../models/answer.dart';
import '../models/disc_result.dart';
import '../models/word.dart';
import '../models/word_group.dart';

Future<Uint8List> buildPdfReport(
  DiscResult result, {
  required List<WordGroup> groups,
  required List<Answer> answers,
  DateTime? generatedAt,
}) async {
  final timestamp = generatedAt ?? DateTime.now();
  final dateStr = '${timestamp.year.toString().padLeft(4, '0')}-'
      '${timestamp.month.toString().padLeft(2, '0')}-'
      '${timestamp.day.toString().padLeft(2, '0')}';
  final dominant = result.dominantComposite;
  final profile = discProfiles[dominant]!;
  final document = pw.Document(
    title: 'DISC Personality Result',
    author: 'DISC Personality Test',
  );

  pw.Widget scoreTable(String label, Map<DiscCategory, int> values) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(color: PdfColors.blueGrey200),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.center,
      headers: const ['Type', 'D', 'I', 'S', 'C'],
      data: [
        [
          label,
          values[DiscCategory.d].toString(),
          values[DiscCategory.i].toString(),
          values[DiscCategory.s].toString(),
          values[DiscCategory.c].toString(),
        ],
      ],
    );
  }

  pw.Widget compositeChart() {
    const chartHeight = 140.0;
    const trackWidth = 34.0;
    const halfHeight = (chartHeight - 2) / 2;

    pw.Widget barColumn(DiscCategory category) {
      final value = result.composite[category]!;
      final magnitude = (value.abs() / 24.0).clamp(0.0, 1.0);
      final barHeight = halfHeight * magnitude;
      final color = _pdfColorFor(category);

      return pw.Column(
        children: [
          pw.Container(
            width: trackWidth,
            height: chartHeight,
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Column(
              children: [
                pw.SizedBox(
                  height: halfHeight,
                  child: pw.Align(
                    alignment: pw.Alignment.bottomCenter,
                    child: value > 0
                        ? pw.Container(
                            width: trackWidth,
                            height: barHeight,
                            decoration: pw.BoxDecoration(
                              color: color,
                              borderRadius: const pw.BorderRadius.vertical(
                                top: pw.Radius.circular(6),
                              ),
                            ),
                          )
                        : pw.SizedBox(),
                  ),
                ),
                pw.Container(height: 2, color: PdfColors.blueGrey400),
                pw.SizedBox(
                  height: halfHeight,
                  child: pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: value < 0
                        ? pw.Container(
                            width: trackWidth,
                            height: barHeight,
                            decoration: pw.BoxDecoration(
                              color: color,
                              borderRadius: const pw.BorderRadius.vertical(
                                bottom: pw.Radius.circular(6),
                              ),
                            ),
                          )
                        : pw.SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            category.letter,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            value > 0 ? '+$value' : '$value',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Composite Chart',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'How others most likely see you (MOST - LEAST). Range: -24 to +24.',
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: DiscCategory.values.map(barColumn).toList(),
          ),
        ],
      ),
    );
  }

  final responseRows = <List<String>>[];
  for (var i = 0; i < groups.length; i++) {
    final group = groups[i];
    final answer = answers[i];
    responseRows.add([
      'Question ${i + 1}',
      group.words.map((word) => word.text).join(', '),
      answer.mostIndex == null ? '-' : group.words[answer.mostIndex!].text,
      answer.leastIndex == null ? '-' : group.words[answer.leastIndex!].text,
    ]);
  }

  document.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        margin: const pw.EdgeInsets.all(28),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
      ),
      build: (context) => [
        pw.Container(
          padding: const pw.EdgeInsets.all(18),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: _pdfColorFor(dominant).shade(0.5),
            ),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 56,
                height: 56,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: _pdfColorFor(dominant),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Text(
                  profile.category.letter,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'DISC Personality Result',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Generated $dateStr'),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Dominant style: ${profile.category.fullName} (${profile.category.letter})',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(profile.otherTerms),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Scores',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        scoreTable('MOST', result.most),
        pw.SizedBox(height: 8),
        scoreTable('LEAST', result.least),
        pw.SizedBox(height: 8),
        scoreTable('COMPOSITE', result.composite),
        pw.SizedBox(height: 20),
        compositeChart(),
        pw.SizedBox(height: 20),
        pw.Text(
          'Interpretation',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(text: 'Other terms: ${profile.otherTerms}'),
        pw.Bullet(text: 'Emphasis: ${profile.emphasis}'),
        pw.Bullet(text: 'Key to motivation: ${profile.motivation}'),
        pw.Bullet(text: 'Basic intent: ${profile.basicIntent}'),
        pw.Bullet(text: 'Value to others: ${profile.valueToOthers}'),
        pw.Bullet(text: 'Major strengths: ${profile.majorStrengths}'),
        pw.Bullet(text: 'Motivated by: ${profile.motivatedBy}'),
        pw.Bullet(text: 'Using time: ${profile.usingTime}'),
        pw.SizedBox(height: 12),
        pw.Text(profile.overview),
        pw.SizedBox(height: 20),
        pw.Text(
          'Probable Strengths',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        ...profile.strengths.map((item) => pw.Bullet(text: item)),
        pw.SizedBox(height: 14),
        pw.Text(
          'Possible Weaknesses',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        ...profile.weaknesses.map((item) => pw.Bullet(text: item)),
        pw.SizedBox(height: 20),
        pw.Text(
          'Questionnaire Responses',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(color: PdfColors.blueGrey200),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: pw.BoxDecoration(color: PdfColors.blue50),
          cellAlignments: const {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerLeft,
          },
          headers: const ['Question', 'Words', 'MOST', 'LEAST'],
          data: responseRows,
        ),
      ],
    ),
  );

  return document.save();
}

PdfColor _pdfColorFor(DiscCategory category) => switch (category) {
      DiscCategory.d => PdfColor.fromInt(0xFFE53935),
      DiscCategory.i => PdfColor.fromInt(0xFFFDB913),
      DiscCategory.s => PdfColor.fromInt(0xFF43A047),
      DiscCategory.c => PdfColor.fromInt(0xFF1E88E5),
    };
