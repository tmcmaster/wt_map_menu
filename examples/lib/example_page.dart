import 'package:flutter/material.dart';
import 'package:wt_map_menu/example_widget.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExampleWidget(),
          ],
        ),
      ),
    );
  }
}
