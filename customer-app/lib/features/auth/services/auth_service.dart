abstract class AuthService {
  Future<bool> login(String username, String password);
  Future<void> logout();
  Future<bool> get isAuthenticated;
  Future<String?> get token;
}

class StubAuthService implements AuthService {
  bool _loggedIn = false;

  @override
  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _loggedIn = true;
    return true;
  }

  @override
  Future<void> logout() async {
    _loggedIn = false;
  }

  @override
  Future<bool> get isAuthenticated async => _loggedIn;

  @override
  Future<String?> get token async => _loggedIn ? 'mock_token_123' : null;
}

class RemoteAuthService implements AuthService {
  @override
  Future<bool> login(String username, String password) async {
    // TODO: Implement actual API call
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement actual API call
    throw UnimplementedError();
  }

  @override
  Future<bool> get isAuthenticated async {
    // TODO: Implement actual check
    return false;
  }

  @override
  Future<String?> get token async {
    // TODO: Implement actual token storage/retrieval
    return null;
  }
}
