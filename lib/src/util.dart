import 'dart:io' show stderr;

void debug(dynamic message) {}

void eprint(dynamic error) {
  stderr.writeln(error);
}