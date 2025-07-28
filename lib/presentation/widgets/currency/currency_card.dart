import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/currency.dart';

/// Currency Card Widget
/// 
/// Displays currency exchange rate information in a card format.
/// Shows currency code, exchange rate, and converted amount.
/// Used in currency converter and exchange rates pages.
class CurrencyCard extends StatelessWidget {
  /// Currency entity with rate information
  final Currency currency;
  
  /// Base amount for conversion display
  final double amount;
  
  /// Optional tap callback
  final VoidCallback? onTap;

  const CurrencyCard({
    Key? key,
    required this.currency,
    required this.amount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate converted amount
    final convertedAmount = amount * currency.rate;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Subtle shadow for elevation effect
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Currency information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Currency code
                  Text(
                    currency.code,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Exchange rate
                  Text(
                    'Rate: ${currency.rate.toStringAsFixed(4)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // Converted amount with Vakıfbank yellow background
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDB913).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  CurrencyFormatter.format(convertedAmount, currency.code),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}