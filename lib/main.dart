import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: CrashTest())));

class CrashTest extends StatelessWidget {
  const CrashTest({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('DART EN FORCE 🚀', style: TextStyle(fontSize: 24)));
  }
}
