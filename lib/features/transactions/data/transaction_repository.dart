import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/transaction_model.dart';

abstract class TransactionRepository {
  Stream<List<TransactionModel>> getTransactions(String userId);
  Future<void> addTransaction(String userId, TransactionModel transaction);
  Future<void> deleteTransaction(String userId, String transactionId);
  Future<double> calculateTotalBalance(String userId);
}

class FirebaseTransactionRepository implements TransactionRepository {
  FirebaseTransactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _transactionsRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions');
  }

  @override
  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _transactionsRef(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TransactionModel.fromMap({
                  ...doc.data(),
                  if ((doc.data()['id'] as String?) == null ||
                      (doc.data()['id'] as String).isEmpty)
                    'id': doc.id,
                }),
              )
              .toList(),
        );
  }

  @override
  Future<void> addTransaction(String userId, TransactionModel transaction) async {
    final docRef = _transactionsRef(userId).doc(
      transaction.id.isEmpty ? null : transaction.id,
    );

    final payload = transaction.copyWith(id: docRef.id).toMap();
    await docRef.set(payload);
  }

  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    await _transactionsRef(userId).doc(transactionId).delete();
  }

  @override
  Future<double> calculateTotalBalance(String userId) async {
    final snapshot = await _transactionsRef(userId).get();

    double total = 0;
    for (final doc in snapshot.docs) {
      final transaction = TransactionModel.fromMap({...doc.data(), 'id': doc.id});
      if (transaction.type == 'income') {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }

    return total;
  }
}