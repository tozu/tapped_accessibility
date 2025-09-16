import 'package:flutter/widgets.dart';

import 'package:tapped_accessibility/src/model/models.dart';
import 'package:tapped_accessibility/src/extensions/extensions.dart';

extension FocusNodeDataExtension on FocusNodeData {
  HighlightPosition getPosition() {
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final parentRect = parentScrollableRenderBox?.toRect();

    return HighlightPosition(
      focusNodeContext: context,
      offset: offset,
      renderBox: renderBox,
      size: size,
      parentRect: parentRect,
    );
  }
}
