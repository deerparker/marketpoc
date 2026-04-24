import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';

/// Data sharing preference levels - how much of YOUR data is shared with sellers
enum DataShareLevel {
  anonymous, // No personal details shared with sellers
  limited, // Partial info (e.g., partial postcode, first name initial)
  extended, // More details shared (first name, full postcode area)
}

/// Privacy settings state
class PrivacySettings {
  final bool marketplaceEnabled;
  final bool marketplaceRecommendationsEnabled;
  final bool financialProductRecommendationsEnabled;
  final DataShareLevel dataShareLevel;

  const PrivacySettings({
    this.marketplaceEnabled = true,
    this.marketplaceRecommendationsEnabled = true,
    this.financialProductRecommendationsEnabled = true,
    this.dataShareLevel = DataShareLevel.anonymous,
  });

  PrivacySettings copyWith({
    bool? marketplaceEnabled,
    bool? marketplaceRecommendationsEnabled,
    bool? financialProductRecommendationsEnabled,
    DataShareLevel? dataShareLevel,
  }) {
    return PrivacySettings(
      marketplaceEnabled: marketplaceEnabled ?? this.marketplaceEnabled,
      marketplaceRecommendationsEnabled:
          marketplaceRecommendationsEnabled ??
          this.marketplaceRecommendationsEnabled,
      financialProductRecommendationsEnabled:
          financialProductRecommendationsEnabled ??
          this.financialProductRecommendationsEnabled,
      dataShareLevel: dataShareLevel ?? this.dataShareLevel,
    );
  }
}

/// Provider for privacy settings
final privacySettingsProvider =
    AsyncNotifierProvider<PrivacySettingsNotifier, PrivacySettings>(
      PrivacySettingsNotifier.new,
    );

class PrivacySettingsNotifier extends AsyncNotifier<PrivacySettings> {
  static const _keyMarketplaceEnabled = 'privacy_marketplace_enabled';
  static const _keyMarketplaceRecommendations =
      'privacy_marketplace_recommendations';
  static const _keyFinancialRecommendations =
      'privacy_financial_recommendations';
  static const _keyDataShareLevel = 'privacy_data_share_level';

  String? _currentUserId;

  // Helper to get user-specific keys
  String _getUserKey(String baseKey, String userId) {
    return '${baseKey}_$userId';
  }

  @override
  Future<PrivacySettings> build() async {
    // Watch auth state to reload settings when user changes
    final user = ref.watch(authProvider);
    final userId = user?.id ?? 'guest';

    // If user changed, reload settings
    if (_currentUserId != userId) {
      _currentUserId = userId;
    }

    final prefs = await SharedPreferences.getInstance();

    return PrivacySettings(
      marketplaceEnabled:
          prefs.getBool(_getUserKey(_keyMarketplaceEnabled, userId)) ?? true,
      marketplaceRecommendationsEnabled:
          prefs.getBool(_getUserKey(_keyMarketplaceRecommendations, userId)) ??
          true,
      financialProductRecommendationsEnabled:
          prefs.getBool(_getUserKey(_keyFinancialRecommendations, userId)) ??
          true,
      dataShareLevel:
          DataShareLevel.values[prefs.getInt(
                _getUserKey(_keyDataShareLevel, userId),
              ) ??
              DataShareLevel.anonymous.index],
    );
  }

  Future<void> setMarketplaceEnabled(bool value) async {
    if (_currentUserId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      _getUserKey(_keyMarketplaceEnabled, _currentUserId!),
      value,
    );
    state = AsyncData(state.value!.copyWith(marketplaceEnabled: value));
  }

  Future<void> setMarketplaceRecommendationsEnabled(bool value) async {
    if (_currentUserId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      _getUserKey(_keyMarketplaceRecommendations, _currentUserId!),
      value,
    );
    state = AsyncData(
      state.value!.copyWith(marketplaceRecommendationsEnabled: value),
    );
  }

  Future<void> setFinancialProductRecommendationsEnabled(bool value) async {
    if (_currentUserId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      _getUserKey(_keyFinancialRecommendations, _currentUserId!),
      value,
    );
    state = AsyncData(
      state.value!.copyWith(financialProductRecommendationsEnabled: value),
    );
  }

  Future<void> setDataShareLevel(DataShareLevel level) async {
    if (_currentUserId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _getUserKey(_keyDataShareLevel, _currentUserId!),
      level.index,
    );
    state = AsyncData(state.value!.copyWith(dataShareLevel: level));
  }
}
