import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/mock_auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
// import 'firebase_options.dart'; // Uncomment this once generated

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Uncomment after running 'flutterfire configure'
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(MockAuthRepository()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the auth state
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      title: 'LuxeVault',
      theme: AppTheme.darkTheme,
      // Debug banner is distracting for high-end feel
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const DashboardScreen();
          }
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF00FF94)),
          ),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
