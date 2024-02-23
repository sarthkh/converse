import 'package:converse/auth/controller/auth_controller.dart';
import 'package:converse/common/widgets/error_text.dart';
import 'package:converse/common/widgets/loader.dart';
import 'package:converse/models/user_model.dart';
import 'package:converse/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:converse/theme/palette.dart';

class ConverseApp extends ConsumerStatefulWidget {
  final AdaptiveThemeMode initialThemeMode;

  const ConverseApp({
    super.key,
    required this.initialThemeMode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConverseAppState();
}

class _ConverseAppState extends ConsumerState<ConverseApp> {
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
                    final routerDelegate = data != null && userModel != null
                        ? loggedIn.routerDelegate
                        : loggedOut.routerDelegate;
                    final routeInformationParser =
                        data != null && userModel != null
                            ? loggedIn.routeInformationParser
                            : loggedOut.routeInformationParser;
                    final routeInformationProvider =
                        data != null && userModel != null
                            ? loggedIn.routeInformationProvider
                            : loggedOut.routeInformationProvider;

                    if (data != null) {
                      getData(ref, data);
                    }

                    return MaterialApp.router(
                      title: "Converse",
                      theme: theme,
                      darkTheme: darkTheme,
                      routerDelegate: routerDelegate,
                      routeInformationParser: routeInformationParser,
                      routeInformationProvider: routeInformationProvider,
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
