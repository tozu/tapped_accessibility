part of '../../tapped_accessibility.dart';

class AccessibilityTheme {
  final EdgeInsets padding;
  final BoxDecoration decoration;

  AccessibilityTheme({required this.padding, required this.decoration});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityTheme &&
          runtimeType == other.runtimeType &&
          padding == other.padding &&
          decoration == other.decoration;

  @override
  int get hashCode => padding.hashCode ^ decoration.hashCode;

  @override
  String toString() {
    return 'AccessibilityTheme{padding: $padding, decoration: $decoration}';
  }
}
