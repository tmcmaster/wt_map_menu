import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wt_app_scaffold/app_scaffolds.dart';
import 'package:wt_app_scaffold/scaffolds/login/config.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_map_menu_examples/example_page.dart';

mixin MainApp {
  static final details = Provider<AppDetails>(
    name: 'MainApp Details',
    (ref) => AppDetails(
      title: 'MainApp',
      subTitle: 'First application',
      iconPath: 'assets/avocado.png',
    ),
  );

  static final definition = Provider<AppDefinition>(
    name: 'AppOne Definition',
    (ref) => AppDefinition.from(
      appTitle: 'Application One',
      appName: 'appOne',
      swipeEnabled: true,
      includeAppBar: true,
      appDetailsProvider: details,
      profilePage: PageDefinition(
        icon: Icons.person,
        title: 'Profile',
        builder: (context) => ProfileScreen(
          auth: ref.read(FirebaseProviders.auth),
          actions: [
            SignedOutAction((context) {
              Navigator.pushReplacementNamed(context, '/');
            }),
          ],
          actionCodeSettings: FirebaseAuthKeys.actionCodeSettings,
          showMFATile: false,
        ),
      ),
      pages: [
        PageDefinition(
          title: 'Landing Page',
          icon: FontAwesomeIcons.clipboard,
          debug: false,
          builder: (context) => const ExamplePage(),
        ),
        PageDefinition(
          title: 'Settings',
          icon: Icons.settings,
          primary: true,
          builder: (context) => SettingsPage(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/');
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
