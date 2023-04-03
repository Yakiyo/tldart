import 'dart:io' show stderr, Platform;
import 'package:args/args.dart' show ArgParser;
import '../fast_tldr.dart';

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


void showHelp(ArgParser parser) {
  print("""tldr $version
  
USAGE:
  tldr [OPTIONS] [ARGUMENTS]
  Example: tldr -p linux git log

ARGUMENTS:
  The command to show (e.g. `cp` or `mv`)
  
OPTIONS:
  ${parser.usage.split("\n").join("\n  ")}
""");
  return;
}