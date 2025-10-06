part of '../widgets.dart';

class _ParentRectClipper extends CustomClipper<Rect> {
  final Rect parentRect;
  final RenderBox renderBox;
  final double verticalPadding;
  final double horizontalPadding;

  const _ParentRectClipper({
    required this.parentRect,
    required this.renderBox,
    required this.verticalPadding,
    required this.horizontalPadding,
  });

  @override
  Rect getClip(Size size) {
    final parentRectWithPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ).inflateRect(parentRect);

    final paddingOffset = Offset(horizontalPadding, verticalPadding);

    final topLeft =
        renderBox.globalToLocal(parentRectWithPadding.topLeft + paddingOffset);

    final bottomRight = renderBox
        .globalToLocal(parentRectWithPadding.bottomRight + paddingOffset);

    return Rect.fromPoints(topLeft, bottomRight);
  }

  @override
  bool shouldReclip(covariant _ParentRectClipper oldClipper) => true;
}
