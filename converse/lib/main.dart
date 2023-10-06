import 'package:converse/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:converse/theme/palette.dart';
import 'package:converse/pages/login/login.dart';
import 'package:converse/pages/signup/signup.dart';
import 'package:converse/pages/welcome/welcome.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Future.delayed(
    const Duration(milliseconds: 500),
  );
  FlutterNativeSplash.remove();

  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
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
      child: MyApp(
        onboardingComplete: onboardingComplete,
        initialThemeMode: initialThemeMode,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  final AdaptiveThemeMode initialThemeMode;

  const MyApp({
    Key? key,
    required this.onboardingComplete,
    required this.initialThemeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: Palette.lightTheme,
      dark: Palette.darkTheme,
      initial: initialThemeMode,
      builder: (theme, darkTheme) {
        return Builder(
          builder: (context) {
            final themeMode = AdaptiveTheme.of(context).mode;

            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: themeMode == AdaptiveThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark,
              ),
            );

            return MaterialApp(
              title: "Converse",
              theme: theme,
              darkTheme: darkTheme,
              initialRoute: onboardingComplete ? "login" : "/",
              routes: {
                "/": (context) => Welcome(),
                "login": (context) => const Login(),
                "signup": (context) => const SignUp(),
              },
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
