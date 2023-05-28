// ignore_for_file: constant_identifier_names

/// Set of errors to be used for handling specific events
enum Errors {
  InvalidIndex,
  InvalidCommand,
  MissingIndex,
  MissingCache,
  MissingCommandFile,
  InvalidCommandLang,
  InvalidCommandPlatform,
  InvalidDefaultPlatform,
}

/// Exceptions thrown by the library
class LibException implements Exception {
  final Errors code;
  final String? message;
  const LibException(this.code, {this.message});
}
