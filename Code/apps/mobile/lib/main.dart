import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: SanayaApp()));
}

/// Scaffold minimal (FM-01b) : thème et go_router arrivent en FM-01d.
class SanayaApp extends StatelessWidget {
  const SanayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Sanaya')),
      ),
    );
  }
}
