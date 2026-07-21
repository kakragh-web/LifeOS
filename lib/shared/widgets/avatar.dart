import 'package:flutter/material.dart';
import 'package:lifeos_ai/core/theme/app_colors.dart';
import 'package:lifeos_ai/core/theme/app_radius.dart';
import 'package:lifeos_ai/core/theme/app_shadows.dart';
import 'package:lifeos_ai/core/theme/app_spacing.dart';

/// Avatar component with multiple variants and status indicators.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.placeholder,
    this.name,
    this.size = AvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 2,
    this.status,
    this.isOnline = false,
    this.onTap,
  });

  final String? imageUrl;
  final Widget? placeholder;
  final String? name;
  final AvatarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final AvatarStatus? status;
  final bool isOnline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveSize = _getSize();
    final effectiveBackgroundColor = backgroundColor ??
        _getInitialsColor(name ?? '?', colorScheme);
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;

    final avatar = GestureDetector(
      onTap: onTap,
      child: Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: effectiveBackgroundColor,
          border: borderWidth > 0
              ? Border.all(
                  color: borderColor ?? colorScheme.surface,
                  width: borderWidth,
                )
              : null,
          boxShadow: AppShadows.elevation2,
        ),
        child: _buildContent(context, effectiveSize, effectiveForegroundColor),
      ),
    );

    if (status != null || isOnline) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            bottom: 0,
            right: 0,
            child: _StatusIndicator(
              size: effectiveSize,
              status: status,
              isOnline: isOnline,
            ),
          ),
        ],
      );
    }

    return avatar;
  }

  Widget? _buildContent(BuildContext context, double size, Color foregroundColor) {
    if (imageUrl != null) {
      return ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: SizedBox(
                width: size * 0.4,
                height: size * 0.4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(foregroundColor),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildInitials(size, foregroundColor);
          },
        ),
      );
    }

    if (placeholder != null) {
      return Center(child: placeholder);
    }

    return _buildInitials(size, foregroundColor);
  }

  Widget _buildInitials(double size, Color foregroundColor) {
    final initials = _getInitials(name ?? '?');
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.4,
          height: 1,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  double _getSize() {
    return switch (size) {
      AvatarSize.xSmall => 24,
      AvatarSize.small => 32,
      AvatarSize.medium => 40,
      AvatarSize.large => 56,
      AvatarSize.xLarge => 80,
    };
  }

  Color _getInitialsColor(String initials, ColorScheme colorScheme) {
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
    ];
    final index = initials.codeUnits.fold(0, (sum, char) => sum + char) % colors.length;
    return colors[index];
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({
    required this.size,
    this.status,
    required this.isOnline,
  });

  final double size;
  final AvatarStatus? status;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final indicatorSize = size * 0.25;
    final borderWidth = size * 0.06;

    Color indicatorColor = Colors.green;
    if (status == AvatarStatus.busy) indicatorColor = Colors.red;
    if (status == AvatarStatus.away) indicatorColor = Colors.orange;
    if (status == AvatarStatus.offline) indicatorColor = Colors.grey;

    return Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        color: indicatorColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: borderWidth,
        ),
      ),
    );
  }
}

enum AvatarSize { xSmall, small, medium, large, xLarge }
enum AvatarStatus { online, busy, away, offline }
