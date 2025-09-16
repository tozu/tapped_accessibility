import 'package:flutter/widgets.dart';

class HighlightPosition {
  final Size size;
  final Offset offset;
  final BuildContext focusNodeContext;
  final RenderBox renderBox;
  final Rect? parentRect;

  const HighlightPosition({
    required this.size,
    required this.offset,
    required this.focusNodeContext,
    required this.renderBox,
    required this.parentRect,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightPosition &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          offset == other.offset &&
          focusNodeContext == other.focusNodeContext &&
          renderBox == other.renderBox &&
          parentRect == other.parentRect;

  @override
  int get hashCode =>
      size.hashCode ^
      offset.hashCode ^
      focusNodeContext.hashCode ^
      renderBox.hashCode ^
      parentRect.hashCode;
}
