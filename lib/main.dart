import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/injection/injection_container.dart' as di;
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/currency/currency_bloc.dart';
import 'presentation/bloc/transaction/transaction_bloc.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/customer/customer_home_page.dart';
import 'presentation/pages/admin/admin_home_page.dart';

/// Entry point of the application.
/// Initializes Flutter bindings, Firebase, and dependency injection container before running the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter engine is initialized
  await Firebase.initializeApp();          // Initialize Firebase SDK
  await di.init();                          // Set up dependency injection (GetIt)
  runApp(const MyApp());                   // Launch the root widget
}

/// Root widget of the application.
/// Configures global Bloc providers and application theme.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthBloc checks login status and manages authentication state
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        // CurrencyBloc handles fetching and converting exchange rates
        BlocProvider(
          create: (_) => di.sl<CurrencyBloc>(),
        ),
        // TransactionBloc manages transaction history and creation
        BlocProvider(
          create: (_) => di.sl<TransactionBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          primarySwatch: MaterialColor(
            0xFFFDB913, // Custom primary color (bank theme)
            <int, Color>{
              50: const Color(0xFFFFF8E1),
              100: const Color(0xFFFFECB3),
              200: const Color(0xFFFFE082),
              300: const Color(0xFFFFD54F),
              400: const Color(0xFFFFCA28),
              500: const Color(0xFFFDB913),
              600: const Color(0xFFFFB300),
              700: const Color(0xFFFFA000),
              800: const Color(0xFFFF8F00),
              900: const Color(0xFFFF6F00),
            },
          ),
          primaryColor: const Color(0xFFFDB913),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFFFDB913),
            foregroundColor: Colors.black,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDB913),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // Initial route listener for authentication changes
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Navigate based on user role: admin or customer
              if (state.user.role == AppConstants.adminRole) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminHomePage()),
                  (route) => false,
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomerHomePage()),
                  (route) => false,
                );
              }
            }
          },
          child: const LoginPage(), // Default screen before authentication
        ),
      ),
    );
  }
}
