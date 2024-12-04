import 'package:authentication_proj/routes_names.dart';
import 'package:authentication_proj/services/firebase_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/account_screen.dart';
import '../screens/authentication_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/verify_email_screen.dart';

class NavigationHelper {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
          path: rootRoute,
          builder: ((context, state) => const FirebaseStream())
      ),
      GoRoute(path: authenticationRoute, builder: ((context, state) => AuthenticationScreen())),
      GoRoute(path: registrationRoute, builder: ((context, state) => RegistrationScreen())),
      GoRoute(path: verifyEmailRoute, builder: ((context, state) => const VerifyEmailScreen())),
      GoRoute(path: accountRoute, builder: ((context, state) => const AccountScreen())),
      GoRoute(path: resetPasswordRoute, builder: ((context, state) => const ResetPasswordScreen())),
    ],
    redirect: (context, state) async {
      if (state.fullPath == accountRoute && FirebaseAuth.instance.currentUser == null) return rootRoute;
      return null;
    },
  );

  void navigateTo(String routeName, {data = null}){
    router.push(routeName, extra: data);
  }

  void navigateToWithParams(String routeName, Map<String, String> params){
    router.pushNamed(routeName, pathParameters: params);
  }

  void goBack(){
    router.pop();
  }
}