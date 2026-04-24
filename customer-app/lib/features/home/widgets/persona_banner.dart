import 'package:flutter/material.dart';
import '../../auth/models/user_persona.dart';

class PersonaBanner extends StatelessWidget {
  final UserPersona persona;

  const PersonaBanner({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    String message;
    Color color;

    switch (persona.id) {
      case 'student':
        icon = Icons.school;
        title = 'Student Benefits';
        message = 'Check out the latest discounts for students in your area.';
        color = Colors.orange;
        break;
      case 'professional':
        icon = Icons.trending_up;
        title = 'Investment Update';
        message = 'Your portfolio is up 2.4% this week. View details.';
        color = Colors.blue;
        break;
      case 'family':
        icon = Icons.house;
        title = 'Mortgage Rates';
        message = 'Review our new fixed-rate mortgages tailored for families.';
        color = Colors.green;
        break;
      case 'retiree':
        icon = Icons.beach_access;
        title = 'Pension Planning';
        message = 'Schedule a review with your pension advisor.';
        color = Colors.purple;
        break;
      default:
        icon = Icons.info;
        title = 'Update';
        message = 'Check your latest notifications.';
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(message, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
