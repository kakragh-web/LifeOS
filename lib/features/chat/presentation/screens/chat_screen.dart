import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/chat/domain/chat_message.dart';
import 'package:lifeos_ai/features/chat/providers/chat_provider.dart';
import 'package:lifeos_ai/shared/widgets/animated_button.dart';
import 'package:lifeos_ai/shared/widgets/responsive_scaffold.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _destinations = <({IconData icon, String label, String route})>[
    (icon: Icons.dashboard_outlined, label: 'Home', route: AppRoutes.dashboard),
    (
      icon: Icons.check_circle_outline_rounded,
      label: 'Tasks',
      route: AppRoutes.tasks
    ),
    (icon: Icons.event_outlined, label: 'Calendar', route: AppRoutes.calendar),
    (icon: Icons.note_outlined, label: 'Notes', route: AppRoutes.notes),
    (icon: Icons.smart_toy_outlined, label: 'AI Chat', route: AppRoutes.chat),
    (
      icon: Icons.settings_outlined,
      label: 'Settings',
      route: AppRoutes.settings
    ),
  ];

  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _isTyping = false;

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    setState(() => _isTyping = true);
    ref.read(chatMessagesProvider.notifier).send(text);
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _isTyping = false);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      title: 'AI Assistant',
      currentIndex: 4,
      onDestinationSelected: (index) {
        final route = _destinations[index].route;
        context.push(route);
      },
      destinations: _destinations,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          tooltip: 'Clear chat',
          onPressed: ref.watch(chatMessagesProvider).isEmpty
              ? null
              : () => ref.read(chatMessagesProvider.notifier).clear(),
        ),
      ],
      body: _ChatBody(
        ctrl: _ctrl,
        scroll: _scroll,
        onSend: _send,
        isTyping: _isTyping,
        messages: ref.watch(chatMessagesProvider),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.ctrl,
    required this.scroll,
    required this.onSend,
    required this.isTyping,
    required this.messages,
  });

  final TextEditingController ctrl;
  final ScrollController scroll;
  final VoidCallback onSend;
  final bool isTyping;
  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: Breakpoints.maxWideContentWidth),
              child: messages.isEmpty && !isTyping
                  ? _EmptyState(cs: cs)
                  : ListView.builder(
                      controller: scroll,
                      padding: EdgeInsets.fromLTRB(
                          context.horizontalPagePadding,
                          16,
                          context.horizontalPagePadding,
                          8),
                      itemCount: messages.length + (isTyping ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (isTyping && i == messages.length) {
                          return const _TypingIndicator();
                        }
                        return _Bubble(message: messages[i]);
                      },
                    ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Breakpoints.maxWideContentWidth),
            child: _InputBar(ctrl: ctrl, onSend: onSend),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.primaryGlow(),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/lifeos_logo.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(AppConstants.appName,
                style: AppTypography.headlineSmall
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ask me anything about your tasks, schedule, or goals.',
              textAlign: TextAlign.center,
              style:
                  AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.ctrl, required this.onSend});

  final TextEditingController ctrl;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 8, 16, MediaQuery.viewInsetsOf(context).bottom + 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    hintText: 'Message LifeOS AI…',
                    hintStyle: AppTypography.bodyMedium
                        .copyWith(color: cs.onSurfaceVariant),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none),
                  ),
                  onSubmitted: (_) => onSend(),
                  textInputAction: TextInputAction.send,
                  maxLines: 4,
                  minLines: 1,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AnimatedButton(
              icon: Icons.send_rounded,
              label: '',
              onPressed: onSend,
              variant: ButtonVariant.filled,
              size: ButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? cs.primary : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Text(
          message.content,
          style: AppTypography.bodyMedium
              .copyWith(color: isUser ? cs.onPrimary : cs.onSurface),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final delay = i / 3;
              final opacity = ((_controller.value - delay) % 1.0).abs();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.onSurfaceVariant.withOpacity(0.3 + opacity * 0.7),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
