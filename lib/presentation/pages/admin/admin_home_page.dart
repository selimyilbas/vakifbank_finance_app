import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../auth/login_page.dart';
import 'transactions_page.dart';
import 'profit_report_page.dart';
import '../../../core/utils/currency_formatter.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    context.read<TransactionBloc>().add(const GetTransactionsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _loadTransactions();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    if (authState is AuthAuthenticated) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${authState.user.name}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Admin Account',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Quick Stats',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionsLoaded) {
                      final todayProfit = state.transactions
                          .where((t) =>
                              t.createdAt.day == DateTime.now().day &&
                              t.createdAt.month == DateTime.now().month &&
                              t.createdAt.year == DateTime.now().year)
                          .fold(0.0, (sum, t) => sum + t.bankProfit);

                      final totalProfit = state.transactions
                          .fold(0.0, (sum, t) => sum + t.bankProfit);

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Today\'s Profit',
                                  CurrencyFormatter.format(todayProfit, 'USD'),
                                  Icons.attach_money,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Total Profit',
                                  CurrencyFormatter.format(totalProfit, 'USD'),
                                  Icons.account_balance_wallet,
                                  Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Transactions',
                                  state.transactions.length.toString(),
                                  Icons.receipt_long,
                                  Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Active Users',
                                  state.transactions
                                      .map((t) => t.userId)
                                      .toSet()
                                      .length
                                      .toString(),
                                  Icons.people,
                                  Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Management',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildManagementOption(
                  context,
                  'View All Transactions',
                  Icons.list_alt,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransactionsPage()),
                    );
                  },
                ),
                _buildManagementOption(
                  context,
                  'Profit Reports',
                  Icons.analytics,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfitReportPage()),
                    );
                  },
                ),
                _buildManagementOption(
                  context,
                  'Currency Settings',
                  Icons.currency_exchange,
                  () {
                    // Navigate to currency settings
                  },
                ),
                _buildManagementOption(
                  context,
                  'User Management',
                  Icons.people_alt,
                  () {
                    // Navigate to user management
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}