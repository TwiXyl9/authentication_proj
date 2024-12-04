import 'package:authentication_proj/screens/authentication_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../general_providers.dart';
import '../screens/account_screen.dart';
import '../screens/verify_email_screen.dart';

class FirebaseStream extends ConsumerWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: ref.read(firebaseAuthProvider).authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text('Что-то пошло не так!')));
        } else if (snapshot.hasData) {
          if (!snapshot.data!.emailVerified &&
              snapshot.data!.providerData.first.providerId == 'password') {
            return const VerifyEmailScreen();
          }
          return const AccountScreen();
        } else {
          return AuthenticationScreen();
        }
      },
    );
  }
}