part of '../widgets.dart';

class _FocusHighlightIndicator extends StatelessWidget {
  final HighlightPosition highlightPosition;

  const _FocusHighlightIndicator({required this.highlightPosition});

  @override
  Widget build(BuildContext context) {
    final theme = AccessibilityTheme.of(highlightPosition.focusNodeContext);
    final position = highlightPosition.offset;
    final size = highlightPosition.size;

    final parentRect = highlightPosition.parentRect;

    return Positioned(
      left: position.dx - theme.horizontalPadding,
      top: position.dy - theme.verticalPadding,
      child: Builder(
        builder: (context) {
          final child = IgnorePointer(
            child: Container(
              width: size.width + (theme.horizontalPadding * 2),
              height: size.height + (theme.verticalPadding * 2),
              foregroundDecoration: theme.decoration,
            ),
          );

          if (parentRect != null) {
            return ClipRect(
              clipper: _ParentRectClipper(
                parentRect: parentRect,
                renderBox: highlightPosition.renderBox,
                verticalPadding: theme.verticalPadding,
                horizontalPadding: theme.horizontalPadding,
              ),
              child: child,
            );
          } else {
            return child;
          }
        },
      ),
    );
  }
}
