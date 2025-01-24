part of '../tapped_accessibility.dart';

class InheritedAccessibleTheme extends InheritedWidget {
  final AccessibilityTheme accessibilityTheme;

  const InheritedAccessibleTheme({
    super.key,
    required super.child,
    required this.accessibilityTheme,
  });

  @override
  bool updateShouldNotify(covariant InheritedAccessibleTheme oldWidget) {
    return oldWidget.accessibilityTheme != accessibilityTheme;
  }

  static AccessibilityTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedAccessibleTheme>()!.accessibilityTheme;
  }
}
