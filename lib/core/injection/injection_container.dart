import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Data layer imports
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/currency_remote_datasource.dart';
import '../../data/datasources/remote/transaction_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';

// Domain layer imports
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

// Presentation layer imports
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/currency/currency_bloc.dart';
import '../../presentation/bloc/transaction/transaction_bloc.dart';


// Service Locator instance
// 
// GetIt is used for dependency injection throughout the application.
// This provides a clean way to manage dependencies and enables easy testing.
final sl = GetIt.instance;


/// Initializes all dependencies for the application
/// 
/// This function sets up the entire dependency injection container.
/// Dependencies are registered in order from external packages to presentation layer.
/// 
/// Call this function in main() before running the app:
/// ```dart
/// await init();
/// runApp(MyApp());
/// ```
Future<void> init() async {

  // External Dependencies
  // These are third-party packages that our app depends on


  // SharedPreferences for local storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // HTTP client for API calls
  sl.registerLazySingleton(() => http.Client());

  // Firebase services
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  //! Data sources
  // Remote and local data sources that interact with external services

   // Remote data sources - interact with Firebase and APIs
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(sl()),
  );
    // Local data source - manages cached data
 sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

   
  

  //! Repositories
  // Repository implementations that coordinate between data sources
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

  //! Use Cases
  // Business logic implementations that interact with repositories

    // Authentication use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

    // Authentication use cases
  sl.registerLazySingleton(() => GetExchangeRatesUseCase(sl()));
  sl.registerLazySingleton(() => ConvertCurrencyUseCase(sl()));

    // Transaction use cases
  sl.registerLazySingleton(() => CreateTransactionUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));

  //! BLoCs
  // Presentation layer state management
  // Using factory registration to create new instances for each screen
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





