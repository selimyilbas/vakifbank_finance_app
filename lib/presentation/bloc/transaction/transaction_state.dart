import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

/// Base Transaction State
/// 
/// Represents the state of transaction operations in the application.
/// All specific transaction states extend this abstract class.
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

/// Initial Transaction State
/// 
/// The default state before any transaction operation occurs.
/// This is the starting state when the BLoC is created.
class TransactionInitial extends TransactionState {}

/// Transaction Loading State
/// 
/// Indicates a transaction operation is in progress.
/// Used to show loading indicators during:
/// - Creating new transaction records
/// - Fetching transaction history
/// - Calculating profit reports
/// - Database queries
class TransactionLoading extends TransactionState {}

/// Transaction Created State
/// 
/// Indicates successful creation of a new transaction record.
/// Emitted after a currency conversion is saved to database.
/// 
/// This state can trigger:
/// - Success notifications
/// - Navigation to transaction history
/// - Refresh of transaction lists
class TransactionCreated extends TransactionState {}

/// Transactions Loaded State
/// 
/// Indicates successful retrieval of transaction history.
/// Contains list of transactions for display.
/// 
/// Used by:
/// - Customer transaction history page
/// - Admin transaction management page
/// - Profit report calculations
class TransactionsLoaded extends TransactionState {
  /// List of transaction entities
  /// Ordered by creation date (newest first)
  final List<Transaction> transactions;

  /// Creates state with loaded transactions
  const TransactionsLoaded(this.transactions);

  /// Props for state comparison
  @override
  List<Object> get props => [transactions];
}

/// Daily Profit Calculated State
/// 
/// Indicates successful calculation of daily profit.
/// Used in admin reporting features.
/// 
/// Contains:
/// - Total profit amount for the specified date
/// - The date for which profit was calculated
class DailyProfitCalculated extends TransactionState {
  /// Total bank profit for the date in USD
  final double profit;
  
  /// Date for which profit was calculated
  final DateTime date;

  /// Creates state with profit calculation results
  const DailyProfitCalculated({
    required this.profit,
    required this.date,
  });

  /// Props for state comparison
  @override
  List<Object> get props => [profit, date];
}

/// Transaction Error State
/// 
/// Indicates a transaction operation failed.
/// Contains error message for user feedback.
/// 
/// Common scenarios:
/// - Database connection errors
/// - Permission denied (security rules)
/// - Network issues
/// - Invalid transaction data
class TransactionError extends TransactionState {
  /// Human-readable error message for display
  final String message;

  /// Creates error state with message
  const TransactionError(this.message);

  /// Props for state comparison
  @override
  List<Object> get props => [message];
}