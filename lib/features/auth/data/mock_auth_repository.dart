import 'dart:async';

import '../domain/user_model.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository()
      : _controller = StreamController<UserModel?>.broadcast(
          onListen: () {},
        );

  final StreamController<UserModel?> _controller;
  UserModel? _currentUser;

  @override
  Stream<UserModel?> get authStateChanges async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (password == 'fail') {
      throw const AuthRepositoryException('Invalid credentials');
    }

    final user = UserModel(
      uid: 'mock-user-1',
      email: email,
      displayName: 'Mock User',
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel?> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final user = UserModel(
      uid: 'mock-user-2',
      email: email,
      displayName: name,
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final user = const UserModel(
      uid: 'mock-google-1',
      email: 'test@gmail.com',
      displayName: 'Google Owner',
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}
