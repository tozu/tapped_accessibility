# tapped_accessibility

TODO explain why ?

Need to be in the builder of the materialApp:

@override
Widget build(BuildContext context) {
return MaterialApp(
home: _Page(),
builder: (context, child) {
return FocusHighlight(
defaultTheme: AccessibilityTheme(
padding: EdgeInsets.all(8),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: Colors.green,
width: 2,
),
),
),
child: child!,
);
},
);
}

not in the home!!
