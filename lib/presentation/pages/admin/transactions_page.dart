import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/common/loading_widget.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const GetTransactionsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TransactionBloc>().add(const GetTransactionsRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const LoadingWidget(message: 'Loading transactions...');
          } else if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(
                child: Text(
                  'No transactions yet',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionBloc>().add(const GetTransactionsRequested());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = state.transactions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${transaction.fromCurrency} → ${transaction.toCurrency}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                              transaction.fromAmount,
                              transaction.fromCurrency,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        DateFormatter.formatDateTime(transaction.createdAt),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                'Transaction ID',
                                transaction.id,
                              ),
                              _buildDetailRow(
                                'User ID',
                                transaction.userId,
                              ),
                              _buildDetailRow(
                                'From Amount',
                                CurrencyFormatter.format(
                                  transaction.fromAmount,
                                  transaction.fromCurrency,
                                ),
                              ),
                              _buildDetailRow(
                                'To Amount',
                                CurrencyFormatter.format(
                                  transaction.toAmount,
                                  transaction.toCurrency,
                                ),
                              ),
                              _buildDetailRow(
                                'Exchange Rate',
                                transaction.exchangeRate.toStringAsFixed(4),
                              ),
                              _buildDetailRow(
                                'Bank Profit',
                                CurrencyFormatter.format(
                                  transaction.bankProfit,
                                  'USD',
                                ),
                                valueColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is TransactionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TransactionBloc>().add(
                            const GetTransactionsRequested(),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}