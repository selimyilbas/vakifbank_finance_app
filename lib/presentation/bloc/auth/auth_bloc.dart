import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/get_current_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication Business Logic Component (BLoC)
/// 
/// Manages authentication state for the entire application.
/// Handles user login, registration, logout, and session management.
/// 
/// Key responsibilities:
/// - Process authentication events
/// - Coordinate with use cases for business logic
/// - Emit appropriate states for UI updates
/// - Handle authentication errors gracefully
/// 
/// This BLoC follows the single responsibility principle by focusing
/// only on authentication-related state management.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Use case for handling user login
  final LoginUseCase loginUseCase;
  
  /// Use case for handling user registration
  final RegisterUseCase registerUseCase;
  
  /// Use case for handling user logout
  final LogoutUseCase logoutUseCase;
  
  /// Use case for retrieving current user session
  final GetCurrentUserUseCase getCurrentUserUseCase;

  /// Creates an AuthBloc with required use cases
  /// 
  /// Initializes with [AuthInitial] state and registers event handlers
  /// for each authentication operation.
  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    // Register event handlers
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  /// Handles user login requests
  /// 
  /// Process:
  /// 1. Emit loading state for UI feedback
  /// 2. Execute login use case with provided credentials
  /// 3. Handle success/failure results
  /// 4. Emit appropriate state based on result
  /// 
  /// On success: Emits [AuthAuthenticated] with user data
  /// On failure: Emits [AuthError] with error message
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Show loading indicator
    emit(AuthLoading());
    
    // Attempt login through use case
    final result = await loginUseCase(event.email, event.password);
    
    // Handle result using functional programming pattern
    result.fold(
      // Left side: Handle failure
      (failure) => emit(AuthError(failure.message)),
      // Right side: Handle success
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handles user registration requests
  /// 
  /// Process:
  /// 1. Emit loading state
  /// 2. Execute registration use case with user details
  /// 3. Handle success/failure results
  /// 4. Auto-login user on successful registration
  /// 
  /// Note: Currently restricted to 'customer' role only
  /// Admin accounts must be created manually for security
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Show loading indicator
    emit(AuthLoading());
    
    // Attempt registration through use case
    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
      role: event.role,
    );
    
    // Handle result
    result.fold(
      // Registration failed
      (failure) => emit(AuthError(failure.message)),
      // Registration successful - auto login
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handles user logout requests
  /// 
  /// Process:
  /// 1. Emit loading state
  /// 2. Execute logout use case (clears Firebase session and local cache)
  /// 3. Handle success/failure results
  /// 4. Navigate to login screen on success
  /// 
  /// This ensures complete session cleanup for security
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Show loading indicator
    emit(AuthLoading());
    
    // Attempt logout through use case
    final result = await logoutUseCase();
    
    // Handle result
    result.fold(
      // Logout failed - show error but maintain session
      (failure) => emit(AuthError(failure.message)),
      // Logout successful - clear session
      (_) => emit(AuthUnauthenticated()),
    );
  }

  /// Handles authentication status checks
  /// 
  /// Process:
  /// 1. Emit loading state
  /// 2. Check for existing Firebase session
  /// 3. Retrieve user data if session exists
  /// 4. Emit appropriate state
  /// 
  /// Called on app startup to restore user session
  /// Enables persistent login across app restarts
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Show loading indicator
    emit(AuthLoading());
    
    // Check for current user session
    final result = await getCurrentUserUseCase();
    
    // Handle result
    result.fold(
      // No session found or error occurred
      (failure) => emit(AuthUnauthenticated()),
      // Process user data
      (user) {
        if (user != null) {
          // Valid session exists
          emit(AuthAuthenticated(user));
        } else {
          // No active session
          emit(AuthUnauthenticated());
        }
      },
    );
  }
}