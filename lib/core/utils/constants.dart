/// Shared infrastructure timing constants.
abstract final class CoreDurations {
  const CoreDurations._();

  /// Default delay used for debounced operations.
  static const debounce = Duration(milliseconds: 300);

  /// Default interval used for throttled operations.
  static const throttle = Duration(milliseconds: 300);
}
