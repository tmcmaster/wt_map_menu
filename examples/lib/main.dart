import 'package:wt_app_scaffold/app_scaffolds.dart';
import 'package:wt_firepod/wt_firepod.dart';
import 'package:wt_logging/wt_logging.dart';
import 'package:wt_map_menu_examples/examples_app.dart';
import 'package:wt_map_menu_examples/firebase_options.dart';

void main() async {
  runMyApp(
    withFirebase(
      appName: 'wt-app-scaffold',
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      andAppScaffold(
        appDetails: MainApp.details,
        appDefinition: MainApp.definition,
        loginSupport: const LoginSupport(
          emailEnabled: true,
          googleEnabled: true,
        ),
        setApplicationLogLevel: Level.warning,
      ),
    ),
    includeObservers: [],
    includeOverrides: [],
    enableProviderMonitoring: false,
  );
}
