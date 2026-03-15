import 'dart:async';

import '../domain/transaction_model.dart';
import 'transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  MockTransactionRepository()
    : _controller = StreamController<List<TransactionModel>>.broadcast() {
    _transactions = _buildDefaultTransactions();
  }

  final StreamController<List<TransactionModel>> _controller;
  late List<TransactionModel> _transactions;

  List<TransactionModel> _buildDefaultTransactions() {
    final now = DateTime.now();
    return [
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
        date: now.subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        id: 'txn-3',
        amount: 3200,
        type: 'income',
        category: 'Income',
        title: 'Salary',
        date: now.subtract(const Duration(hours: 3)),
      ),
      TransactionModel(
        id: 'txn-4',
        amount: 14.99,
        type: 'expense',
        category: 'Subscriptions',
        title: 'Netflix',
        date: now.subtract(const Duration(days: 2)),
      ),
      TransactionModel(
        id: 'txn-5',
        amount: 126.40,
        type: 'expense',
        category: 'Groceries',
        title: 'Grocery',
        date: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      TransactionModel(
        id: 'txn-6',
        amount: 12.10,
        type: 'expense',
        category: 'Coffee',
        title: 'Starbucks',
        date: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  @override
  Stream<List<TransactionModel>> getTransactions(String userId) async* {
    yield List<TransactionModel>.from(_transactions);
    yield* _controller.stream;
  }

  @override
  Future<void> addTransaction(String userId, TransactionModel transaction) async {
    _transactions.add(transaction);
    _controller.add(List.from(_transactions));
  }

  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    _transactions.removeWhere((transaction) => transaction.id == transactionId);
    _controller.add(List.from(_transactions));
  }

  @override
  Future<double> calculateTotalBalance(String userId) async {
    double total = 0;
    for (final transaction in _transactions) {
      if (transaction.type == 'income') {
        total += transaction.amount;
      } else if (transaction.type == 'expense') {
        total -= transaction.amount;
      }
    }

    return total;
  }

  @override
  Future<void> resetData() async {
    _transactions = _buildDefaultTransactions();
    _controller.add(List<TransactionModel>.from(_transactions));
  }
}