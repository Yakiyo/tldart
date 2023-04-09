import 'package:tldart/src/util.dart';
import 'package:tldart/tldart.dart';
import 'package:args/args.dart' show ArgResults;
import 'package:ansi/ansi.dart' show Ansi;
import 'dart:io' show exitCode;

void main(List<String> arguments) {
  exitCode = 0;
  late final ArgResults args;
  final ansi = Ansi();

  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    eprint("${ansi.red("ARGERR:")} ${e.message}");
    exitCode = 1;
    return;
  }

  if (args['version'] == true) {
    print("tldart $version");
    return;
  }

  if (args['help'] == true) {
    showHelp(parser);
    return;
  }

  if (args['update'] == true) {
    print("Not Implemented!");
    return;
  }

  if (args['list'] == true) {
    final dirs = TldrDir.defaults();
    if (!dirs.index.existsSync()) {
      eprint(
          "${ansi.red("FILEERR:")} Missing `index.json` file. Please run the `--update` flag to update local cache.");
      exitCode = 1;
      return;
    }
    final index = Index(dirs.index.path);
    index.commands.forEach((key, _) {
      print(key);
    });
    return;
  }

  if (arguments.isEmpty || args.rest.isEmpty) {
    eprint(
        "${ansi.red("ARGERR:")} Missing arguments. Use the `${ansi.bold("--help")}` flag to see usage.");
    exitCode = 1;
    return;
  }

  return;
}
