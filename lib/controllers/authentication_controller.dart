import 'dart:async';
import 'dart:io';

import 'package:authentication_proj/models/custom_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/secrets/google_api_keys.dart';
import '../repositories/auth_repository.dart';
import '../services/token_service.dart';

final authenticationExceptionProvider = StateProvider<CustomException?>((_) => null);
final registrationExceptionProvider = StateProvider<CustomException?>((_) => null);
final resetPasswordExceptionProvider = StateProvider<CustomException?>((_) => null);

final authControllerProvider = StateNotifierProvider<AuthController, User?>((ref) => AuthController(ref));

class AuthController extends StateNotifier<User?>{
  final Ref _ref;

  StreamSubscription<User?>? _authStateChangeSubscription;

  AuthController(this._ref) : super(null) {
    _authStateChangeSubscription?.cancel();
    _authStateChangeSubscription = _ref.read(authRepositoryProvider).authStateChanges.listen((user) => state = user);
  }

  @override
  void dispose(){
    _authStateChangeSubscription?.cancel();
    super.dispose();
  }

  User? getCurrentUser() {
    try {
      return _ref.read(authRepositoryProvider).getCurrentUser();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> signIn({ required String email, required String password}) async {
    try {
      await _ref.read(authRepositoryProvider).signIn(email: email, password: password);
    } on CustomException catch (e) {
      _ref.read(authenticationExceptionProvider.notifier).state = e;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleAccount?.authentication;
      var credential = OAuthCredential(
        providerId: 'google.com',
        signInMethod: 'oauth',
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      _ref.read(authRepositoryProvider).signInWithCredential(credential: credential);
    } on CustomException catch (e) {
      _ref.read(authenticationExceptionProvider.notifier).state = e;
    }
  }

  Future<void> signInWithFacebook() async {
    var nonce = null;
    var rawNonce = null;
    if(Platform.isIOS){
      rawNonce = TokenService().generateNonce();
      nonce = TokenService().sha256ofString(rawNonce);
    }
    final result = await FacebookAuth.instance.login(
        loginTracking: LoginTracking.limited,
        nonce: nonce
    );
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      var credential = FacebookAuthProvider.credential(accessToken.tokenString);
      if(Platform.isIOS){
        credential = OAuthCredential(
          providerId: 'facebook.com',
          signInMethod: 'oauth',
          idToken: accessToken.tokenString,
          rawNonce: rawNonce,
        );
      }
      _ref.read(authRepositoryProvider).signInWithCredential(credential: credential);
    } else {
      _ref.read(authenticationExceptionProvider.notifier).state = CustomException(message: result.message);
    }
  }

  Future<void> signInWithGitHub() async {
    try {
      _ref.read(authRepositoryProvider).signInWithProvider(provider: GithubAuthProvider());
    } on CustomException catch (e) {
      _ref.read(authenticationExceptionProvider.notifier).state = e;
    }
  }

  Future<void> signUp({
    required String email,
    required String password
  }) async {
    try {
      await _ref.read(authRepositoryProvider).signUp(email: email, password: password);
    } on CustomException catch (e) {
      _ref.read(registrationExceptionProvider.notifier).state = e;
    }
  }

  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }

  Future<void> resetPassword({ required String email}) async {
    try {
      await _ref.read(authRepositoryProvider).resetPassword(email: email);
    } on CustomException catch (e) {
      _ref.read(resetPasswordExceptionProvider.notifier).state = e;
    }
  }
}