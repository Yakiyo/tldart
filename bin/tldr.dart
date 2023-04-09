import 'package:tldart/src/util.dart';
import 'package:tldart/tldart.dart';
import 'package:args/args.dart' show ArgResults;
import 'package:ansi/ansi.dart' show Ansi;
import 'dart:io' show exitCode;

/// Wrapper around the entire programe
void run(List<String> arguments) async {
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
    await updateCache(TldrDir.defaults().root);
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

void main(List<String> args) {
  try {
    run(args);
    return;
  } catch (e) {
    eprint("${Ansi().red("UNKNOWNERR:")} Unhandled error from library. Please file an issue to https://github.com/Yakiyo/tldart/issues");
    eprint(e);
    exitCode = 1;
    return;
  }  
}
