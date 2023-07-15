import 'package:flutter/material.dart';

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      ':-)',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 36,
        color: Colors.blue,
      ),
    );
  }
}
