import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/transaction/create_transaction_usecase.dart';
import '../../../domain/usecases/transaction/get_transactions_usecase.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final CreateTransactionUseCase createTransactionUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionBloc({
    required this.createTransactionUseCase,
    required this.getTransactionsUseCase,
  }) : super(TransactionInitial()) {
    on<CreateTransactionRequested>(_onCreateTransactionRequested);
    on<GetTransactionsRequested>(_onGetTransactionsRequested);
  }

  Future<void> _onCreateTransactionRequested(
    CreateTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    
    final result = await createTransactionUseCase(event.transaction);
    
    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (_) => emit(TransactionCreated()),
    );
  }

  Future<void> _onGetTransactionsRequested(
    GetTransactionsRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    
    final result = await getTransactionsUseCase(userId: event.userId);
    
    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }
}