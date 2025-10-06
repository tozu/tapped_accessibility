import 'package:flutter/widgets.dart';

class FocusNodeData {
  final BuildContext context;
  final RenderBox renderBox;
  final RenderBox? parentScrollableRenderBox;

  const FocusNodeData({
    required this.context,
    required this.renderBox,
    required this.parentScrollableRenderBox,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusNodeData &&
          runtimeType == other.runtimeType &&
          context == other.context &&
          renderBox == other.renderBox &&
          parentScrollableRenderBox == other.parentScrollableRenderBox;

  @override
  int get hashCode =>
      context.hashCode ^
      renderBox.hashCode ^
      parentScrollableRenderBox.hashCode;
}
