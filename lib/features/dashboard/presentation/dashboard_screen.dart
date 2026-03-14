import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/glass_container.dart';
import '../../auth/providers/auth_provider.dart';
import '../../transactions/providers/transaction_provider.dart';
import 'widgets/spending_chart.dart';
import 'widgets/transaction_item.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final transactionsAsync = ref.watch(transactionListProvider);
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: transactionsAsync.when(
          data: (transactions) {
            // Sort by date descending
            final sortedTransactions = [...transactions]
              ..sort((a, b) => b.date.compareTo(a.date));

            final double totalBalance = transactions.fold(
              0.0,
              (sum, tx) => tx.type == 'income' ? sum + tx.amount : sum - tx.amount,
            );

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${authState.value?.displayName ?? 'User'}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        GlassContainer(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Balance',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currencyFormat.format(totalBalance),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Spending Analysis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: SpendingChart(transactions: transactions),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if (sortedTransactions.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No transactions yet',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return TransactionItem(
                              transaction: sortedTransactions[index]);
                        },
                        childCount: sortedTransactions.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.greenAccent),
          ),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent)),
          ),
        ),
      ),
    );
  }
}
