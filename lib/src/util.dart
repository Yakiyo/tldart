import 'dart:io' show stderr, Platform, Directory, File;
import 'package:path/path.dart' show join;
import 'package:args/args.dart' show ArgParser;
import '../tldart.dart';

/// Print debug logs. This should only print them if DEBUG env is set to 1
void debug(dynamic message) {
  final env = Platform.environment['DEBUG'];
  if (env == null || env.isEmpty) return;
  print(message);
  return;
}

/// Print errors to std err
void eprint(dynamic error) {
  stderr.writeln(error);
  return;
}

/// Print help message
void showHelp(ArgParser parser) {
  print("""
tldart $version
Fast and easy to use TLDR client

USAGE:
  tldr [OPTIONS] [COMMAND]
  Example: tldr -p linux git log

ARGUMENTS:
  [COMMAND] The command to show (e.g. `cp` or `tar`)

OPTIONS:
  ${parser.usage.split("\n").join("\n  ")}

To view documentation or file an issue, please visit https://github.com/Yakiyo/tldart
""");
  return;
}

// https://stackoverflow.com/a/25498458/17990034
/// Get a user's home directory
Directory home() {
  final env = Platform.environment;
  if (Platform.isWindows) {
    return Directory(env['UserProfile'] as String);
  }
  return Directory(env['HOME'] as String);
}

/// User platform
String userPlatform() {
  if (Platform.isWindows) {
    return 'windows';
  } else if (Platform.isLinux) {
    return 'linux';
  } else if (Platform.isMacOS) {
    return 'macos';
  } else if (Platform.isAndroid) {
    // not sure if its needed, but oh well
    return 'android';
  }
  return 'common';
}

// A Tldr Directory should basically look like this
// ```
// -- .tldr -> root file
//     -- config.toml -> config file
//     -- cache/ -> cache directory. Usually handled by the app
//         -- index.json -> index file that comes with tldr.zip
//         -- pages -> individual pages dirs for diff langs
//         -- pages.sh
//         -- pages.<lang>
//             -- android -> individual platform directories for the language
//                 -- ...pages -> several page files
//             -- linux
//                 -- ...pages
// ```

/// Paths to several folders and filers necessary for the programme
class TldrDir {
  late Directory root;
  late Directory cache;
  late File config;
  late File index;
  
  TldrDir(String rootPath) {
    root = Directory(rootPath);
    cache = Directory(join(rootPath, 'cache'));
    config = File(join(rootPath, 'config.toml'));
    index = File(join(cache.path, 'index.json'));
  }

  /// Default values. 
  /// 
  /// The default location is `~/.tldr` directory
  static TldrDir defaults() {
    return TldrDir(join(home().path, '.tldr'));
  }
}