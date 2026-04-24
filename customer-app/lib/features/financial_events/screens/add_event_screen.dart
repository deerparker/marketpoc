import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/financial_event.dart';
import '../providers/financial_events_provider.dart';

class AddEventScreen extends ConsumerWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableTypes = ref.watch(availableEventTypesProvider);

    // Grouping Logic
    final healthWellness = availableTypes
        .where((e) => e.type == FinancialEventType.gettingFit)
        .toList();
    final familyRelationships = availableTypes.where((e) {
      return [
        FinancialEventType.havingBaby,
        FinancialEventType.gettingMarried,
        FinancialEventType.divorce,
        FinancialEventType.bereavement,
        FinancialEventType.anniversary,
        FinancialEventType.birthday,
        FinancialEventType.christmas,
      ].contains(e.type);
    }).toList();
    final housingAssets = availableTypes.where((e) {
      return [
        FinancialEventType.buyingHouse,
        FinancialEventType.buyingCar,
      ].contains(e.type);
    }).toList();
    final careerEducation = availableTypes.where((e) {
      return [
        FinancialEventType.retirement,
        FinancialEventType.startingBusiness,
        FinancialEventType.university,
        FinancialEventType.startingSchool,
        FinancialEventType.newJob,
      ].contains(e.type);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Life Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Life Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (healthWellness.isNotEmpty) ...[
              _buildSectionTitle('Health & Wellness'),
              _buildEventList(context, healthWellness),
              const SizedBox(height: 24),
            ],
            if (housingAssets.isNotEmpty) ...[
              _buildSectionTitle('Housing & Assets'),
              _buildEventList(context, housingAssets),
              const SizedBox(height: 24),
            ],
            if (familyRelationships.isNotEmpty) ...[
              _buildSectionTitle('Family & Relationships'),
              _buildEventList(context, familyRelationships),
              const SizedBox(height: 24),
            ],
            if (careerEducation.isNotEmpty) ...[
              _buildSectionTitle('Career & Education'),
              _buildEventList(context, careerEducation),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, List<FinancialEvent> events) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final template = events[index];
        return GestureDetector(
          onTap: () {
            // Navigate to setup screen
            context.go('/banking/add-event/setup', extra: template);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  _getIconForType(template.type),
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    template.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForType(FinancialEventType type) {
    switch (type) {
      case FinancialEventType.buyingHouse:
        return Icons.home;
      case FinancialEventType.havingBaby:
        return Icons.child_friendly;
      case FinancialEventType.gettingMarried:
        return Icons.favorite;
      case FinancialEventType.retirement:
        return Icons.beach_access;
      case FinancialEventType.startingBusiness:
        return Icons.store;
      case FinancialEventType.university:
        return Icons.school;
      case FinancialEventType.startingSchool:
        return Icons.backpack;
      case FinancialEventType.christmas:
        return Icons.severe_cold;
      case FinancialEventType.anniversary:
        return Icons.favorite;
      case FinancialEventType.birthday:
        return Icons.cake;
      case FinancialEventType.buyingCar:
        return Icons.directions_car;
      case FinancialEventType.newJob:
        return Icons.work;
      case FinancialEventType.divorce:
        return Icons.broken_image;
      case FinancialEventType.bereavement:
        return Icons.spa;
      case FinancialEventType.gettingFit:
        return Icons.fitness_center;
    }
  }
}
