import 'package:converse/pages/conclave/screens/add_mods_screen.dart';
import 'package:converse/pages/conclave/screens/conclave_screen.dart';
import 'package:converse/pages/conclave/screens/craft_conclave_screen.dart';
import 'package:converse/pages/conclave/screens/edit_conclave_screen.dart';
import 'package:converse/pages/conclave/screens/mod_tools_screen.dart';
import 'package:converse/pages/home/home.dart';
import 'package:converse/pages/login/login.dart';
import 'package:converse/pages/post/screens/add_post_type_screen.dart';
import 'package:converse/pages/post/screens/post_comment_screen.dart';
import 'package:converse/pages/signup/signup.dart';
import 'package:converse/pages/user_profile/screens/edit_profile_screen.dart';
import 'package:converse/pages/user_profile/screens/user_profile_screen.dart';
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
    GoRoute(
      name: 'mod-tools-screen',
      path: '/mod-tools/:name',
      pageBuilder: (context, state) => MaterialPage(
        child: ModToolsScreen(
          name: state.pathParameters['name']!,
        ),
      ),
    ),
    GoRoute(
      name: 'edit-conclave-screen',
      path: '/edit-conclave/:name',
      pageBuilder: (context, state) => MaterialPage(
        child: EditConclaveScreen(
          name: state.pathParameters['name']!,
        ),
      ),
    ),
    GoRoute(
      name: 'add-mods-screen',
      path: '/add-mods/:name',
      pageBuilder: (context, state) => MaterialPage(
        child: AddModsScreen(
          name: state.pathParameters['name']!,
        ),
      ),
    ),
    GoRoute(
      name: 'user-profile-screen',
      path: '/u/:uId',
      pageBuilder: (context, state) => MaterialPage(
        child: UserProfileScreen(
          uId: state.pathParameters['uId']!,
        ),
      ),
    ),
    GoRoute(
      name: 'edit-profile-screen',
      path: '/edit-profile/:uId',
      pageBuilder: (context, state) => MaterialPage(
        child: EditProfileScreen(
          uId: state.pathParameters['uId']!,
        ),
      ),
    ),
    GoRoute(
      name: 'add-post-screen',
      path: '/add-post/:type',
      pageBuilder: (context, state) => MaterialPage(
        child: AddPostTypeScreen(
          type: state.pathParameters['type']!,
        ),
      ),
    ),
    GoRoute(
      name: 'post-comment-screen',
      path: '/post/:postId/comments',
      pageBuilder: (context, state) => MaterialPage(
        child: PostCommentScreen(
          postId: state.pathParameters['postId']!,
        ),
      ),
    ),
  ],
);
