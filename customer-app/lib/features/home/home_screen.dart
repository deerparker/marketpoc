import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/profile_icon_button.dart';
import '../auth/providers/auth_provider.dart';
import 'swappable_dashboard/views/swappable_dashboard.dart';
import 'swappable_dashboard/controllers/dashboard_controller.dart';
import 'widgets/persona_banner.dart';
import 'widgets/standard_dashboard.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persona = ref.watch(authProvider);
    final isLocked = ref.watch(dashboardProvider.select((s) => s.isLocked));

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: (persona?.showPersonalizedDashboard ?? false)
                ? () => ref.read(dashboardProvider.notifier).toggleLock()
                : null,
            child: (persona?.showPersonalizedDashboard ?? false)
                ? Text(
                    isLocked ? 'Customize' : 'Done',
                    style: TextStyle(
                      color: isLocked
                          ? Theme.of(context).primaryColor
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          const ProfileIconButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome back, ',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    TextSpan(
                      text: persona?.name ?? 'Guest',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Persona Specific Widget (Extracted)
            if (persona != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PersonaBanner(persona: persona),
              ),

            // Dashboard Area (Swappable vs Standard)
            if (persona?.showPersonalizedDashboard ?? false)
              const DashboardArea()
            else
              const StandardDashboard(),

            // Bottom padding
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
