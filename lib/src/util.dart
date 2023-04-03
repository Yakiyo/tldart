import 'dart:io' show stderr, Platform, Directory;
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
