import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/currency.dart';

class CurrencyCard extends StatelessWidget {
  final Currency currency;
  final double amount;
  final VoidCallback? onTap;

  const CurrencyCard({
    Key? key,
    required this.currency,
    required this.amount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final convertedAmount = amount * currency.rate;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rate: ${currency.rate.toStringAsFixed(4)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                CurrencyFormatter.format(convertedAmount, currency.code),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}