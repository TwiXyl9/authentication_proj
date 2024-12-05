import 'package:authentication_proj/controllers/authentication_controller.dart';
import 'package:authentication_proj/helpers/navigation_helper.dart';
import 'package:authentication_proj/routes_names.dart';
import 'package:authentication_proj/widgets/custom_button_widget.dart';
import 'package:authentication_proj/widgets/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../locator.dart';
import '../models/custom_exception.dart';
import '../widgets/custom_snackbar.dart';

class AuthenticationScreen extends ConsumerWidget {

  AuthenticationScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<CustomException?>(authenticationExceptionProvider, (previous, next) {
      CustomSnackBar.showSnackBar(
        context,
        next!.message!,
        true,
      );
    });

    Future<void> login() async {
      if (formKey.currentState!.validate()) {
        await ref.read(authControllerProvider.notifier).signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim()
        );
        if (ref.read(authenticationExceptionProvider.notifier).state == null) {
          locator<NavigationHelper>().navigateTo(rootRoute);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
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
                    if (val != null && !EmailValidator.validate(val)) return 'Enter valid Email!';
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
              CustomButton(
                  btnText: 'Sign In',
                  onTap: () => login(),
                  btnColor: Colors.black
              ),
              TextButton(
                onPressed: () {
                  locator<NavigationHelper>().navigateTo(registrationRoute);
                },
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () => locator<NavigationHelper>().navigateTo(resetPasswordRoute),
                child: const Text('Reset password'),
              ),
              Row(
                children: [
                  Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )
                  ),
                  Text(' Or sign in with ',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              SignInButton(
                  Buttons.google,
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signInWithGoogle();
                    if (ref.read(authenticationExceptionProvider.notifier).state == null) {
                      locator<NavigationHelper>().navigateTo(rootRoute);
                    }
                  }
              ),
              SignInButton(
                  Buttons.facebook,
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signInWithFacebook();
                    if (ref.read(authenticationExceptionProvider.notifier).state == null) {
                      locator<NavigationHelper>().navigateTo(rootRoute);
                    }
                  }
              ),
              SignInButton(
                  Buttons.gitHub,
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signInWithGitHub();
                    if (ref.read(authenticationExceptionProvider.notifier).state == null) {
                      locator<NavigationHelper>().navigateTo(rootRoute);
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
