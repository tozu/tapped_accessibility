part of '../../tapped_accessibility.dart';

/// This class encapsulates the styling information used for
/// a focused element.
/// The visuals for a focused element can be overridden by wrapping the focusable child in another
/// [AccessibilityTheme] widget.
class AccessibilityThemeData {
  /// The padding to be applied to accessibility UI elements.
  ///
  /// This defines the space between the content and the edges of the UI element.
  final double padding;

  /// The decoration to be applied to accessibility UI elements.
  ///
  /// This defines the visual appearance of the UI element, such as
  /// background color, border, and shape.
  final BoxDecoration decoration;

  AccessibilityThemeData({required this.padding, required this.decoration});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityThemeData &&
          runtimeType == other.runtimeType &&
          padding == other.padding &&
          decoration == other.decoration;

  @override
  int get hashCode => padding.hashCode ^ decoration.hashCode;

  @override
  String toString() {
    return 'AccessibilityThemeData{padding: $padding, decoration: $decoration}';
  }
}
