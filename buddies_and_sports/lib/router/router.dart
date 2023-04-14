import 'package:buddies_and_sports/components/app_shell.dart';
import 'package:buddies_and_sports/router/route_names.dart';
import 'package:buddies_and_sports/screens/auth/login_page.dart';
import 'package:buddies_and_sports/screens/auth/phone_auth_page.dart';
import 'package:buddies_and_sports/screens/auth/register_page.dart';
import 'package:buddies_and_sports/screens/auth/update_username_page.dart';
import 'package:buddies_and_sports/screens/auth/verification_page.dart';
import 'package:buddies_and_sports/screens/blank_pages.dart';
import 'package:buddies_and_sports/screens/profile_page.dart';
import 'package:buddies_and_sports/screens/select_interest_page.dart';
import 'package:buddies_and_sports/screens/settings_page.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _navBarNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'NavBar Shell');

/// Router configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: _getInitialRoute(),
  //redirect: (_, __) => _getInitialRoute(),

  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.home,
      name: Routes.home,
      redirect: (_, __) => Routes.discover,
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.selectInterest,
      name: Routes.selectInterest,
      builder: (_, __) => const SelectInterestPage(),
    ),
    ShellRoute(
      navigatorKey: _navBarNavigatorKey,
      routes: _navigationBarRoutes,
      builder: (_, __, Widget child) => AppShell(child: child),
    ),
    ..._authenticationRoutes,
  ],
);

///These are the routes for authentication
final _authenticationRoutes = <RouteBase>[
  GoRoute(
    path: Routes.signIn,
    name: Routes.signIn,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (_, __) => const SignInPage(),
    routes: [
      GoRoute(
        path: Routes.verify,
        name: Routes.verify,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const VerificationPage(),
      ),
    ],
  ),
  GoRoute(
    path: Routes.register,
    name: Routes.register,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (_, __) => const RegisterPage(),
  ),
  GoRoute(
    path: Routes.updateUsername,
    name: Routes.updateUsername,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (_, __) => const UpdateUsernamePage(),
  ),
  GoRoute(
    path: Routes.phoneAuth,
    name: Routes.phoneAuth,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (_, __) => const PhoneAuthPage(),
  ),
];

/// These are routes on the navigation bar
final _navigationBarRoutes = <RouteBase>[
  GoRoute(
    path: Routes.discover,
    name: Routes.discover,
    parentNavigatorKey: _navBarNavigatorKey,
    builder: (_, __) => const DiscoverPage(),
  ),
  GoRoute(
    path: Routes.buddies,
    name: Routes.buddies,
    parentNavigatorKey: _navBarNavigatorKey,
    builder: (_, __) => const BuddiesPage(),
  ),
  GoRoute(
    path: Routes.profile,
    name: Routes.profile,
    parentNavigatorKey: _navBarNavigatorKey,
    builder: (_, __) => const ProfilePage(),
  ),
  GoRoute(
    path: Routes.settings,
    name: Routes.settings,
    parentNavigatorKey: _navBarNavigatorKey,
    builder: (_, __) => const SettingsPage(),
  ),
];

///This function decides what route to open first when the app starts
String _getInitialRoute() {
  final prefs = GetIt.I<SharedPreferences>();
  final hasOnboarded = prefs.getBool(PrefKeys.onboardingKey) ?? false;
  final auth = FirebaseAuth.instance;
  final currentUserHasEmail = auth.currentUser?.email != null;

  if (auth.currentUser == null) return Routes.signIn;

  if (currentUserHasEmail && !auth.currentUser!.emailVerified) {
    //returns the fullpath of the verify page
    return '${Routes.signIn}/${Routes.verify}';
  }

  if (hasOnboarded) return Routes.home;

  if (!hasOnboarded) return Routes.selectInterest;

  return Routes.signIn;
}
