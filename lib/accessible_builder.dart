import 'package:flutter/material.dart';


// TODO Rahmen wird gezeichet, ausserhalb der Box
// TODO fix me -> AccessibleArrowKeyScrollable weird
// TODO inheritedWidget für Styling -> AccessiblityTheme
// TODO  config -> if (!_keysToMaintainKeyboardSupport.contains(event.logicalKey)) {
//             // Whenever the user uses another button than the "tab",
//             // we want to deactivate the tab-mode.
//             _deactivateTabMode();
//           }
// TODO default config -> AccessiblityTheme -> color + EdgeInsert + Border/Line width + borderRadius -> BoxDecordation??
// -> TODO https://github.com/tappeddev/tapped_accessibility

class AccessibleBuilder extends StatefulWidget {
  final VoidCallback onSubmit;
  final String? focusDebugLabel;
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
