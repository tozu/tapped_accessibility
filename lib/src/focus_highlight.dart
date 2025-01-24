part of '../tapped_accessibility.dart';

class FocusHighlight extends StatefulWidget {
  final Widget child;

  const FocusHighlight({
    required this.child,
    super.key,
  });

  @override
  State<FocusHighlight> createState() => _FocusHighlightState();
}

class _FocusHighlightState extends State<FocusHighlight> {
  final _keysToActiveKeyboardSupport = [LogicalKeyboardKey.tab];

  final _keysToMaintainKeyboardSupport = [
    LogicalKeyboardKey.tab,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
  ];

  bool _isTabPressed = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (_keysToActiveKeyboardSupport.contains(event.logicalKey)) {
            // Whenever the user uses the tab-key, we want to enable the help
            _activateTabMode();
          }

          if (!_keysToMaintainKeyboardSupport.contains(event.logicalKey)) {
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

class _FocusableHighlightState extends State<_FocusableHighlight> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final _focusElementProperties = ValueNotifier<(Offset, Size)?>(null);
  RenderBox? _cachedFocusRenderBox;

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
          listenable: _focusElementProperties,
          builder: (context, _) {
            final properties = _focusElementProperties.value;
            if (!widget.showFocus || properties == null) {
              return const SizedBox();
            }

            final (position, size) = properties;
            return _FocusHighlightIndicator(size: size, position: position);
          },
        ),
      ],
    );
  }

  // region callbacks

  void _onTick(Duration elapsed) {
    _refreshFocusOverlay(cachedRenderBox: _cachedFocusRenderBox);
  }

  void _onFocusChanged() {
    if (!widget.showFocus) {
      return;
    }
    _refreshFocusOverlay(cachedRenderBox: null);
  }

  // endregion

  /// [cachedRenderBox] is an optional parameter that can be used to provide a
  /// pre-fetched render box, potentially optimizing performance by avoiding
  /// redundant lookups.
  ///
  /// If no valid focused element is found, or if the position is invalid,
  /// the method will reset the ticker and state.
  void _refreshFocusOverlay({required RenderBox? cachedRenderBox}) {
    // Use the provided cached render box or fetch the currently focused one
    final box = cachedRenderBox ?? _getPrimaryFocusRenderBox();
    if (box == null) {
      _resetTickerAndState();
      return;
    }

    _cachedFocusRenderBox = box;

    // Calculate the global position of the focused element
    final position = box.localToGlobal(Offset.zero);
    if (position.dy.isNaN || position.dx.isNaN) {
      _resetTickerAndState();
      return;
    }

    final size = box.size;
    final newFocusProperties = (position, size);

    if (newFocusProperties == _focusElementProperties.value) return;
    _focusElementProperties.value = newFocusProperties;

    // Start the ticker if it's not already active which will
    // make sure that we update the overlay on every frame.
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  RenderBox? _getPrimaryFocusRenderBox() {
    final focusNode = FocusManager.instance.primaryFocus;
    final focusContent = focusNode?.context;

    return focusContent?.findRenderObject() as RenderBox?;
  }

  void _resetTickerAndState() {
    if (_ticker.isActive) {
      _ticker.stop();
    }
    _cachedFocusRenderBox = null;
    _focusElementProperties.value = null;
  }
}

class _FocusHighlightIndicator extends StatelessWidget {
  static const _padding = 14.0;

  final Size size;
  final Offset position;

  const _FocusHighlightIndicator({
    required this.size,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - (_padding / 2),
      top: position.dy - (_padding / 2),
      child: IgnorePointer(
        child: Container(
          width: size.width + _padding,
          height: size.height + _padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: Colors.green, //TODO adjustable
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
