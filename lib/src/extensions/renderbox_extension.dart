import 'package:flutter/widgets.dart';

extension RenderBoxExtension on RenderBox {
  Rect toRect() {
    return localToGlobal(Offset.zero) & size;
  }
}
