import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/firebase_options.dart';
import 'package:converse/models/user_model.dart';
import 'package:converse/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:converse/theme/palette.dart';

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
        initialThemeMode: initialThemeMode,
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final AdaptiveThemeMode initialThemeMode;

  const MyApp({
    super.key,
    required this.initialThemeMode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: Palette.lightTheme,
      dark: Palette.darkTheme,
      initial: widget.initialThemeMode,
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

            return ref.watch(authStateChangeProvider).when(
                  data: (data) {
                    if (data != null) {
                      getData(ref, data);
                      if (userModel != null) {
                        return MaterialApp.router(
                          title: "Converse",
                          theme: theme,
                          darkTheme: darkTheme,
                          routerDelegate: loggedIn.routerDelegate,
                          routeInformationParser:
                              loggedIn.routeInformationParser,
                          routeInformationProvider:
                              loggedIn.routeInformationProvider,
                          debugShowCheckedModeBanner: false,
                        );
                      }
                    }
                    return MaterialApp.router(
                      title: "Converse",
                      theme: theme,
                      darkTheme: darkTheme,
                      routerDelegate: loggedOut.routerDelegate,
                      routeInformationParser: loggedOut.routeInformationParser,
                      routeInformationProvider:
                          loggedOut.routeInformationProvider,
                      debugShowCheckedModeBanner: false,
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
          },
        );
      },
    );
  }
}
