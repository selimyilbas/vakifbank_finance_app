import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/currency_remote_datasource.dart';
import '../../data/datasources/remote/transaction_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/currency/get_exchange_rates_usecase.dart';
import '../../domain/usecases/currency/convert_currency_usecase.dart';
import '../../domain/usecases/transaction/create_transaction_usecase.dart';
import '../../domain/usecases/transaction/get_transactions_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/currency/currency_bloc.dart';
import '../../presentation/bloc/transaction/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetExchangeRatesUseCase(sl()));
  sl.registerLazySingleton(() => ConvertCurrencyUseCase(sl()));
  sl.registerLazySingleton(() => CreateTransactionUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => CurrencyBloc(
      getExchangeRatesUseCase: sl(),
      convertCurrencyUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => TransactionBloc(
      createTransactionUseCase: sl(),
      getTransactionsUseCase: sl(),
    ),
  );
}