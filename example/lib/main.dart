import 'package:flutter/material.dart';
import 'package:tapped_accessibility/tapped_accessibility.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Page(),
      builder: (context, child) {
        return FocusHighlight(
          defaultTheme: AccessibilityThemeData(
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
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tapped Accessibility'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 8,
          children: [
            AccessibleTheme(
              accessibilityTheme: AccessibilityThemeData(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              child: FilledButton(onPressed: () {}, child: Text("First custom")),
            ),
            AccessibleTheme(
              accessibilityTheme: AccessibilityThemeData(
                padding: EdgeInsets.only(left: 0, right: 12, top: 6, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              child: FilledButton(onPressed: () {}, child: Text("Second custom")),
            ),
            FilledButton(onPressed: () {}, child: Text("3")),
            FilledButton(onPressed: () {}, child: Text("4")),
            FilledButton(onPressed: () {}, child: Text("5")),
            FilledButton(onPressed: () {}, child: Text("6")),
          ],
        ),
      ),
    );
  }
}
