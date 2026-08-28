/// Thrown when hide fails before vault copy is complete.
class VaultHideException implements Exception {
  VaultHideException([this.message = _defaultMessage]);

  static const _defaultMessage =
      'Hide failed — your original photo was not touched';

  final String message;

  @override
  String toString() => message;
}
