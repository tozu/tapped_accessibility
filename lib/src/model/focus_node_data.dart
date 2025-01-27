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

    final isInsideParent = parentRect?.containsRect(childRect) ?? true;

    return HighlightPosition(
      focusNodeContext: context,
      offset: offset,
      size: size,
      isInsideParent: isInsideParent,
      localParentRect: renderBox.toLocalParentRect(parentRect: parentRect),
    );
  }
}

class HighlightPosition {
  final Size size;
  final Offset offset;
  final BuildContext focusNodeContext;
  final bool isInsideParent;
  final Rect? localParentRect;

  HighlightPosition({
    required this.size,
    required this.offset,
    required this.focusNodeContext,
    required this.isInsideParent,
    required this.localParentRect,
  });
}

extension RectExtensions on Rect {
  bool containsRect(Rect other) {
    return contains(other.topLeft) || contains(other.bottomRight);
  }
}

extension on RenderBox {
  Rect toRect() {
    return localToGlobal(Offset.zero) & size;
  }

  Rect? toLocalParentRect({required Rect? parentRect}) {
    if (parentRect == null) return null;

    return Rect.fromLTRB(
      globalToLocal(parentRect.topLeft).dx,
      globalToLocal(parentRect.topLeft).dy,
      globalToLocal(parentRect.bottomRight).dx,
      globalToLocal(parentRect.bottomRight).dy,
    );
  }
}
