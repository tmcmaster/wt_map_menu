import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:wt_map_menu/wt_map_menu.dart';
import 'package:wt_map_menu_examples/data_provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DevicePreview(
          backgroundColor: Colors.white,
          builder: (context) => SafeArea(
            child: MapMenu(
              title: 'Select from an Index',
              mapProvider: ExampleMapData.provider,
            ),
          ),
        ),
      ),
    );
  }
}
