import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:converse/theme/palette.dart';
import 'package:converse/pages/login/login.dart';
import 'package:converse/pages/signup/signup.dart';
import 'package:converse/pages/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
  final themeModeString = prefs.getString("themeMode") ?? "light";

  AdaptiveThemeMode initialThemeMode;
  if (themeModeString == "dark") {
    initialThemeMode = AdaptiveThemeMode.dark;
  } else {
    initialThemeMode = AdaptiveThemeMode.light;
  }

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
    super.key,
    required this.onboardingComplete,
    required this.initialThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: Palette.lightTheme,
      dark: Palette.darkTheme,
      initial: initialThemeMode,
      builder: (theme, darkTheme) => MaterialApp(
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
      ),
    );
  }
}
