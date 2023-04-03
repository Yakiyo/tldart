import 'package:fast_tldr/fast_tldr.dart';
import 'package:args/args.dart' show ArgResults;
import 'package:ansi/ansi.dart' show ansi;
import 'dart:io' show exit;

void main(List<String> arguments) {
  late final ArgResults args;

  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    eprint("${ansi.red("FORMATERR:")} $e");
    exit(1);
  }

  print(args);
}
