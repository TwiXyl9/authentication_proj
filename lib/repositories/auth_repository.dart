import 'package:authentication_proj/general_providers.dart';
import 'package:authentication_proj/models/custom_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  User? getCurrentUser();
  Future<void> signIn({required String email, required String password});
  Future<void> signInWithCredential({required OAuthCredential credential});
  Future<void> signInWithProvider({required AuthProvider provider});
  Future<void> signUp({required String email, required String password});
  Future<void> signOut();
  Future<void> resetPassword({required String email});
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));

class AuthRepository implements BaseAuthRepository {
  final Ref _ref;

  const AuthRepository(this._ref);

  @override
  Stream<User?> get authStateChanges {
    return _ref.read(firebaseAuthProvider).authStateChanges();
  }

  @override
  User? getCurrentUser() {
    try {
      return _ref.read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signInWithCredential({required OAuthCredential credential}) async {
    try {
      await _ref.read(firebaseAuthProvider).signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signInWithProvider({required AuthProvider provider}) async {
    try {
      await _ref.read(firebaseAuthProvider).signInWithProvider(provider);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ref.read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = getCurrentUser();
      if (user != null) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _ref.read(firebaseAuthProvider).sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

}