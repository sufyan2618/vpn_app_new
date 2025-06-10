import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final user = _supabase.auth.currentUser;
    return user?.email;
  }

  Future<void> updateUsername(String username) async {
    await _supabase.auth.updateUser(UserAttributes(data: {'username': username}));
  }

  Future<void> updateEmail(String newEmail) async {
    await _supabase.auth.updateUser(UserAttributes(email: newEmail));
  }

  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
  String? getCurrentUsernane() {
    final user = _supabase.auth.currentUser;
    return user?.userMetadata?['username'];
  }

}


final authService = AuthService();
