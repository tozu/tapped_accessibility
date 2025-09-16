import 'package:flutter/widgets.dart';
import 'package:tapped_accessibility/src/theme/theme.dart';

/// A widget that provides accessibility theme data to its descendants.
///
/// This widget is typically passed into [FocusHighlight.defaultTheme] at
/// the root of your application to define the default accessibility theme.
/// However, it can also be used to customize the visuals of specific components
/// by wrapping them in an [AccessiblityTheme].
///
/// Example:
///
/// ```dart
/// // Root theme defined in FocusHighlight
/// FocusHighlight(
///   defaultTheme: AccessibilityThemeData(/* default properties */)
///   child: MaterialApp(
///     home: Scaffold(
///       body: Center(
///         child: Column(
///           children: [
///             ElevatedButton(
///               onPressed: () {},
///               child: Text('Default Button'),
///             ),
///             // Customizing a specific button
///             AccessibleTheme(
///               accessibilityTheme: AccessibilityThemeData(/* custom properties for this button only */),
///               child: ElevatedButton(
///                 onPressed: () {},
///                 child: Text('Custom Themed Button'),
///               ),
///             ),
///           ],
///         ),
///       ),
///     ),
///   ),
/// )
/// ```
///
/// In this example, the second button will have a green focus indicator
/// with a width of 4.0, while other components will use the default theme.
class AccessibilityTheme extends InheritedWidget {
  /// The accessibility theme data to be provided to descendants.
  final AccessibilityThemeData accessibilityTheme;

  const AccessibilityTheme({
    super.key,
    required super.child,
    required this.accessibilityTheme,
  });

  @override
  bool updateShouldNotify(covariant AccessibilityTheme oldWidget) {
    return oldWidget.accessibilityTheme != accessibilityTheme;
  }

  static AccessibilityThemeData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AccessibilityTheme>()!
        .accessibilityTheme;
  }
}
