import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'privacy_settings_provider.dart';

class MarketplaceSettingsScreen extends ConsumerWidget {
  const MarketplaceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(privacySettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (settings) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Policy Section
              _buildSectionHeader(context, 'Privacy Policy'),
              const SizedBox(height: 8),
              _buildPrivacyPolicyCard(context),
              const SizedBox(height: 24),

              // Toggle Options Section
              _buildSectionHeader(context, 'Display Options'),
              const SizedBox(height: 8),
              _buildToggleCard(
                context,
                title: 'Show Marketplace',
                subtitle: 'Display the Marketplace tab in the navigation bar',
                value: settings.marketplaceEnabled,
                onChanged: (value) => ref
                    .read(privacySettingsProvider.notifier)
                    .setMarketplaceEnabled(value),
              ),
              const SizedBox(height: 12),
              _buildToggleCard(
                context,
                title: 'Marketplace Recommendations',
                subtitle: 'Show personalised product recommendations',
                value: settings.marketplaceRecommendationsEnabled,
                onChanged: (value) => ref
                    .read(privacySettingsProvider.notifier)
                    .setMarketplaceRecommendationsEnabled(value),
              ),
              const SizedBox(height: 12),
              _buildToggleCard(
                context,
                title: 'Financial Product Recommendations',
                subtitle:
                    'Show bank product suggestions based on your activity',
                value: settings.financialProductRecommendationsEnabled,
                onChanged: (value) => ref
                    .read(privacySettingsProvider.notifier)
                    .setFinancialProductRecommendationsEnabled(value),
              ),
              const SizedBox(height: 24),

              // Data Sharing Section
              _buildSectionHeader(context, 'Data Sharing'),
              const SizedBox(height: 8),
              _buildDataSharingCard(context, ref, settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildPrivacyPolicyCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Marketplace Privacy Policy',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'When you use the Marketbank Marketplace, we are committed to protecting your privacy and personal information.\n\n'
              '**Data Collection**\n'
              'We collect information necessary to facilitate marketplace transactions, including your browsing history within the marketplace, products you view and purchase, and communications with sellers.\n\n'
              '**Data Use**\n'
              'Your data is used to:\n'
              '• Provide and improve marketplace services\n'
              '• Show relevant product recommendations\n'
              '• Facilitate communication between you and sellers\n'
              '• Detect and prevent fraud\n\n'
              '**Data Sharing**\n'
              'We may share limited information with sellers when you initiate contact (such as via WhatsApp). This includes your chosen display name and the product you\'re enquiring about. We never share your banking details, account numbers, or login credentials with third-party sellers.\n\n'
              '**Your Rights**\n'
              'You have the right to access, correct, or delete your marketplace data at any time. Use the toggles above to control what features are enabled and how your data is used.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDataSharingCard(
    BuildContext context,
    WidgetRef ref,
    PrivacySettings settings,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Default Data Sharing Level',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose how much of your personal information is shared with sellers when you contact them:',
            ),
            const SizedBox(height: 12),
            RadioGroup<DataShareLevel>(
              groupValue: settings.dataShareLevel,
              onChanged: (value) => ref
                  .read(privacySettingsProvider.notifier)
                  .setDataShareLevel(value!),
              child: Column(
                children: [
                  RadioListTile<DataShareLevel>(
                    title: const Text('Anonymous'),
                    subtitle: const Text(
                      'No personal details shared with sellers',
                    ),
                    value: DataShareLevel.anonymous,
                  ),
                  RadioListTile<DataShareLevel>(
                    title: const Text('Limited'),
                    subtitle: const Text(
                      'Partial postcode area, first name initial',
                    ),
                    value: DataShareLevel.limited,
                  ),
                  RadioListTile<DataShareLevel>(
                    title: const Text('Extended'),
                    subtitle: const Text('First name, full postcode area'),
                    value: DataShareLevel.extended,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
