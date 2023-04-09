import 'package:ansi/ansi.dart' show Ansi;

/// Format a markdown file
List<String> render(String content) {
  final ansi = Ansi();
  final res = <String>[];
  res.add('');
  for (var line in content.split('\n')) {
    if (line.startsWith('#')) {
      continue; // skip command name
    } else if (line.startsWith('>')) {
      // Command description
      res[0] += '\n${line.substring(1)}';
    } else if (line.startsWith('-')) {
      // Example description
      res.add(ansi.blue(line.substring(1)));
    } else if (line.startsWith('`')) {
      // Example
      line = line.substring(
          1, line.length - 1); // Remove ` from the first and last position
      // TODO: Replace curly braces with underline
      line = line.replaceAll(
          RegExp(r'{{|}}'), ''); // replace curly braces in examples
      res.add('      ${ansi.cyan(line)}');
    }
  }
  res.add('');
  return res;
}
