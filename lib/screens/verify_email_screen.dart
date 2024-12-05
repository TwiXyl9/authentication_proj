import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/authentication_controller.dart';
import '../widgets/custom_snackbar.dart';
import 'account_screen.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool canResendEmail = true;
  Timer? timer;

  @override
  Widget build(BuildContext context) {

    Future<void> sendVerificationEmail() async {
      try {
        final user = ref.read(authControllerProvider.notifier).getCurrentUser();

        if(user != null) await user.sendEmailVerification();

        setState(() => canResendEmail = false);
        await Future.delayed(const Duration(seconds: 20));
        setState(() => canResendEmail = true);
      } catch (e) {
        if (mounted) {
          CustomSnackBar.showSnackBar(
            context,
            '$e',
            true,
          );
        }
      }
    }



    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Email verification'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'A confirmation email has been sent to your email.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: canResendEmail ? sendVerificationEmail : null,
                icon: const Icon(Icons.email),
                label: const Text('Resend'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  timer?.cancel();
                  await ref.read(authControllerProvider.notifier).signOut();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}