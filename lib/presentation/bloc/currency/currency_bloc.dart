import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/currency/get_exchange_rates_usecase.dart';
import '../../../domain/usecases/currency/convert_currency_usecase.dart';
import 'currency_event.dart';
import 'currency_state.dart';

/// Currency Business Logic Component (BLoC)
/// 
/// Manages currency-related state for the application.
/// Handles fetching exchange rates and currency conversions.
/// 
/// Key responsibilities:
/// - Fetch real-time exchange rates from external APIs
/// - Perform currency conversions with bank fees
/// - Handle API failures with fallback mechanisms
/// - Manage loading and error states
/// 
/// This BLoC integrates with external currency APIs through
/// the repository pattern, ensuring clean separation of concerns.
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  /// Use case for fetching current exchange rates
  final GetExchangeRatesUseCase getExchangeRatesUseCase;
  
  /// Use case for performing currency conversions
  final ConvertCurrencyUseCase convertCurrencyUseCase;

  /// Creates a CurrencyBloc with required use cases
  /// 
  /// Initializes with [CurrencyInitial] state and registers
  /// event handlers for currency operations.
  CurrencyBloc({
    required this.getExchangeRatesUseCase,
    required this.convertCurrencyUseCase,
  }) : super(CurrencyInitial()) {
    // Register event handlers
    on<GetExchangeRatesRequested>(_onGetExchangeRatesRequested);
    on<ConvertCurrencyRequested>(_onConvertCurrencyRequested);
  }

  /// Handles exchange rates fetch requests
  /// 
  /// Process:
  /// 1. Emit loading state for UI feedback
  /// 2. Call API through use case with base currency
  /// 3. Handle success/failure results
  /// 4. Emit appropriate state with data or error
  /// 
  /// The use case implements fallback logic:
  /// - Primary API: exchangerate-api.com
  /// - Fallback API: frankfurter.app
  /// 
  /// This ensures high availability of exchange rate data
  Future<void> _onGetExchangeRatesRequested(
    GetExchangeRatesRequested event,
    Emitter<CurrencyState> emit,
  ) async {
    // Show loading indicator
    emit(CurrencyLoading());
    
    // Fetch exchange rates through use case
    final result = await getExchangeRatesUseCase(event.baseCurrency);
    
    // Handle result using Either pattern
    result.fold(
      // API call failed
      (failure) => emit(CurrencyError(failure.message)),
      // Rates fetched successfully
      (currencies) => emit(CurrencyRatesLoaded(
        currencies: currencies,
        baseCurrency: event.baseCurrency,
      )),
    );
  }

  /// Handles currency conversion requests
  /// 
  /// Process:
  /// 1. Emit loading state
  /// 2. Fetch current rate and calculate conversion
  /// 3. Apply bank profit margin (0.2%)
  /// 4. Return final amount customer receives
  /// 
  /// Conversion formula:
  /// - Base amount = amount * exchange_rate
  /// - Final amount = base_amount * (1 - bank_profit_margin)
  /// 
  /// This ensures transparent fee structure for customers
  Future<void> _onConvertCurrencyRequested(
    ConvertCurrencyRequested event,
    Emitter<CurrencyState> emit,
  ) async {
    // Show loading indicator
    emit(CurrencyLoading());
    
    // Perform conversion through use case
    final result = await convertCurrencyUseCase(
      from: event.from,
      to: event.to,
      amount: event.amount,
    );
    
    // Handle result
    result.fold(
      // Conversion failed
      (failure) => emit(CurrencyError(failure.message)),
      // Conversion successful
      (convertedAmount) => emit(CurrencyConverted(
        result: convertedAmount,
        from: event.from,
        to: event.to,
        amount: event.amount,
      )),
    );
  }
}