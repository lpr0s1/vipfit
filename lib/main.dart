import 'package:flutter/material.dart';

void main() => runApp(const VipFitApp());

class VipFitApp extends StatelessWidget {
  const VipFitApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Test Minimum'))),
    );
  }
}
