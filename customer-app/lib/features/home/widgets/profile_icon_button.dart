import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileIconButton extends StatelessWidget {
  const ProfileIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.push('/profile'),
      icon: const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 18, color: Colors.white),
      ),
    );
  }
}
