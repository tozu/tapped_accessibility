part of 'widgets.dart';

/// A widget that provides accessibility features and focus management.
///
/// The [AccessibleBuilder] widget enhances the accessibility of its child
/// by managing focus and providing a way to handle submit actions.
///
/// This widget is useful for creating custom interactive elements that
/// need to be accessible and focusable.
class AccessibleBuilder extends StatefulWidget {
  /// Callback function that is called when the widget is submitted
  /// (e.g., tapped or activated via keyboard).
  final VoidCallback onSubmit;

  /// An optional label used for debugging focus-related issues.
  ///
  /// This label is passed to the underlying [Focus] widget to help
  /// identify this focusable area during debugging.
  final String? focusDebugLabel;

  /// A builder function that creates the child widget.
  ///
  /// This function takes two parameters:
  /// - [BuildContext] for the current build context
  /// - [bool] indicating whether the widget currently has focus
  ///
  /// Use this to create a widget that can visually respond to focus changes.
  final Widget Function(BuildContext context, bool isFocused) builder;

  final ValueChanged<bool>? onFocusChange;

  const AccessibleBuilder({
    super.key,
    required this.onSubmit,
    required this.builder,
    this.onFocusChange,
    this.focusDebugLabel,
  });

  @override
  State<AccessibleBuilder> createState() => _AccessibleBuilderState();
}

class _AccessibleBuilderState extends State<AccessibleBuilder> {
  bool _hasFocus = false;

  late final _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activateOnIntent),
    ButtonActivateIntent:
        CallbackAction<ButtonActivateIntent>(onInvoke: _activateOnIntent),
  };

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: _actionMap,
      child: Focus(
        includeSemantics: false,
        debugLabel: widget.focusDebugLabel,
        onFocusChange: (isFocused) {
          setState(() => _hasFocus = isFocused);

          widget.onFocusChange?.call(isFocused);
        },
        child: Builder(
          builder: (context) {
            return widget.builder(context, _hasFocus);
          },
        ),
      ),
    );
  }

  void _activateOnIntent(Object intent) {
    Feedback.forTap(context);
    widget.onSubmit();
  }
}
