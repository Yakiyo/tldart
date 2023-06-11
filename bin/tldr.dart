import 'package:tldart/src/error.dart';
import 'package:tldart/src/util.dart';
import 'package:tldart/tldart.dart';
import 'package:args/args.dart' show ArgResults;
import 'package:ansi/ansi.dart' show Ansi;
import 'dart:io' show exitCode;

/// Wrapper around the entire program
Future<void> run(List<String> arguments) async {
  exitCode = 0;
  late final ArgResults args;
  final ansi = Ansi();
  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    eprint("${ansi.red("[ERROR]")} ${e.message}");
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
    final dirs = TldrDir.defaults();
    await updateCache(dirs.root);
    print("Successfully updated local cache at ${dirs.cache}");
    return;
  }

  if (args['list'] == true) {
    final dirs = TldrDir.defaults();
    if (!dirs.index.existsSync()) {
      throw LibException(Errors.MissingIndex);
    }
    final index = Index(dirs.index.path);
    index.commands.forEach((key, _) {
      print(key);
    });
    return;
  }

  if (arguments.isEmpty || args.rest.isEmpty) {
    eprint(
        "${ansi.red("[ERROR]")} Missing arguments. Use the `${ansi.bold("--help")}` flag to see usage.");
    exitCode = 1;
    return;
  }

  try {
    final dirs = TldrDir.defaults();
    if (!(dirs.cache.existsSync() && dirs.index.existsSync())) {
      throw LibException(Errors.MissingCache);
    }
    final index = Index(dirs.index.path);
    final language = args['language'] as String;
    final platform = args['platform'] as String?;

    final query = args.rest.map((e) => e.toLowerCase()).join("-");
    final command = index.get(query);
    if (command == null) {
      throw LibException(Errors.InvalidCommand, message: ansi.bold(query));
    }
    late final String lines;
    final content = command.getContent(dirs.cache.path,
        language: language, platform: platform);
    if (args['raw']) {
      lines = content;
    } else {
      lines = render(content).join("\n\n");
    }
    print(lines);
    return;
  } on LibException catch (e) {
    late final String eMsg;
    switch (e.code) {
      case Errors.InvalidCommand:
        eMsg =
            "Invalid command query.\n\n No command with the name ${e.message} exists in the local cache."
            "\n Update local cache with the `--update` flag or send a pull request to ${ansi.underline("https://github.com/tldr-pages/tldr")}.";
        break;

      case Errors.InvalidIndex:
        eMsg =
            "Invalid `index.json` file. Please run the `--update` flag to restore index file";
        break;

      case Errors.MissingIndex:
        eMsg =
            "Missing `index.json` file. Please run the `--update` flag to update local cache.";
        break;

      case Errors.MissingCache:
        eMsg =
            "Missing cache directory. Use the ${ansi.green("`--update`")} flag to update local cache.";
        break;

      case Errors.MissingCommandFile:
        eMsg =
            "Missing file for command at ${e.message}. Use the `--update` flag to update local cache";
        break;

      case Errors.InvalidCommandPlatform:
        eMsg =
            "The command isn't available in provided platform in the language. Please provide a different platform or none to use defaults.";
        break;

      case Errors.InvalidDefaultPlatform:
        eMsg =
            "The command isn't available in provided platform in the language. Please provide a different platform or none to use defaults.";
        break;

      case Errors.InvalidCommandLang:
        eMsg =
            "The command isn't available in user's platform or the common platform. Please provide a platform explicitly.";
        break;

      default:
        eMsg =
            "Unknown error. Please file an issue at ${ansi.cyan("https://github.com/Yakiyo/tldart")}";
    }
    eprint("${ansi.red("[ERROR]")} $eMsg");
    exitCode = 1;
    return;
  }
}

void main(List<String> args) async {
  try {
    await run(args);
    return;
  } catch (e) {
    eprint(
        "${Ansi().red("UNKNOWNERR:")} Unhandled error from library. Please file an issue to https://github.com/Yakiyo/tldart/issues");
    eprint(e);
    exitCode = 1;
    return;
  }
}
