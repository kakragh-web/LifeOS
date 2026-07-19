import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';
import 'package:lifeos_ai/shared/widgets/app_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user != null)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,
                backgroundColor: cs.primaryContainer,
                child: user.photoUrl == null
                    ? Text(
                        user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(color: cs.onPrimaryContainer),
                      )
                    : null,
              ),
              title: Text(user.displayName ?? 'User'),
              subtitle: Text(user.email),
            ),
          const Divider(height: 32),
          AppButton.outlined(
            label: 'Sign Out',
            icon: Icons.logout_rounded,
            onPressed: () =>
                ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
