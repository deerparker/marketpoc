import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/banking/services/bank_service.dart';
import '../../features/marketplace/services/marketplace_service.dart';

// Helper to check if we should use mock backend
bool get _useMock => dotenv.env['USE_MOCK_BACKEND']?.toLowerCase() == 'true';

final authServiceProvider = Provider<AuthService>((ref) {
  if (_useMock) {
    return StubAuthService();
  } else {
    return RemoteAuthService();
  }
});

final bankServiceProvider = Provider<BankService>((ref) {
  if (_useMock) {
    return StubBankService();
  } else {
    return RemoteBankService();
  }
});

final marketplaceServiceProvider = Provider<MarketplaceService>((ref) {
  if (_useMock) {
    return StubMarketplaceService();
  } else {
    return RemoteMarketplaceService();
  }
});
