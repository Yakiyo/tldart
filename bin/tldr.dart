import 'package:path/path.dart';
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
    print("tldr cli version: $version");
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

  final index = Index(join(home().path, '.tldr'));

  if (args['list'] == true) {
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
