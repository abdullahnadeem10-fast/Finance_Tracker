// ignore_for_file: avoid_print

import '../domain/transaction_model.dart';
import 'transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  @override
  Stream<List<TransactionModel>> getTransactions(String userId) {
    final now = DateTime.now();

    final transactions = <TransactionModel>[
      TransactionModel(
        id: 'txn-1',
        amount: 8.75,
        type: 'expense',
        category: 'Coffee',
        title: 'Starbucks',
        date: now,
      ),
      TransactionModel(
        id: 'txn-2',
        amount: 24.30,
        type: 'expense',
        category: 'Transport',
        title: 'Uber',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        id: 'txn-3',
        amount: 3200,
        type: 'income',
        category: 'Income',
        title: 'Salary',
        date: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      TransactionModel(
        id: 'txn-4',
        amount: 14.99,
        type: 'expense',
        category: 'Subscriptions',
        title: 'Netflix',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TransactionModel(
        id: 'txn-5',
        amount: 126.40,
        type: 'expense',
        category: 'Groceries',
        title: 'Grocery',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
      TransactionModel(
        id: 'txn-6',
        amount: 12.10,
        type: 'expense',
        category: 'Coffee',
        title: 'Starbucks',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    return Stream.value(transactions);
  }

  @override
  Future<void> addTransaction(String userId, TransactionModel transaction) async {
    print('Added Mock Transaction');
  }

  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    print('Deleted Mock Transaction');
  }

  @override
  Future<double> calculateTotalBalance(String userId) async {
    final transactions = await getTransactions(userId).first;

    double total = 0;
    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }

    return total;
  }
}