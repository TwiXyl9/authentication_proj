import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/authentication_controller.dart';
import '../helpers/navigation_helper.dart';
import '../locator.dart';
import '../models/custom_exception.dart';
import '../routes_names.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text_field.dart';

class ResetPasswordScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ResetPasswordScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<CustomException?>(resetPasswordExceptionProvider, (previous, next) {
      CustomSnackBar.showSnackBar(
        context,
        next!.message!,
        true,
      );
    });

    Future<void> resetPassword() async {
      if (formKey.currentState!.validate()) {
        await ref.read(authControllerProvider.notifier).resetPassword(
            email: emailController.text.trim()
        );
        if (ref.read(resetPasswordExceptionProvider.notifier).state == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset successful. Check your email'),
                backgroundColor: Colors.green,
              )
          );
          locator<NavigationHelper>().navigateTo(rootRoute);
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Password reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: emailController,
                hint: 'Email',
                type: FieldType.text,
                validator: (email) => email != null && !EmailValidator.validate(email) ?
                'Enter correct Email' :
                null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: resetPassword,
                child: const Center(child: Text('Reset password')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}