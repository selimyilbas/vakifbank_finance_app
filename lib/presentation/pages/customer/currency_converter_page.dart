import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/transaction.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/currency/currency_bloc.dart';
import '../../bloc/currency/currency_event.dart';
import '../../bloc/currency/currency_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/currency/currency_card.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
  }

  void _loadExchangeRates() {
    context.read<CurrencyBloc>().add(GetExchangeRatesRequested(_fromCurrency));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      context.read<CurrencyBloc>().add(
            ConvertCurrencyRequested(
              from: _fromCurrency,
              to: _toCurrency,
              amount: amount,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createTransaction(double fromAmount, double toAmount, double rate) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: authState.user.id,
        fromCurrency: _fromCurrency,
        toCurrency: _toCurrency,
        fromAmount: fromAmount,
        toAmount: toAmount,
        exchangeRate: rate,
        bankProfit: fromAmount * AppConstants.bankProfitMargin,
        createdAt: DateTime.now(),
      );

      context.read<TransactionBloc>().add(CreateTransactionRequested(transaction));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExchangeRates,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: CurrencyFormatter.format(0, _fromCurrency).substring(0, 1),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromCurrency,
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.supportedCurrencies
                                .map((currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _fromCurrency = value!;
                                _loadExchangeRates();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.arrow_forward),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toCurrency,
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.supportedCurrencies
                                .map((currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _toCurrency = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Convert',
                      onPressed: _convertCurrency,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            BlocConsumer<CurrencyBloc, CurrencyState>(
              listener: (context, state) {
                if (state is CurrencyConverted) {
                  final rate = state.result / state.amount;
                  _createTransaction(state.amount, state.result, rate);
                  
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Conversion Result'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${CurrencyFormatter.format(state.amount, state.from)} =',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CurrencyFormatter.format(state.result, state.to),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Exchange Rate: ${rate.toStringAsFixed(4)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            'Bank Fee: ${AppConstants.bankProfitMargin * 100}%',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else if (state is CurrencyError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CurrencyLoading) {
                  return const LoadingWidget(message: 'Loading exchange rates...');
                } else if (state is CurrencyRatesLoaded) {
                  final amount = double.tryParse(_amountController.text) ?? 100;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Exchange Rates',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      ...state.currencies
                          .where((currency) => 
                              AppConstants.supportedCurrencies.contains(currency.code))
                          .map((currency) => CurrencyCard(
                                currency: currency,
                                amount: amount,
                              ))
                          .toList(),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}