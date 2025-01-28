part of '../tapped_accessibility.dart';

/// A widget that provides visual focus highlighting for keyboard navigation.
///
/// This widget provides a focus highlight for keyboard navigation by
/// overlaying a visual indicator on top of the focused element.
/// It continuously updates the position and size of the highlight to
/// ensure accurate placement, even during scrolling or layout changes.
///
/// The highlight is displayed as a separate overlay layer above the child widget.
/// This overlay technique was chosen to ensure that individual widgets don't require any specific styling,
/// enabling the focus highlight to work out of the box without modifying your existing components.
/// As a result, this approach provides a non-intrusive, universally applicable focus highlighting solution
/// that can be easily integrated into existing applications with minimal changes to the existing widget structure.
///
/// Wrap this around the widget of your [MaterialApp.builder] and provide
/// the [defaultTheme].
///
/// Example usage:
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return FocusHighlight(
///       defaultTheme: AccessibilityThemeData(
///         decoration: BoxDecoration(
///           border: Border.all(color: Colors.blue, width: 2),
///           borderRadius: BorderRadius.circular(4),
///         ),
///         padding: const EdgeInsets.all(4),
///       ),
///       child: child!,
///     );
///   },
///   home: MyHomePage(),
/// )
/// ```
class FocusHighlight extends StatefulWidget {
  /// The widget to be wrapped.
  final Widget child;

  /// The default accessibility theme to be applied.
  /// You are able to override the theme for specific elements by wrapping it
  /// in another [AccessibilityThemeData].
  final AccessibilityThemeData defaultTheme;

  /// A list of keyboard keys that, when pressed, will activate the focus highlight.
  ///
  /// By default, this includes only the Tab key.
  final List<LogicalKeyboardKey> activateKeys;

  /// A list of keyboard keys that, when pressed, will keep the focus highlight active.
  ///
  /// By default, this includes the Tab key and arrow keys (up, down, left, right).
  final List<LogicalKeyboardKey> keepActiveKeys;

  const FocusHighlight({
    required this.child,
    required this.defaultTheme,
    this.activateKeys = const [LogicalKeyboardKey.tab],
    this.keepActiveKeys = const [
      LogicalKeyboardKey.tab,
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
    ],
    super.key,
  });

  @override
  State<FocusHighlight> createState() => _FocusHighlightState();
}

class _FocusHighlightState extends State<FocusHighlight> {
  bool _isTabPressed = false;

  @override
  Widget build(BuildContext context) {
    return AccessibleTheme(
      accessibilityTheme: widget.defaultTheme,
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (widget.activateKeys.contains(event.logicalKey)) {
              // Whenever the user uses the tab-key, we want to enable the help
              _activateTabMode();
            }

            if (!widget.keepActiveKeys.contains(event.logicalKey)) {
              // Whenever the user uses another button than the "tab",
              // we want to deactivate the tab-mode.
              _deactivateTabMode();
            }
          }

          return KeyEventResult.ignored;
        },
        child: Listener(
          // Whenever the user tabs somewhere, we want to deactivate the tab-mode.
          // onPointerDown: (_) => _deactivateTabMode(),
          child: _FocusableHighlight(
            showFocus: _isTabPressed,
            child: HardwareKeyboardUsage(
              isHardwareKeyboardUsed: _isTabPressed,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  void _activateTabMode() {
    if (_isTabPressed) return;

    setState(() => _isTabPressed = true);
  }

  void _deactivateTabMode() {
    if (!_isTabPressed) return;

    setState(() => _isTabPressed = false);
  }
}

class _FocusableHighlight extends StatefulWidget {
  final Widget child;
  final bool showFocus;

  const _FocusableHighlight({
    required this.child,
    required this.showFocus,
  });

  @override
  State<_FocusableHighlight> createState() => _FocusableHighlightState();
}

class _FocusableHighlightState extends State<_FocusableHighlight>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final _highlightPosition = ValueNotifier<HighlightPosition?>(null);
  FocusNodeData? _cachedFocusNodeData;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    FocusManager.instance.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _ticker.dispose();
    FocusManager.instance.removeListener(_onFocusChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _FocusableHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.showFocus != widget.showFocus) {
      // If we should show focus now, then trigger a focus changed event
      // to update the state. Otherwise stop the updates and reset state.
      widget.showFocus ? _onFocusChanged() : _resetTickerAndState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ListenableBuilder(
          listenable: _highlightPosition,
          builder: (context, _) {
            final position = _highlightPosition.value;

            if (position == null) {
              return const SizedBox();
            }

            return _FocusHighlightIndicator(highlightPosition: position);
          },
        ),
      ],
    );
  }

  // region callbacks

  void _onTick(Duration elapsed) {
    _refreshFocusOverlay(cachedFocusNodeData: _cachedFocusNodeData);
  }

  void _onFocusChanged() {
    if (!widget.showFocus) {
      return;
    }
    _refreshFocusOverlay(cachedFocusNodeData: null);
  }

  // endregion

  /// [cachedFocusNodeData] is an optional parameter that can be used to provide a
  /// pre-fetched render box, potentially optimizing performance by avoiding
  /// redundant lookups.
  ///
  /// If no valid focused element is found, or if the position is invalid,
  /// the method will reset the ticker and state.
  void _refreshFocusOverlay({required FocusNodeData? cachedFocusNodeData}) {
    // Use the provided cached focus data or fetch the currently focused one
    final focusNodeData = cachedFocusNodeData ?? _getPrimaryFocusNodeData();

    if (focusNodeData == null) {
      _resetTickerAndState();
      return;
    }
    _cachedFocusNodeData = focusNodeData;

    final newPosition = focusNodeData.getPosition();
    if (newPosition.offset.dy.isNaN || newPosition.offset.dx.isNaN) {
      _resetTickerAndState();
      return;
    }

    if (newPosition == _highlightPosition.value) return;
    _highlightPosition.value = newPosition;

    // Start the ticker if it's not already active which will
    // make sure that we update the overlay on every frame.
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  FocusNodeData? _getPrimaryFocusNodeData() {
    final focusNode = FocusManager.instance.primaryFocus;
    final focusContext = focusNode?.context;

    if (focusContext == null) return null;

    final scrollableRenderBox = Scrollable.maybeOf(focusContext)
        ?.context
        .findRenderObject() as RenderBox?;

    return FocusNodeData(
      context: focusContext,
      renderBox: focusContext.findRenderObject() as RenderBox,
      parentScrollableRenderBox: scrollableRenderBox,
    );
  }

  void _resetTickerAndState() {
    if (_ticker.isActive) {
      _ticker.stop();
    }
    _cachedFocusNodeData = null;
    _highlightPosition.value = null;
  }
}

class _FocusHighlightIndicator extends StatelessWidget {
  final HighlightPosition highlightPosition;

  const _FocusHighlightIndicator({required this.highlightPosition});

  @override
  Widget build(BuildContext context) {
    final theme = AccessibleTheme.of(highlightPosition.focusNodeContext);
    final position = highlightPosition.offset;
    final size = highlightPosition.size;

    final parentRect = highlightPosition.parentRect;

    return Positioned(
      left: position.dx - theme.padding.left,
      top: position.dy - theme.padding.top,
      child: Builder(
        builder: (context) {
          final child = IgnorePointer(
            child: Container(
              width: size.width + theme.padding.horizontal,
              height: size.height + theme.padding.vertical,
              foregroundDecoration: theme.decoration,
            ),
          );

          if (parentRect != null) {
            return ClipRect(
              clipper: _ParentRectClipper(
                parentRect: parentRect,
                context: context,
                padding: theme.padding,
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

class _ParentRectClipper extends CustomClipper<Rect> {
  final Rect parentRect;
  final BuildContext context;
  final EdgeInsets padding;

  _ParentRectClipper({
    required this.parentRect,
    required this.context,
    required this.padding,
  });

  @override
  Rect getClip(Size size) {
    final parentRectWithPadding = padding.inflateRect(parentRect);

    final renderBox = context.findRenderObject() as RenderBox;

    final topLeft = renderBox.globalToLocal(parentRectWithPadding.topLeft);
    final bottomRight =
        renderBox.globalToLocal(parentRectWithPadding.bottomRight);

    final localRect = Rect.fromPoints(topLeft, bottomRight);
    return localRect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}
