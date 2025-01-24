part of '../tapped_accessibility.dart';

/// Inherited widget that provides information about hardware keyboard usage.
///
/// Use [isEnabled] to check if a hardware keyboard is being used in descendant widgets.
class HardwareKeyboardUsage extends InheritedWidget {
  /// Indicates whether a hardware keyboard is currently being used.
  final bool isHardwareKeyboardUsed;

  const HardwareKeyboardUsage({
    super.key,
    required this.isHardwareKeyboardUsed,
    required super.child,
  });

  static bool isEnabled(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<HardwareKeyboardUsage>();
    assert(result != null, 'No HardwareKeyboardUsage found in context');
    return result!.isHardwareKeyboardUsed;
  }

  @override
  bool updateShouldNotify(HardwareKeyboardUsage oldWidget) {
    return oldWidget.isHardwareKeyboardUsed != isHardwareKeyboardUsed;
  }
}
