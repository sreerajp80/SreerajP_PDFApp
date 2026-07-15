import 'package:flutter/material.dart';

/// Neutral, context-free widget shown in **release** builds when a widget fails
/// to build (wired via `ErrorWidget.builder` in `main()`) — engineering
/// standard §11.1. It shows no exception text and has no controls that could
/// fail the same way.
class SafeErrorFallback extends StatelessWidget {
  const SafeErrorFallback({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a self-contained theme so this works even outside a MaterialApp.
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Color(0xFF1C1B1F),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Something went wrong on this screen.\nPlease go back and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
