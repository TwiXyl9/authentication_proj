import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/navigation_helper.dart';
import '../locator.dart';
import '../routes_names.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  Future<void> resetPassword() async {

    final scaffoldMassager = ScaffoldMessenger.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showSnackBar(
        context,
        e.message!,
        true,
      );
    }

    const snackBar = SnackBar(
      content: Text('Password reset successful. Check your email'),
      backgroundColor: Colors.green,
    );

    scaffoldMassager.showSnackBar(snackBar);
    locator<NavigationHelper>().navigateTo(rootRoute);
  }

  @override
  Widget build(BuildContext context) {
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