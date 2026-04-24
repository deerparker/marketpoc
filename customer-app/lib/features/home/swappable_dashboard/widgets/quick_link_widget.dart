import 'package:flutter/material.dart';
import '../models/items.dart';
import 'dashboard_widget_container.dart';

// --- Configurable Quick Link Widget ---
class QuickLinkWidget extends StatelessWidget {
  final ItemData item;
  final VoidCallback? onTap;
  const QuickLinkWidget({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final serviceType = item.config['serviceType'] ?? 'chat';

    // Map service types to icons and labels
    final serviceConfig = _getServiceConfig(serviceType);

    // Quick Links don't show the standard header
    return DashboardWidgetContainer(
      onTap: onTap,
      title: 'Quick Link',
      color: item.color,
      showHeader: false, // Hide header as per request
      child: Center(
        child: serviceType == 'freeze'
            ? _FreezeCardContent(color: item.color)
            : _ServiceButton(
                icon: serviceConfig['icon'] as IconData,
                label: serviceConfig['label'] as String,
              ),
      ),
    );
  }

  Map<String, dynamic> _getServiceConfig(String serviceType) {
    switch (serviceType) {
      case 'chat':
        return {'icon': Icons.chat_bubble_outline, 'label': 'Chat'};
      case 'freeze':
        return {'icon': Icons.ac_unit, 'label': 'Freeze'};
      case 'branch':
        return {'icon': Icons.location_on_outlined, 'label': 'Branch'};
      case 'statement':
        return {'icon': Icons.description_outlined, 'label': 'Statements'};
      case 'transfer':
        return {'icon': Icons.swap_horiz, 'label': 'Transfer'};
      case 'budget':
        return {'icon': Icons.pie_chart_outline, 'label': 'Budget'};
      default:
        return {'icon': Icons.help_outline, 'label': 'Service'};
    }
  }
}

class _FreezeCardContent extends StatefulWidget {
  final Color color;
  const _FreezeCardContent({required this.color});

  @override
  State<_FreezeCardContent> createState() => _FreezeCardContentState();
}

class _FreezeCardContentState extends State<_FreezeCardContent> {
  bool isFrozen = false;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Card Visual
              Container(
                width: 24, // Smaller from 28
                height: 15, // Smaller from 18
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: widget.color, width: 1),
                ),
                child: Center(
                  child: Icon(Icons.credit_card, size: 8, color: widget.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2), // Changed from 6
          Text(
            'Freeze',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10, // Smaller from 11
              color: Colors.grey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1), // Smaller from 2
          SizedBox(
            height: 16, // Smaller from 18
            child: Transform.scale(
              scale: 0.45, // Smaller from 0.5
              child: Switch.adaptive(
                value: isFrozen,
                activeColor: widget.color,
                onChanged: (val) => setState(() => isFrozen = val),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServiceButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8), // Reduced from 10
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor,
          ), // Reduced from 22
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ), // Reduced from 11
        ),
      ],
    );
  }
}
