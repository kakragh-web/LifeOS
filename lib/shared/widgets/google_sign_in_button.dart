import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
    this.enabled = true,
  });

  final VoidCallback? onTap;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final effectiveOnTap = (isLoading || !enabled) ? null : onTap;

    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: effectiveOnTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: cs.surface,
          foregroundColor: Colors.black87,
          side: BorderSide(color: cs.outlineVariant),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Image.asset(
          'assets/images/google_logo.png',
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.g_mobiledata_rounded, size: 20);
          },
        ),
        label: Text(
          enabled ? 'Continue with Google' : 'Google Sign-In unavailable',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: enabled ? null : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
