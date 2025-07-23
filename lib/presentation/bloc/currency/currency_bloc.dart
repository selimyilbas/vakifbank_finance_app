import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/currency/get_exchange_rates_usecase.dart';
import '../../../domain/usecases/currency/convert_currency_usecase.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetExchangeRatesUseCase getExchangeRatesUseCase;
  final ConvertCurrencyUseCase convertCurrencyUseCase;

  CurrencyBloc({
    required this.getExchangeRatesUseCase,
    required this.convertCurrencyUseCase,
  }) : super(CurrencyInitial()) {
    on<GetExchangeRatesRequested>(_onGetExchangeRatesRequested);
    on<ConvertCurrencyRequested>(_onConvertCurrencyRequested);
  }

  Future<void> _onGetExchangeRatesRequested(
    GetExchangeRatesRequested event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    
    final result = await getExchangeRatesUseCase(event.baseCurrency);
    
    result.fold(
      (failure) => emit(CurrencyError(failure.message)),
      (currencies) => emit(CurrencyRatesLoaded(
        currencies: currencies,
        baseCurrency: event.baseCurrency,
      )),
    );
  }

  Future<void> _onConvertCurrencyRequested(
    ConvertCurrencyRequested event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    
    final result = await convertCurrencyUseCase(
      from: event.from,
      to: event.to,
      amount: event.amount,
    );
    
    result.fold(
      (failure) => emit(CurrencyError(failure.message)),
      (convertedAmount) => emit(CurrencyConverted(
        result: convertedAmount,
        from: event.from,
        to: event.to,
        amount: event.amount,
      )),
    );
  }
}