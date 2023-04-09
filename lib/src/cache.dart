import 'package:archive/archive_io.dart'
    show ZipDecoder, InputFileStream, extractArchiveToDisk;
import 'dart:io' show File, Directory;
import 'dart:convert' show jsonDecode;
import 'package:ansi/ansi.dart';
import 'package:path/path.dart' show join;
import 'package:http/http.dart' as http;
import 'error.dart';
import 'util.dart';

/// Archive url for the official zip file provided by tldr-sh
const _archiveUrl = "https://tldr.sh/assets/tldr.zip";

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
  final List<Target> targets = [];

  Command(Map<String, dynamic> map) {
    name = map['name'] as String;

    for (final v in (map['platform'] as List<dynamic>)) {
      platforms.add(v as String);
    }

    for (final v in (map['language'] as List<dynamic>)) {
      languages.add(v as String);
    }

    for (final v in map['targets']) {
      targets.add(Target(Map.from(v)));
    }
  }

  /// Read the corresponding file for a command and return its content
  String getContent(String cachePath,
      {String language = 'en', String? platform}) {
    if (!languages.contains(language)) {
      throw LibException(Errors.InvalidCommandLang);
    }
    if (platform is String &&
        (!platforms.contains(platform) ||
            !targets.any((e) => e.os == platform && e.language == language))) {
      throw LibException(Errors.InvalidCommandPlatform);
    } else {
      platform = userPlatform();
      debug("Using user platform $platform as default");
      // If it doesnt have any target for user platform with the provided language, switch to commong
      if (!platforms.contains(platform) ||
          !targets.any((e) => e.os == platform && e.language == language)) {
        debug("Switching platform to common from $platform");
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

/// A target class
class Target {
  late final String os;
  late final String language;

  Target(Map<String, String> dict) {
    os = dict['os'] as String;
    language = dict['language'] as String;
  }

  @override
  String toString() {
    return """{
      os: $os,
      language: $language
    }""";
  }
}

/// Update the local cache
///
/// tldrDir - the root of tldrDir, as in `~/.tldr` instead of `~/.tldr/cache`
Future<void> updateCache(Directory tldrDir) async {
  if (!tldrDir.existsSync()) {
    debug('Missing tldr dir, creating directory in ${tldrDir.path}');
    await tldrDir.create(recursive: true);
  }

  final cache = Directory(join(tldrDir.path, 'cache'));

  // If the directory exists, we move the current contents to `_cache` directory
  if (cache.existsSync()) {
    debug('Moving old `cache` dir to `_cache`');
    await cache.rename('_cache');
  }
  final zipFile = File(join(tldrDir.path, 'cache.zip'));

  debug("Downloading zip file from $_archiveUrl");
  final zip = await _downloadZip(zipFile);
  if (zip == null) return;

  debug('Extracting zip file');
  extractArchiveToDisk(
      ZipDecoder().decodeBuffer(InputFileStream(zipFile.path)), cache.path);

  debug("Deleting old pages directory");
  try {
    final oldCache = Directory(join(tldrDir.path, '_cache'));
    await oldCache.delete(recursive: true);
  } catch (_) {
    // ignore
  }
  return;
}

/// Download the `tldr.zip` archive and write it to `outputFile`
///
/// outputFile - `~/.tldr/cache.zip`
Future<File?> _downloadZip(File outputFile) async {
  if (outputFile.existsSync()) {
    await outputFile.delete(recursive: true);
  }
  late final http.Response res;
  try {
    res = await http.get(Uri.parse(_archiveUrl));
  } catch (e) {
    eprint('${ansi.red("HTTPERR:")} Error when fetching zip file.\n$e');
    return null;
  }
  await outputFile.writeAsBytes(res.bodyBytes);

  return outputFile;
}
