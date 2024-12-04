import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/authentication_controller.dart';
import '../helpers/navigation_helper.dart';
import '../locator.dart';
import '../models/custom_exception.dart';
import '../routes_names.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends ConsumerWidget {

  RegistrationScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<CustomException?>(registrationExceptionProvider, (previous, next) {
      CustomSnackBar.showSnackBar(
        context,
        next!.message!,
        true,
      );
    });

    Future<void> signUp() async {
      if (formKey.currentState!.validate()) {
        await ref.read(authControllerProvider.notifier).signUp(
            email: emailController.text.trim(),
            password: passwordController.text.trim()
        );
        if (ref.read(registrationExceptionProvider.notifier).state == null) {
          locator<NavigationHelper>().navigateTo(rootRoute);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  controller: emailController,
                  hint: 'Email',
                  type: FieldType.text,
                  validator: (val) {
                    if (val!.isEmpty) return 'Enter Email!';
                    if (!EmailValidator.validate(val)) return 'Enter correct Email!';
                  }
              ),
              const SizedBox(height: 15,),
              CustomTextField(
                  controller: passwordController,
                  hint: 'Password',
                  type: FieldType.password,
                  validator: (val) {
                    if (val!.isEmpty) return 'Enter password!';
                  }
              ),
              const SizedBox(height: 15,),
              CustomTextField(
                  controller: repeatPasswordController,
                  hint: 'Repeat password',
                  type: FieldType.password,
                  validator: (val) {
                    if (val!.isEmpty) return 'Enter password!';
                    if (passwordController.text.trim() != val) return 'Passwords don\'t match!';
                  }
              ),
              CustomButton(
                  btnText: 'Sign Up',
                  onTap: () => signUp(),
                  btnColor: Colors.black
              ),
              TextButton(
                onPressed: () =>
                  locator<NavigationHelper>().navigateTo(authenticationRoute),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
