import 'dart:io' show stderr;

/// Print debug logs. This should only print them if DEBUG env is set to 1
void debug(dynamic message) {}

/// Print errors to std err
void eprint(dynamic error) {
  stderr.writeln(error);
}
