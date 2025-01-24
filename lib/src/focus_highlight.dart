part of '../tapped_accessibility.dart';

class FocusHighlight extends StatefulWidget {
  final Widget child;
  final AccessibilityThemeData defaultTheme;

  final List<LogicalKeyboardKey> activateKeys;
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
          onPointerDown: (_) => _deactivateTabMode(),
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
            if (!widget.showFocus ||
                position == null ||
                !position.isInsideParent) {
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

  const _FocusHighlightIndicator({
    required this.highlightPosition,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AccessibleTheme.of(highlightPosition.focusNodeContext);
    final position = highlightPosition.offset;
    final size = highlightPosition.size;

    return Positioned(
      left: position.dx - theme.padding.left,
      top: position.dy - theme.padding.top,
      child: IgnorePointer(
        child: Container(
          width: size.width + theme.padding.horizontal,
          height: size.height + theme.padding.vertical,
          decoration: theme.decoration,
        ),
      ),
    );
  }
}
