import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/user_model.dart';

class AuthRepositoryException implements Exception {
  const AuthRepositoryException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() {
    if (code == null || code!.isEmpty) {
      return 'AuthRepositoryException: $message';
    }
    return 'AuthRepositoryException($code): $message';
  }
}

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return UserModel.fromFirebaseUser(user);
    });
  }

  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        return null;
      }
      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      throw AuthRepositoryException(
        _firebaseAuthErrorMessage(error),
        code: error.code,
      );
    } catch (error) {
      throw AuthRepositoryException('Failed to sign in: $error');
    }
  }

  Future<UserModel?> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const AuthRepositoryException(
          'Account created but no user was returned by Firebase Auth.',
        );
      }

      await user.updateDisplayName(name);

      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? email,
        displayName: name,
        photoUrl: user.photoURL,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (error) {
      throw AuthRepositoryException(
        _firebaseAuthErrorMessage(error),
        code: error.code,
      );
    } on FirebaseException catch (error) {
      throw AuthRepositoryException(
        'Unable to create user profile in Firestore: ${error.message ?? error.code}',
        code: error.code,
      );
    } catch (error) {
      if (error is AuthRepositoryException) {
        rethrow;
      }
      throw AuthRepositoryException('Failed to sign up: $error');
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw const AuthRepositoryException(
          'Google sign-in succeeded but no user was returned by Firebase Auth.',
        );
      }

      final userDoc = _firestore.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? googleUser.displayName ?? '',
          photoUrl: user.photoURL,
        );

        await userDoc.set(userModel.toMap());
      }

      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      throw AuthRepositoryException(
        _firebaseAuthErrorMessage(error),
        code: error.code,
      );
    } on FirebaseException catch (error) {
      throw AuthRepositoryException(
        'Unable to read or create Google user profile in Firestore: ${error.message ?? error.code}',
        code: error.code,
      );
    } catch (error) {
      if (error is AuthRepositoryException) {
        rethrow;
      }
      throw AuthRepositoryException('Failed to sign in with Google: $error');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthRepositoryException(
        _firebaseAuthErrorMessage(error),
        code: error.code,
      );
    } catch (error) {
      throw AuthRepositoryException('Failed to sign out: $error');
    }
  }

  String _firebaseAuthErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
