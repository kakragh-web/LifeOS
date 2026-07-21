import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/features/auth/providers/auth_provider.dart';
import 'package:lifeos_ai/shared/providers/theme_provider.dart';
import 'package:lifeos_ai/shared/widgets/animated_button.dart';
import 'package:lifeos_ai/shared/widgets/app_dialog.dart';
import 'package:lifeos_ai/shared/widgets/avatar.dart';
import 'package:lifeos_ai/shared/widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        foregroundColor: cs.onSurface,
        elevation: 0,
        title: Text('Settings',
            style:
                AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (user != null) _ProfileCard(user: user, cs: cs),
          const SizedBox(height: AppSpacing.sectionSpacing),
          _SettingsSection(
            title: 'Appearance',
            children: [
              _ThemeToggle(cs: cs, isDark: isDark),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          _SettingsSection(
            title: 'Preferences',
            children: [
              _SettingsTile(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                subtitle: 'Task reminders and alerts',
                onTap: () {},
                cs: cs,
              ),
              _SettingsTile(
                icon: Icons.security_rounded,
                title: 'Privacy & Security',
                subtitle: 'Passcode and biometrics',
                onTap: () {},
                cs: cs,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: '${AppConstants.appName} v${AppConstants.appVersion}',
                onTap: () {},
                cs: cs,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          AnimatedButton(
            label: 'Sign Out',
            onPressed: () async {
              final confirmed = await AppDialog.showConfirm(
                context: context,
                title: 'Sign out?',
                message: 'You will need to sign in again to access your data.',
                confirmText: 'Sign Out',
                isDestructive: true,
              );
              if (confirmed == true) {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out')),
                  );
                }
              }
            },
            variant: ButtonVariant.outlined,
            icon: Icons.logout_rounded,
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user, required this.cs});

  final dynamic user;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      elevation: 1,
      child: Row(
        children: [
          AppAvatar(
            name: user.displayName,
            imageUrl: user.photoUrl,
            size: AvatarSize.large,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? 'User',
                  style: AppTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  user.email,
                  style: AppTypography.bodyMedium
                      .copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
          child: Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GlassCard(
          elevation: 0,
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.cs, required this.isDark});

  final ColorScheme cs;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      subtitle: const Text('Use dark color scheme'),
      value: isDark,
      onChanged: (v) {
        final themeMode = v ? ThemeMode.dark : ThemeMode.light;
        final container = ProviderScope.containerOf(context);
        final notifier = container.read(themeModeProvider.notifier);
        notifier.setMode(themeMode);
      },
      secondary: Icon(
          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          color: cs.primary),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.cs,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: cs.onPrimaryContainer, size: 20),
      ),
      title: Text(title,
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant)),
      trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
