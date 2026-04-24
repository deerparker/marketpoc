import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:customer_app/features/auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.1),
              child: user != null
                  ? Text(
                      user.avatarChar,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : const Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Guest',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user?.segment ?? 'No Persona Selected',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text('Marketplace Settings'),
              subtitle: const Text(
                'Privacy, recommendations, and data sharing',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/profile/marketplace-settings'),
            ),
            const Divider(),
            if (user != null)
              SwitchListTile(
                secondary: Icon(
                  Icons.dashboard_customize_outlined,
                  color: Colors.grey[700],
                ),
                title: const Text('Personalized Dashboard'),
                subtitle: const Text('Show widgets and goals on home'),
                value: user.showPersonalizedDashboard,
                onChanged: (value) {
                  final updated = user.copyWith(
                    showPersonalizedDashboard: value,
                  );
                  ref.read(authProvider.notifier).updatePersona(updated);
                },
              ),
            const Divider(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logout and redirect to login
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                  child: const Text('Logout'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
