part of '../../tapped_accessibility.dart';

class AccessibilityThemeData {
  final EdgeInsets padding;
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
