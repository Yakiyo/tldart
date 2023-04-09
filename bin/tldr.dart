import 'package:tldart/src/error.dart';
import 'package:tldart/src/util.dart';
import 'package:tldart/tldart.dart';
import 'package:args/args.dart' show ArgResults;
import 'package:ansi/ansi.dart' show ansi;
import 'dart:io' show exitCode;

/// Wrapper around the entire programe
Future<void> run(List<String> arguments) async {
  exitCode = 0;
  late final ArgResults args;

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
    final dirs = TldrDir.defaults();
    await updateCache(dirs.root);
    print("Successfully updated local cache at ${dirs.cache}");
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

  try {
    final dirs = TldrDir.defaults();
    if (!(dirs.cache.existsSync() && dirs.index.existsSync())) {
      throw LibException(Errors.MissingCache);
      // eprint(
      //     "${ansi.red("FILEERR:")} Missing cache directory. Use the `--update` flag to update local cache.");
      // exitCode = 1;
    }
    final index = Index(dirs.index.path);
    final language = args['language'] as String;
    final platform = args['platform'] as String?;

    final query = args.rest.map((e) => e.toLowerCase()).join("-");
    final command = index.get(query);
    if (command == null) {
      eprint(
          "No command with the name ${ansi.bold(query)} exists in the local cache."
          "\nUpdate local cache with the `--update` flag or send a pull request to ${ansi.underline("https://github.com/tldr-pages/tldr")}.");
      return;
    }
    final lines = render(command.getContent(dirs.cache.path,
        language: language, platform: platform));
    print(lines.join('\n\n'));
    return;
  } on LibException catch (e) {
    switch (e.code) {
      case Errors.InvalidIndex:
        continue missingCache;
      case Errors.MissingIndex:
        continue missingCache;

      missingCache:
      case Errors.MissingCache:
        eprint(
            "${ansi.red("CACHEERR:")} Missing cache directory. Use the `--update` flag to update local cache.");
        break;

      case Errors.MissingCommandFile:
        eprint(
            "${ansi.red("FILEERR:")} Missing file for command at ${e.message}. Use the `--update` flag to update local cache");
        break;

      case Errors.InvalidCommandPlatform:
        eprint(
            "${ansi.red("ARGERR:")} The command isn't available in provided platform in the language. Please provide a different platform or none to use defaults.");
        break;

      case Errors.InvalidDefaultPlatform:
        eprint(
            "${ansi.red("ARGERR:")} The command isn't available in provided platform in the language. Please provide a different platform or none to use defaults.");
        break;

      case Errors.InvalidCommandLang:
        eprint(
            "${ansi.red("ARGERR:")} The command isn't available in user's platform or the common platform. Please provide a platform explicitly.");
        break;

      default:
    }
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
        "${ansi.red("UNKNOWNERR:")} Unhandled error from library. Please file an issue to https://github.com/Yakiyo/tldart/issues");
    eprint(e);
    exitCode = 1;
    return;
  }
}
