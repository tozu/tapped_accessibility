part of '../tapped_accessibility.dart';

/// A widget that provides accessibility theme data to its descendants.
class AccessibleTheme extends InheritedWidget {
  /// The accessibility theme data to be provided to descendants.
  final AccessibilityThemeData accessibilityTheme;

  const AccessibleTheme({
    super.key,
    required super.child,
    required this.accessibilityTheme,
  });

  @override
  bool updateShouldNotify(covariant AccessibleTheme oldWidget) {
    return oldWidget.accessibilityTheme != accessibilityTheme;
  }

  static AccessibilityThemeData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AccessibleTheme>()!
        .accessibilityTheme;
  }
}
