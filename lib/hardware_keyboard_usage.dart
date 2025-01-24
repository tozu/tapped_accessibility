import 'package:flutter/material.dart';

class HardwareKeyboardUsage extends InheritedWidget {
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
