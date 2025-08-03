// lib/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  void login(String username, String password) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.login(username, password);
      if (success) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void logout() async {
    await _authRepository.logout();
    emit(AuthInitial());
  }
}
