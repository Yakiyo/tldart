import 'package:fast_tldr/fast_tldr.dart';
import 'package:args/args.dart' show ArgResults;
import 'package:ansi/ansi.dart' show Ansi;
import 'dart:io' show exit;

void main(List<String> arguments) {
  late final ArgResults args;
  final ansi = Ansi();

  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    eprint("${ansi.red("ARGERR:")} ${e.message}");
    exit(1);
  }

  if (args['version'] == true) {
    print("tldr cli version: $version");
    exit(0);
  }

  if (args['help'] == true) {
    showHelp(parser);
    exit(0);
  }

  if (args['update'] == true) {
    // TODO: Cache update
    print("Not Implemented!");
    exit(0);
  }

  if (arguments.isEmpty || args.rest.isEmpty) {
    eprint("${ansi.red("ARGERR:")} Missing arguments. Use the `${ansi.bold("--help")}` flag to see usage.");
    exit(1);
  }

  return;
}
