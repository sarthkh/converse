import 'package:converse/converse_app.dart';
import 'package:converse/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "1650599232100330",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
  );
  FlutterNativeSplash.remove();

  final prefs = await SharedPreferences.getInstance();
  final themeModeString = prefs.getString("themeMode") ?? "light";

  AdaptiveThemeMode initialThemeMode;
  if (themeModeString == "dark") {
    initialThemeMode = AdaptiveThemeMode.dark;
  } else {
    initialThemeMode = AdaptiveThemeMode.light;
  }

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    ProviderScope(
      child: ConverseApp(
        initialThemeMode: initialThemeMode,
      ),
    ),
  );
}
