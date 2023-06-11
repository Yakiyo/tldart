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
      res.add('      ${ansi.cyan(highlightVariables(line, ansi))}');
    }
  }
  res.add('');
  return res;
}

/// Remove curly braces and underline variables in a code example
String highlightVariables(String line, Ansi ansi) {
  return line
      .split("}}")
      .map((s) {
        final i = s.split("{{");
        i.length > 1 ? i[1] = ansi.underline(i[1]) : null;
        return i.join("{{");
      })
      .join("}}")
      .replaceAll(RegExp("{{|}}"), "");
}
