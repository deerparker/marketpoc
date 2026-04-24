import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum for view mode preference
enum ViewMode { grid, list }

/// Keys for storing preferences
const String _productsViewModeKey = 'products_view_mode';
const String _lifeEventsViewModeKey = 'life_events_view_mode';

/// Provider for SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

/// Notifier for products view mode
class ProductsViewModeNotifier extends Notifier<ViewMode> {
  @override
  ViewMode build() {
    final prefsAsync = ref.watch(sharedPreferencesProvider);
    return prefsAsync.maybeWhen(
      data: (prefs) {
        final stored = prefs.getString(_productsViewModeKey);
        if (stored == 'grid') return ViewMode.grid;
        return ViewMode.list;
      },
      orElse: () => ViewMode.list,
    );
  }

  void setViewMode(ViewMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).whenData((prefs) {
      prefs.setString(_productsViewModeKey, mode.name);
    });
  }

  void toggle() {
    final newMode = state == ViewMode.list ? ViewMode.grid : ViewMode.list;
    setViewMode(newMode);
  }
}

/// Notifier for life events view mode
class LifeEventsViewModeNotifier extends Notifier<ViewMode> {
  @override
  ViewMode build() {
    final prefsAsync = ref.watch(sharedPreferencesProvider);
    return prefsAsync.maybeWhen(
      data: (prefs) {
        final stored = prefs.getString(_lifeEventsViewModeKey);
        if (stored == 'grid') return ViewMode.grid;
        return ViewMode.list;
      },
      orElse: () => ViewMode.list,
    );
  }

  void setViewMode(ViewMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).whenData((prefs) {
      prefs.setString(_lifeEventsViewModeKey, mode.name);
    });
  }

  void toggle() {
    final newMode = state == ViewMode.list ? ViewMode.grid : ViewMode.list;
    setViewMode(newMode);
  }
}

/// Provider for products view mode
final productsViewModeProvider =
    NotifierProvider<ProductsViewModeNotifier, ViewMode>(() {
      return ProductsViewModeNotifier();
    });

/// Provider for life events view mode
final lifeEventsViewModeProvider =
    NotifierProvider<LifeEventsViewModeNotifier, ViewMode>(() {
      return LifeEventsViewModeNotifier();
    });
