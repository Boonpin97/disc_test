import '../data/disc_profiles.dart';
import '../models/answer.dart';
import '../models/disc_result.dart';
import '../models/word.dart';
import '../models/word_group.dart';

String buildHtmlReport(
  DiscResult result, {
  required List<WordGroup> groups,
  required List<Answer> answers,
  DateTime? generatedAt,
}) {
  final timestamp = generatedAt ?? DateTime.now();
  final dateStr = '${timestamp.year.toString().padLeft(4, '0')}-'
      '${timestamp.month.toString().padLeft(2, '0')}-'
      '${timestamp.day.toString().padLeft(2, '0')}';
  final dominant = result.dominantComposite;
  final profile = discProfiles[dominant]!;

  String row(String label, Map<DiscCategory, int> values) {
    return '<tr><th>$label</th>'
        '<td>${values[DiscCategory.d]}</td>'
        '<td>${values[DiscCategory.i]}</td>'
        '<td>${values[DiscCategory.s]}</td>'
        '<td>${values[DiscCategory.c]}</td></tr>';
  }

  final chartHeight = 240.0;
  final chartWidth = 420.0;
  final baselineY = chartHeight / 2;
  final barWidth = 58.0;
  final gap = 38.0;

  final chartBars = StringBuffer();
  for (final category in DiscCategory.values) {
    final index = DiscCategory.values.indexOf(category);
    final value = result.composite[category]!;
    final magnitude = (value.abs() / 24.0).clamp(0.0, 1.0);
    final pixels = magnitude * (chartHeight / 2 - 16);
    final x = 32 + index * (barWidth + gap);
    final y = value >= 0 ? baselineY - pixels : baselineY;

    chartBars.writeln(
      '<rect x="$x" y="12" width="$barWidth" height="${chartHeight - 52}" rx="10" fill="#ececec" />'
      '<rect x="$x" y="${y.toStringAsFixed(1)}" width="$barWidth" height="${pixels.toStringAsFixed(1)}" rx="10" fill="${_colorFor(category)}" />'
      '<text x="${x + barWidth / 2}" y="${chartHeight - 14}" text-anchor="middle" font-size="18" font-weight="700" fill="#111827">${category.letter}</text>'
      '<text x="${x + barWidth / 2}" y="${chartHeight + 6}" text-anchor="middle" font-size="13" fill="#4b5563">${value > 0 ? '+' : ''}$value</text>',
    );
  }

  final strengthsList = profile.strengths.map((item) => '<li>$item</li>').join();
  final weaknessesList =
      profile.weaknesses.map((item) => '<li>$item</li>').join();
  final answerRows = StringBuffer();
  for (var i = 0; i < groups.length; i++) {
    final group = groups[i];
    final answer = answers[i];
    final mostWord =
        answer.mostIndex == null ? '-' : group.words[answer.mostIndex!].text;
    final leastWord =
        answer.leastIndex == null ? '-' : group.words[answer.leastIndex!].text;
    final words =
        group.words.map((word) => word.text).join(' / ');
    answerRows.writeln(
      '<tr>'
      '<td>Question ${i + 1}</td>'
      '<td>$words</td>'
      '<td>$mostWord</td>'
      '<td>$leastWord</td>'
      '</tr>',
    );
  }
  final mostSum = result.most.values.fold<int>(0, (sum, item) => sum + item);
  final leastSum = result.least.values.fold<int>(0, (sum, item) => sum + item);
  final compositeSum =
      result.composite.values.fold<int>(0, (sum, item) => sum + item);

  return '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DISC Personality Result - $dateStr</title>
<style>
  * { box-sizing: border-box; }
  :root {
    --ink: #132238;
    --muted: #5f6c7b;
    --line: #d8dee7;
    --panel: #f6f8fb;
    --paper: #ffffff;
  }
  body {
    margin: 0;
    background: linear-gradient(180deg, #eef5ff 0%, #ffffff 38%);
    color: var(--ink);
    font-family: "Segoe UI", "Helvetica Neue", Arial, sans-serif;
    line-height: 1.55;
  }
  main {
    max-width: 860px;
    margin: 0 auto;
    padding: 40px 24px 56px;
  }
  h1 { margin: 0; font-size: 34px; line-height: 1.05; }
  h2 { margin-top: 36px; margin-bottom: 12px; font-size: 24px; }
  h3 { margin-top: 24px; margin-bottom: 12px; font-size: 20px; }
  p { margin: 0 0 14px; }
  .eyebrow { display: inline-block; padding: 6px 12px; border-radius: 999px; background: #173d74; color: #fff; font-size: 13px; font-weight: 700; letter-spacing: .04em; }
  .subtle { color: var(--muted); }
  .card {
    background: var(--paper);
    border: 1px solid var(--line);
    border-radius: 20px;
    padding: 20px;
    box-shadow: 0 10px 32px rgba(17, 37, 63, 0.06);
  }
  .dominant {
    display: grid;
    grid-template-columns: 76px 1fr;
    gap: 18px;
    align-items: start;
  }
  .badge {
    width: 76px;
    height: 76px;
    border-radius: 20px;
    background: ${_colorFor(dominant)};
    color: #fff;
    display: grid;
    place-items: center;
    font-size: 34px;
    font-weight: 800;
  }
  table { width: 100%; border-collapse: collapse; }
  th, td { border: 1px solid var(--line); padding: 10px 14px; text-align: center; }
  th { background: #f0f4f9; }
  th:first-child, td:first-child { text-align: left; font-weight: 700; }
  .chart {
    background: var(--panel);
    border-radius: 16px;
    padding: 20px;
    overflow-x: auto;
  }
  .meta-grid {
    display: grid;
    grid-template-columns: 180px 1fr;
    gap: 10px 16px;
  }
  .meta-grid dt { font-weight: 700; color: var(--muted); }
  .lists {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
  }
  .answers-table td:nth-child(2) { text-align: left; }
  ul { margin: 0; padding-left: 20px; }
  li { margin-bottom: 6px; }
  .sanity {
    background: #edf8ee;
    border-left: 5px solid #3f9a50;
    padding: 14px 16px;
    border-radius: 14px;
  }
  blockquote {
    margin: 16px 0 0;
    padding: 12px 16px;
    border-left: 4px solid #c8d5e6;
    color: var(--muted);
    background: #fbfcfe;
  }
  @media (max-width: 720px) {
    main { padding: 24px 16px 40px; }
    .dominant { grid-template-columns: 1fr; }
    .badge { width: 64px; height: 64px; border-radius: 18px; }
    .meta-grid, .lists { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
<main>
  <span class="eyebrow">Personal DiSCernment Inventory</span>
  <h1>DISC Personality Result</h1>
  <p class="subtle">Generated $dateStr</p>

  <section class="card dominant">
    <div class="badge">${profile.category.letter}</div>
    <div>
      <p class="subtle">Your dominant style</p>
      <h2 style="margin-top:0;">${profile.category.fullName} (${profile.category.letter})</h2>
      <p>${profile.otherTerms}</p>
    </div>
  </section>

  <h2>Scores</h2>
  <section class="card">
    <table>
      <thead>
        <tr><th></th><th>D</th><th>I</th><th>S</th><th>C</th></tr>
      </thead>
      <tbody>
        ${row('MOST', result.most)}
        ${row('LEAST', result.least)}
        ${row('COMPOSITE', result.composite)}
      </tbody>
    </table>
  </section>

  <h2>Composite Chart</h2>
  <p class="subtle">How others most likely see you (MOST - LEAST). Range: -24 to +24.</p>
  <section class="chart">
    <svg viewBox="0 0 $chartWidth ${chartHeight + 24}" width="100%" height="320" role="img" aria-label="DISC composite scores">
      <line x1="16" y1="$baselineY" x2="${chartWidth - 16}" y2="$baselineY" stroke="#9ca3af" stroke-width="1.5" stroke-dasharray="5 5" />
      <text x="8" y="20" font-size="11" fill="#6b7280">+24</text>
      <text x="10" y="${baselineY - 4}" font-size="11" fill="#6b7280">0</text>
      <text x="8" y="${chartHeight - 44}" font-size="11" fill="#6b7280">-24</text>
      ${chartBars.toString()}
    </svg>
    <blockquote>
      The Composite graph is the Public Concept. MOST reflects the Projected Concept, while LEAST reflects the Private Concept.
    </blockquote>
  </section>

  <h2>Interpretation</h2>
  <section class="card">
    <dl class="meta-grid">
      <dt>Other terms</dt><dd>${profile.otherTerms}</dd>
      <dt>Emphasis</dt><dd>${profile.emphasis}</dd>
      <dt>Key to motivation</dt><dd>${profile.motivation}</dd>
      <dt>Basic intent</dt><dd>${profile.basicIntent}</dd>
      <dt>Value to others</dt><dd>${profile.valueToOthers}</dd>
      <dt>Major strengths</dt><dd>${profile.majorStrengths}</dd>
      <dt>Motivated by</dt><dd>${profile.motivatedBy}</dd>
      <dt>Using time</dt><dd>${profile.usingTime}</dd>
    </dl>
  </section>

  <h3>Overview</h3>
  <section class="card">
    <p>${profile.overview.replaceAll('\n\n', '</p><p>')}</p>
  </section>

  <h3>Probable Strengths and Possible Weaknesses</h3>
  <section class="lists">
    <div class="card">
      <h3 style="margin-top:0;">Probable strengths</h3>
      <ul>$strengthsList</ul>
    </div>
    <div class="card">
      <h3 style="margin-top:0;">Possible weaknesses</h3>
      <ul>$weaknessesList</ul>
    </div>
  </section>

  <h3>Sanity Check</h3>
  <div class="sanity">
    MOST total = $mostSum, LEAST total = $leastSum, COMPOSITE total = $compositeSum.
  </div>

  <h3>Questionnaire Responses</h3>
  <section class="card">
    <table class="answers-table">
      <thead>
        <tr>
          <th>Question</th>
          <th>Words</th>
          <th>MOST</th>
          <th>LEAST</th>
        </tr>
      </thead>
      <tbody>
        ${answerRows.toString()}
      </tbody>
    </table>
  </section>
</main>
</body>
</html>
''';
}

String _colorFor(DiscCategory category) => switch (category) {
      DiscCategory.d => '#e53935',
      DiscCategory.i => '#fdb913',
      DiscCategory.s => '#43a047',
      DiscCategory.c => '#1e88e5',
    };
