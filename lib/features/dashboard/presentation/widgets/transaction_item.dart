import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../transactions/domain/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
      case 'food':
        return Icons.restaurant;
      case 'salary':
      case 'income':
        return Icons.account_balance_wallet;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
      case 'travel':
        return Icons.directions_car;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final currencyFormat = NumberFormat.simpleCurrency();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isIncome ? Colors.green : Colors.orange).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(transaction.category),
              color: isIncome ? Colors.greenAccent : Colors.orangeAccent,
            ),
          ),
          title: Text(
            transaction.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            DateFormat('MMM d, y').format(transaction.date),
            style: const TextStyle(color: Colors.white54),
          ),
          trailing: Text(
            '${isIncome ? "+" : "-"}${currencyFormat.format(transaction.amount)}',
            style: TextStyle(
              color: isIncome ? Colors.greenAccent : Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
