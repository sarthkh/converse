import 'package:converse/pages/conclave/screens/conclave_screen.dart';
import 'package:converse/pages/conclave/screens/craft_conclave_screen.dart';
import 'package:converse/pages/home/home.dart';
import 'package:converse/pages/login/login.dart';
import 'package:converse/pages/signup/signup.dart';
import 'package:converse/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loggedOut = GoRouter(
  routes: [
    GoRoute(
      name: 'welcome',
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        child: Welcome(),
      ),
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
        if (onboardingComplete) {
          return '/login';
        }
        return null;
      },
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(
        child: Login(),
      ),
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      pageBuilder: (context, state) => const MaterialPage(
        child: SignUp(),
      ),
    ),
  ],
);

final loggedIn = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(
        child: Home(),
      ),
    ),
    GoRoute(
      name: 'craft-conclave-screen',
      path: '/craft-conclave',
      pageBuilder: (context, state) => const MaterialPage(
        child: CraftConclaveScreen(),
      ),
    ),
    GoRoute(
      name: 'conclave-screen',
      path: '/c/:name',
      pageBuilder: (context, state) => MaterialPage(
        child: ConclaveScreen(
          name: state.pathParameters['name']!,
        ),
      ),
    ),
  ],
);
