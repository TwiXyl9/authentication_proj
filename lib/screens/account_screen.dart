import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/authentication_controller.dart';
import '../helpers/navigation_helper.dart';
import '../locator.dart';
import '../routes_names.dart';
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = FirebaseAuth.instance.currentUser;

    Future<void> signOut() async {
      await ref.read(authControllerProvider.notifier).signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user!.email == null ?
            user.providerData.first.email ?? 'Undefined email' :
            user.email!
            ),
             if (user.providerData[0].providerId == 'password') TextButton(
              onPressed: () => locator<NavigationHelper>().navigateTo(resetPasswordRoute),
              child: const Text('Reset password'),
            ),
            TextButton(
              onPressed: () => signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
