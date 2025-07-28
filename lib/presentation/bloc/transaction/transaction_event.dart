import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

/// Base Transaction Event
/// 
/// All transaction-related events extend this abstract class.
/// Events represent actions that affect transaction state.
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Create Transaction Request Event
/// 
/// Triggered after successful currency conversion to record the transaction.
/// Creates an immutable record for audit and reporting purposes.
/// 
/// Transaction records include:
/// - User identification
/// - Currency pair and amounts
/// - Exchange rate used
/// - Bank profit earned
/// - Timestamp
class CreateTransactionRequested extends TransactionEvent {
  /// Complete transaction entity to be saved
  /// Contains all conversion details and calculated profit
  final Transaction transaction;

  /// Creates event with transaction data
  const CreateTransactionRequested(this.transaction);

  /// Props for event comparison
  @override
  List<Object> get props => [transaction];
}

/// Get Transactions Request Event
/// 
/// Triggered to fetch transaction history.
/// Supports both user-specific and system-wide queries.
/// 
/// Use cases:
/// - Customer viewing their transaction history
/// - Admin viewing all system transactions
/// - Generating profit reports
/// - Refresh action on transaction pages
class GetTransactionsRequested extends TransactionEvent {
  /// Optional user ID for filtering transactions
  /// - If provided: Returns only that user's transactions (customer view)
  /// - If null: Returns all transactions (admin view)
  /// 
  /// Access control is enforced at the repository level
  final String? userId;

  /// Creates event with optional user filter
  const GetTransactionsRequested({this.userId});

  /// Props for event comparison
  @override
  List<Object?> get props => [userId];
}

/// Calculate Daily Profit Request Event
/// 
/// Triggered to calculate total bank profit for a specific date.
/// Used in admin reporting features.
/// 
/// Calculation:
/// - Filters all transactions by date
/// - Sums bankProfit field from each transaction
/// - Returns total profit for the day
class CalculateDailyProfitRequested extends TransactionEvent {
  /// Date for which to calculate profit
  /// Time component is ignored (calculations are for full day)
  final DateTime date;

  /// Creates event with target date
  const CalculateDailyProfitRequested(this.date);

  /// Props for event comparison
  @override
  List<Object> get props => [date];
}