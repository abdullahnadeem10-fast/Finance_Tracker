import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/transaction_repository.dart';
import '../domain/transaction_model.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return FirebaseTransactionRepository();
});

final transactionListProvider = StreamProvider<List<TransactionModel>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  final userId = user?.uid;

  if (userId == null || userId.isEmpty) {
    return Stream.value(const <TransactionModel>[]);
  }

  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactions(userId);
});