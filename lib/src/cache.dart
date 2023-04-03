import 'dart:io' show File;
import 'dart:convert' show jsonDecode;
import 'package:path/path.dart' show join;
import 'error.dart';
import 'util.dart';

/// The index file mapped to a dart class
class Index {
  final String filePath;
  final _commands = <String, Command>{};
  Index(this.filePath) {
    final indexFile = File(filePath);
    if (!indexFile.existsSync()) {
      throw LibException(Errors.MissingIndex);
    }
    final content = indexFile.readAsStringSync();
    final json =
        jsonDecode(content.isNotEmpty ? content : '{}') as Map<String, dynamic>;
    if (!json.containsKey('commands')) {
      throw LibException(Errors.InvalidIndex);
    }
    for (final v in json['commands']) {
      _commands[v['name'] as String] = Command(v as Map<String, dynamic>);
    }
  }

  Map<String, Command> get commands => _commands;

  /// Get a command
  Command? get(String name) {
    return _commands[name];
  }
}

/// Represents a command
class Command {
  late final String name;
  final List<String> platforms = [];
  final List<String> languages = [];

  Command(Map<String, dynamic> map) {
    name = map['name'] as String;

    for (final v in (map['platform'] as List<dynamic>)) {
      platforms.add(v as String);
    }

    for (final v in (map['language'] as List<dynamic>)) {
      languages.add(v as String);
    }
  }

  /// Read the corresponding file for a command and return its content
  String? getContent(String cachePath,
      {String language = 'en', String? platform}) {
    if (!languages.contains(language)) {
      throw LibException(Errors.InvalidCommandLang);
    }
    if (platform is String && !platforms.contains(platform)) {
      throw LibException(Errors.InvalidCommandPlatform);
    } else {
      platform = userPlatform();
      if (!platforms.contains(platform)) {
        platform = 'common';
        if (!platforms.contains(platform)) {
          throw LibException(Errors.InvalidDefaultPlatform);
        }
      }
    }
    final dir = language == 'en' ? 'pages' : 'pages.$language';
    final file = File(join(cachePath, dir, platform, '$name.md'));
    if (!file.existsSync()) {
      throw LibException(Errors.MissingCommandFile, message: file.path);
    }
    return file.readAsStringSync();
  }

  @override
  String toString() {
    return """{
      name: $name,
      platform: $platforms,
      language: $languages,
    }""";
  }
}
