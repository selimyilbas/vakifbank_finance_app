import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/transaction/create_transaction_usecase.dart';
import '../../../domain/usecases/transaction/get_transactions_usecase.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

/// Transaction Business Logic Component (BLoC)
/// 
/// Manages transaction-related state for the application.
/// Handles creating, retrieving, and analyzing transaction records.
/// 
/// Key responsibilities:
/// - Record currency conversion transactions
/// - Retrieve transaction history (user-specific or system-wide)
/// - Support admin reporting features
/// - Ensure data integrity and audit trail
/// 
/// Transactions are immutable once created, ensuring
/// accurate financial records for audit purposes.
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  /// Use case for creating new transaction records
  final CreateTransactionUseCase createTransactionUseCase;
  
  /// Use case for fetching transaction history
  final GetTransactionsUseCase getTransactionsUseCase;

  /// Creates a TransactionBloc with required use cases
  /// 
  /// Initializes with [TransactionInitial] state and registers
  /// event handlers for transaction operations.
  TransactionBloc({
    required this.createTransactionUseCase,
    required this.getTransactionsUseCase,
  }) : super(TransactionInitial()) {
    // Register event handlers
    on<CreateTransactionRequested>(_onCreateTransactionRequested);
    on<GetTransactionsRequested>(_onGetTransactionsRequested);
    // Note: CalculateDailyProfitRequested handler can be added when needed
  }

  /// Handles transaction creation requests
  /// 
  /// Process:
  /// 1. Emit loading state
  /// 2. Save transaction to Firestore through use case
  /// 3. Handle success/failure results
  /// 4. Emit appropriate state
  /// 
  /// Transaction includes:
  /// - Unique ID (timestamp-based)
  /// - User identification
  /// - Currency conversion details
  /// - Bank profit calculation
  /// - Immutable timestamp
  /// 
  /// Security: Firestore rules ensure users can only create
  /// transactions with their own user ID
  Future<void> _onCreateTransactionRequested(
    CreateTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    // Show loading indicator
    emit(TransactionLoading());
    
    // Save transaction through use case
    final result = await createTransactionUseCase(event.transaction);
    
    // Handle result
    result.fold(
      // Save failed
      (failure) => emit(TransactionError(failure.message)),
      // Save successful
      (_) => emit(TransactionCreated()),
    );
  }

  /// Handles transaction fetch requests
  /// 
  /// Process:
  /// 1. Emit loading state
  /// 2. Fetch transactions based on user ID filter
  /// 3. Handle success/failure results
  /// 4. Emit state with transaction list
  /// 
  /// Access control:
  /// - Customers: Can only view their own transactions
  /// - Admins: Can view all system transactions
  /// 
  /// Security is enforced through Firestore security rules
  /// based on user role stored in the users collection
  Future<void> _onGetTransactionsRequested(
    GetTransactionsRequested event,
    Emitter<TransactionState> emit,
  ) async {
    // Show loading indicator
    emit(TransactionLoading());
    
    // Fetch transactions through use case
    // Use case determines whether to fetch user-specific or all transactions
    final result = await getTransactionsUseCase(userId: event.userId);
    
    // Handle result
    result.fold(
      // Fetch failed
      (failure) => emit(TransactionError(failure.message)),
      // Fetch successful - emit list
      (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }

  // Future implementation for daily profit calculation:
  // Future<void> _onCalculateDailyProfitRequested(
  //   CalculateDailyProfitRequested event,
  //   Emitter<TransactionState> emit,
  // ) async {
  //   // Implementation would:
  //   // 1. Fetch all transactions for the date
  //   // 2. Sum the bankProfit fields
  //   // 3. Emit DailyProfitCalculated state
  // }
}