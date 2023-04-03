import 'dart:io' show stderr, Platform;

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
