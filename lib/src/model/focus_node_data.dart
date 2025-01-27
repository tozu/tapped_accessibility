import 'package:flutter/cupertino.dart';

class FocusNodeData {
  final BuildContext context;
  final RenderBox renderBox;
  final RenderBox? parentScrollableRenderBox;

  FocusNodeData({
    required this.context,
    required this.renderBox,
    required this.parentScrollableRenderBox,
  });

  HighlightPosition getPosition() {
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final childRect = offset & size;
    final parentRect = parentScrollableRenderBox?.toRect();

    return HighlightPosition(
      focusNodeContext: context,
      offset: offset,
      size: size,
      rect: childRect,
      parentRect: parentRect,
    );
  }
}

class HighlightPosition {
  final Size size;
  final Offset offset;
  final BuildContext focusNodeContext;

  final Rect rect;
  final Rect? parentRect;

  HighlightPosition({
    required this.size,
    required this.offset,
    required this.focusNodeContext,
    required this.rect,
    required this.parentRect,
  });
}

extension on RenderBox {
  Rect toRect() {
    return localToGlobal(Offset.zero) & size;
  }
}

extension RectExtensions on Rect {
  bool containsRect(Rect other) {
    return contains(other.topLeft) || contains(other.bottomRight);
  }
}
