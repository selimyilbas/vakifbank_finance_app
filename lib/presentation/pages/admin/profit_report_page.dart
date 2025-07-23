import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/common/loading_widget.dart';

class ProfitReportPage extends StatefulWidget {
  const ProfitReportPage({Key? key}) : super(key: key);

  @override
  State<ProfitReportPage> createState() => _ProfitReportPageState();
}

class _ProfitReportPageState extends State<ProfitReportPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const GetTransactionsRequested());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Report'),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const LoadingWidget(message: 'Generating report...');
          } else if (state is TransactionsLoaded) {
            // Group transactions by date
            final Map<DateTime, List<dynamic>> groupedTransactions = {};
            final Map<DateTime, double> dailyProfits = {};

            for (var transaction in state.transactions) {
              final date = DateTime(
                transaction.createdAt.year,
                transaction.createdAt.month,
                transaction.createdAt.day,
              );
              
              if (!groupedTransactions.containsKey(date)) {
                groupedTransactions[date] = [];
                dailyProfits[date] = 0.0;
              }
              
              groupedTransactions[date]!.add(transaction);
              dailyProfits[date] = dailyProfits[date]! + transaction.bankProfit;
            }

            final sortedDates = dailyProfits.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            final totalProfit = dailyProfits.values.fold(0.0, (a, b) => a + b);
            final averageDailyProfit = 
                sortedDates.isEmpty ? 0.0 : totalProfit / sortedDates.length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            'Total Profit',
                            CurrencyFormatter.format(totalProfit, 'USD'),
                            Colors.green,
                          ),
                          _buildSummaryRow(
                            'Average Daily Profit',
                            CurrencyFormatter.format(averageDailyProfit, 'USD'),
                            Colors.blue,
                          ),
                          _buildSummaryRow(
                            'Total Transactions',
                            state.transactions.length.toString(),
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Daily Breakdown',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ...sortedDates.map((date) {
                    final transactions = groupedTransactions[date]!;
                    final profit = dailyProfits[date]!;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormatter.formatDate(date),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              CurrencyFormatter.format(profit, 'USD'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text('${transactions.length} transactions'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ...transactions.map((t) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${t.fromCurrency} → ${t.toCurrency}',
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          Text(
                                            CurrencyFormatter.format(
                                              t.bankProfit,
                                              'USD',
                                            ),
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          } else if (state is TransactionError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}