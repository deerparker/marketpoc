import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_persona.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends Notifier<UserPersona?> {
  @override
  UserPersona? build() {
    return null; // Initially not logged in
  }

  Future<void> login(UserPersona persona) async {
    // Attempt to restore preferences
    final prefs = await SharedPreferences.getInstance();
    final showDashboard = prefs.getBool('dashboard_pref_${persona.id}');

    if (showDashboard != null) {
      state = persona.copyWith(showPersonalizedDashboard: showDashboard);
    } else {
      state = persona;
    }
  }

  Future<void> updatePersona(UserPersona updatedPersona) async {
    state = updatedPersona;
    // Persist changes
    if (updatedPersona.id.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
        'dashboard_pref_${updatedPersona.id}',
        updatedPersona.showPersonalizedDashboard,
      );
    }
  }

  void logout() {
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserPersona?>(
  AuthNotifier.new,
);
