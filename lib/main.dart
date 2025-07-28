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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => di.sl<CurrencyBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<TransactionBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          primarySwatch: MaterialColor(
            0xFFFDB913, 
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
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
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
          child: const LoginPage(),
        ),
      ),
    );
  }
}