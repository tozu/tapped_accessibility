part of '../tapped_accessibility.dart';

class AccessibleTheme extends InheritedWidget {
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
    return context.dependOnInheritedWidgetOfExactType<AccessibleTheme>()!.accessibilityTheme;
  }
}
