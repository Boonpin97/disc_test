import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/disc_profiles.dart';
import '../models/answer.dart';
import '../models/disc_result.dart';
import '../models/word.dart';
import '../models/word_group.dart';
import 'pattern_matcher.dart';

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
  final pattern = matchPattern(result.composite);
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

  pw.Widget scorePlot(
    String title,
    Map<DiscCategory, int> scores, {
    required int minValue,
    required int maxValue,
    bool showZeroLine = false,
  }) {
    const plotW = 150.0;
    const plotH = 150.0;
    const padLeft = 22.0;
    const padRight = 6.0;
    const padTop = 8.0;
    const padBottom = 6.0;
    final plotLeft = padLeft;
    final plotRight = plotW - padRight;
    final plotTop = padTop;
    final plotBottom = plotH - padBottom;
    final plotInnerW = plotRight - plotLeft;
    final plotInnerH = plotBottom - plotTop;
    final range = (maxValue - minValue).toDouble();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.SizedBox(
          width: plotW,
          height: plotH,
          child: pw.CustomPaint(
            size: const PdfPoint(plotW, plotH),
            painter: (canvas, size) {
              double yFor(num v) {
                final clamped = v.clamp(minValue, maxValue).toDouble();
                final fromTop =
                    plotBottom - ((clamped - minValue) / range) * plotInnerH;
                // pdf canvas is bottom-up: invert.
                return size.y - fromTop;
              }

              // Frame.
              canvas
                ..setStrokeColor(PdfColors.blueGrey300)
                ..setLineWidth(0.6)
                ..drawRect(
                  plotLeft,
                  size.y - plotBottom,
                  plotInnerW,
                  plotInnerH,
                )
                ..strokePath();

              // Tick lines (faint horizontal grid).
              final tickStep = range <= 12 ? 2 : (range <= 30 ? 4 : 8);
              for (var v = minValue; v <= maxValue; v += tickStep) {
                final y = yFor(v);
                canvas
                  ..setStrokeColor(PdfColors.grey300)
                  ..setLineWidth(0.4)
                  ..drawLine(plotLeft, y, plotRight, y)
                  ..strokePath();
              }

              // Zero line emphasis.
              if (showZeroLine && minValue < 0 && maxValue > 0) {
                final zeroY = yFor(0);
                canvas
                  ..setStrokeColor(PdfColors.blueGrey400)
                  ..setLineWidth(0.9)
                  ..drawLine(plotLeft, zeroY, plotRight, zeroY)
                  ..strokePath();
              }

              // Column guides + dot positions.
              final categories = DiscCategory.values;
              final colSpacing = plotInnerW / categories.length;
              final dotXs = <double>[
                for (var i = 0; i < categories.length; i++)
                  plotLeft + colSpacing * (i + 0.5),
              ];
              for (final x in dotXs) {
                canvas
                  ..setStrokeColor(PdfColors.grey300)
                  ..setLineWidth(0.4)
                  ..drawLine(x, size.y - plotTop, x, size.y - plotBottom)
                  ..strokePath();
              }

              final dotPoints = <List<double>>[
                for (var i = 0; i < categories.length; i++)
                  [dotXs[i], yFor(scores[categories[i]]!)],
              ];

              // Polyline.
              canvas
                ..setStrokeColor(PdfColors.blueGrey500)
                ..setLineWidth(1.2)
                ..moveTo(dotPoints.first[0], dotPoints.first[1]);
              for (var i = 1; i < dotPoints.length; i++) {
                canvas.lineTo(dotPoints[i][0], dotPoints[i][1]);
              }
              canvas.strokePath();

              // Dots.
              for (var i = 0; i < categories.length; i++) {
                final p = dotPoints[i];
                canvas
                  ..setFillColor(_pdfColorFor(categories[i]))
                  ..drawEllipse(p[0], p[1], 3, 3)
                  ..fillPath();
              }
            },
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            for (final c in DiscCategory.values)
              pw.SizedBox(
                width: math.max(20.0, plotW / 4 - 4),
                child: pw.Column(
                  children: [
                    pw.Text(
                      c.letter,
                      style: pw.TextStyle(
                        color: _pdfColorFor(c),
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    pw.Text(
                      _formatScore(scores[c]!, showZeroLine: showZeroLine),
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget plotsRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Plot Your Scores',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'PDF-style line plots for the MOST, LEAST and COMPOSITE columns of the Scoring Summary.',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              scorePlot('MOST', result.most, minValue: 0, maxValue: 24),
              scorePlot('LEAST', result.least, minValue: 0, maxValue: 24),
              scorePlot(
                'COMPOSITE',
                result.composite,
                minValue: -24,
                maxValue: 24,
                showZeroLine: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget patternSection() {
    final accent = pattern.quadrant == null
        ? PdfColors.blueGrey700
        : _pdfColorFor(pattern.quadrant!);
    final heading = pattern.quadrant == null
        ? '${pattern.id}. ${pattern.name}'
        : '${pattern.id}. ${pattern.name} · ${pattern.quadrant!.fullName} (${pattern.quadrant!.letter})';

    pw.Widget block(String title, String body) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 8),
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.blueGrey700,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(body, style: const pw.TextStyle(fontSize: 10.5)),
        ],
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(color: accent, width: 4),
          top: pw.BorderSide(color: PdfColors.blueGrey200),
          right: pw.BorderSide(color: PdfColors.blueGrey200),
          bottom: pw.BorderSide(color: PdfColors.blueGrey200),
        ),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            heading,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          block('Outstanding Traits', pattern.outstandingTraits),
          block('Basic Desires and Internal Drive', pattern.internalDrive),
          block('Need for Possible Improvement', pattern.improvement),
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
                      'Dominant style: ${profile.category.fullName} (${profile.category.letter}) — The ${pattern.name}',
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
        plotsRow(),
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
          'Your Representative DISC Pattern',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        patternSection(),
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

String _formatScore(int v, {required bool showZeroLine}) {
  if (showZeroLine && v > 0) return '+$v';
  return '$v';
}
