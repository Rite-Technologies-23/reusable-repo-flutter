import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final inputFile = File('analyzer-report.txt');
  final outputFile = File('analyzer-report.html');

  if (!inputFile.existsSync()) {
    print("analyzer-report.txt not found.");
    exit(1);
  }

  final lines = await inputFile.readAsLines();

  final buffer = StringBuffer();
  buffer.writeln('<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Dart Analyzer Report</title>');
  buffer.writeln('<style>');
  buffer.writeln('body { font-family: Arial, sans-serif; padding: 20px; }');
  buffer.writeln('table { border-collapse: collapse; width: 100%; }');
  buffer.writeln('th, td { border: 1px solid #ddd; padding: 8px; }');
  buffer.writeln('th { background-color: #f2f2f2; }');
  buffer.writeln('.warning { color: #d97706; }');
  buffer.writeln('.info { color: #2563eb; }');
  buffer.writeln('</style></head><body>');
  buffer.writeln('<h1>Dart Analyzer Report</h1>');
  buffer.writeln('<table><thead><tr><th>Severity</th><th>File</th><th>Line</th><th>Column</th><th>Message</th></tr></thead><tbody>');

  final regex = RegExp(r'^(warning|info) - (.*?):(\d+):(\d+) - (.*?) -');

  for (var line in lines) {
    final match = regex.firstMatch(line);
    if (match != null) {
      final severity = match.group(1);
      final file = match.group(2);
      final lineNo = match.group(3);
      final column = match.group(4);
      final message = match.group(5);

      buffer.writeln(
        '<tr>'
        '<td class="$severity">$severity</td>'
        '<td>$file</td>'
        '<td>$lineNo</td>'
        '<td>$column</td>'
        '<td>$message</td>'
        '</tr>',
      );
    }
  }

  buffer.writeln('</tbody></table></body></html>');
  await outputFile.writeAsString(buffer.toString());

  print("HTML report generated: analyzer-report.html");
}
