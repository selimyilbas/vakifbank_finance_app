import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_formatter.dart';
import '../../bloc/currency/currency_bloc.dart';
import '../../bloc/currency/currency_event.dart';
import '../../bloc/currency/currency_state.dart';
import '../../widgets/common/loading_widget.dart';

class ExchangeRatesPage extends StatefulWidget {
  const ExchangeRatesPage({Key? key}) : super(key: key);

  @override
  State<ExchangeRatesPage> createState() => _ExchangeRatesPageState();
}

class _ExchangeRatesPageState extends State<ExchangeRatesPage> {
  String _baseCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
  }

  void _loadExchangeRates() {
    context.read<CurrencyBloc>().add(GetExchangeRatesRequested(_baseCurrency));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Live Exchange Rates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExchangeRates,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Base Currency: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _baseCurrency,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: AppConstants.supportedCurrencies
                            .map((currency) => DropdownMenuItem(
                                  value: currency,
                                  child: Row(
                                    children: [
                                      Text(
                                        _getCurrencyFlag(currency),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(currency),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _baseCurrency = value!;
                            _loadExchangeRates();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, state) {
                    if (state is CurrencyRatesLoaded) {
                      return Text(
                        'Last updated: ${DateFormatter.formatDateTime(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                if (state is CurrencyLoading) {
                  return const LoadingWidget(
                    message: 'Loading exchange rates...',
                  );
                } else if (state is CurrencyRatesLoaded) {
                  final filteredCurrencies = state.currencies
                      .where((currency) =>
                          AppConstants.supportedCurrencies.contains(currency.code) &&
                          currency.code != _baseCurrency)
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = filteredCurrencies[index];
                      final percentChange = _calculatePercentChange(currency.rate);
                      final isPositive = percentChange >= 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    _getCurrencyFlag(currency.code),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currency.code,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _getCurrencyName(currency.code),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    currency.rate.toStringAsFixed(4),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        isPositive
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: isPositive
                                            ? Colors.green
                                            : Colors.red,
                                        size: 16,
                                      ),
                                      Text(
                                        '${percentChange.abs().toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isPositive
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CurrencyError) {
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
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadExchangeRates,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencyFlag(String code) {
    final flags = {
      'USD': '🇺🇸', 'EUR': '🇪🇺', 'TRY': '🇹🇷', 'GBP': '🇬🇧', 'JPY': '🇯🇵',
      'CHF': '🇨🇭', 'CAD': '🇨🇦', 'AUD': '🇦🇺', 'CNY': '🇨🇳', 'HKD': '🇭🇰',
      'NZD': '🇳🇿', 'SEK': '🇸🇪', 'KRW': '🇰🇷', 'SGD': '🇸🇬', 'NOK': '🇳🇴',
      'MXN': '🇲🇽', 'INR': '🇮🇳', 'RUB': '🇷🇺', 'ZAR': '🇿🇦', 'BRL': '🇧🇷',
      'AED': '🇦🇪', 'SAR': '🇸🇦', 'PLN': '🇵🇱', 'THB': '🇹🇭', 'IDR': '🇮🇩',
      'HUF': '🇭🇺', 'CZK': '🇨🇿', 'ILS': '🇮🇱', 'CLP': '🇨🇱', 'PHP': '🇵🇭'
    };
    return flags[code] ?? '💱';
  }

  String _getCurrencyName(String code) {
    final names = {
      'USD': 'US Dollar', 'EUR': 'Euro', 'TRY': 'Turkish Lira',
      'GBP': 'British Pound', 'JPY': 'Japanese Yen', 'CHF': 'Swiss Franc',
      'CAD': 'Canadian Dollar', 'AUD': 'Australian Dollar', 'CNY': 'Chinese Yuan',
      'HKD': 'Hong Kong Dollar', 'NZD': 'New Zealand Dollar', 'SEK': 'Swedish Krona',
      'KRW': 'South Korean Won', 'SGD': 'Singapore Dollar', 'NOK': 'Norwegian Krone',
      'MXN': 'Mexican Peso', 'INR': 'Indian Rupee', 'RUB': 'Russian Ruble',
      'ZAR': 'South African Rand', 'BRL': 'Brazilian Real', 'AED': 'UAE Dirham',
      'SAR': 'Saudi Riyal', 'PLN': 'Polish Zloty', 'THB': 'Thai Baht',
      'IDR': 'Indonesian Rupiah', 'HUF': 'Hungarian Forint', 'CZK': 'Czech Koruna',
      'ILS': 'Israeli Shekel', 'CLP': 'Chilean Peso', 'PHP': 'Philippine Peso'
    };
    return names[code] ?? code;
  }

  double _calculatePercentChange(double rate) {
    // Simulating percentage change - in production, you'd compare with previous rate
    return (rate * 0.02) - 0.01;
  }
}  