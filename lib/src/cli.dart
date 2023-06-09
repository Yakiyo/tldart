import 'package:args/args.dart' show ArgParser;

/// Parser used by the cli
var parser = ArgParser()
  ..addFlag('version',
      negatable: false,
      abbr: 'v',
      defaultsTo: false,
      help: 'Show current version of app')
  ..addFlag('help',
      negatable: false,
      abbr: 'h',
      defaultsTo: false,
      help: 'Show the help menu')
  ..addFlag('list',
      negatable: false,
      defaultsTo: false,
      help: 'List all commands from the cache')
  ..addFlag("update",
      negatable: false,
      abbr: 'u',
      defaultsTo: false,
      help: "Update local cache")
  ..addFlag("raw",
      negatable: false,
      abbr: 'r',
      defaultsTo: false,
      help: "Print raw markdown without formatting")
  // ..addOption('config', abbr: 'c', help: 'Path to config file')
  ..addOption('render',
      abbr: 'f', help: 'Path to render a custom markdown file')
  ..addOption('language',
      abbr: 'l', defaultsTo: 'en', help: 'Specify what language to display')
  ..addOption('platform',
      abbr: 'p',
      help: 'Specify platform',
      allowed: ['linux', 'macos', 'windows', 'sunos', 'osx', 'android']);
