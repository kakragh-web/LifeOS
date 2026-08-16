import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/notes/domain/note.dart';
import 'package:lifeos_ai/features/notes/providers/note_providers.dart';
import 'package:lifeos_ai/shared/widgets/animated_text_field.dart';
import 'package:lifeos_ai/shared/widgets/app_dialog.dart';
import 'package:lifeos_ai/shared/widgets/responsive_scaffold.dart';
import 'package:lifeos_ai/shared/widgets/status_chip.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
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

  final _searchCtrl = TextEditingController();
  String? _filterCategory;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      title: 'Notes',
      currentIndex: 3,
      onDestinationSelected: (index) {
        final route = _destinations[index].route;
        context.push(route);
      },
      destinations: _destinations,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add note',
          onPressed: () => _showNoteForm(context),
        ),
      ],
      body: _NotesBody(
        searchCtrl: _searchCtrl,
        filterCategory: _filterCategory,
        onFilterCategoryChanged: (v) => setState(() => _filterCategory = v),
        onCreateNote: () => _showNoteForm(context),
      ),
    );
  }

  void _showNoteForm(BuildContext context, {Note? note}) {
    final isEdit = note != null;
    final titleCtrl = TextEditingController(text: note?.title ?? '');
    final contentCtrl = TextEditingController(text: note?.content ?? '');
    final catCtrl = TextEditingController(text: note?.category ?? '');
    var pinned = note?.pinned ?? false;

    AppDialog.show(
      context: context,
      title: isEdit ? 'Edit Note' : 'New Note',
      actions: [
        if (isEdit)
          DialogAction(
            label: 'Delete',
            onTap: () async {
              final repo = ref.read(noteRepositoryProvider);
              await repo.deleteNote(note.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            isDestructive: true,
          ),
        DialogAction(
          label: 'Cancel',
          onTap: () => Navigator.of(context).pop(),
        ),
        DialogAction(
          label: isEdit ? 'Save' : 'Create',
          onTap: () async {
            final title = titleCtrl.text.trim();
            if (title.isEmpty) return;
            final navigator = Navigator.of(context);
            final repo = ref.read(noteRepositoryProvider);
            final now = DateTime.now();
            final noteModel = Note(
              id: note?.id ??
                  '${now.millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch}',
              createdAt: note?.createdAt ?? now,
              updatedAt: now,
              title: title,
              content: contentCtrl.text.trim().isEmpty
                  ? null
                  : contentCtrl.text.trim(),
              pinned: pinned,
              category:
                  catCtrl.text.trim().isEmpty ? null : catCtrl.text.trim(),
            );
            if (isEdit) {
              await repo.updateNote(noteModel);
            } else {
              await repo.createNote(noteModel);
            }
            if (navigator.context.mounted) navigator.pop();
          },
          isPrimary: true,
        ),
      ],
    );
  }
}

class _NotesBody extends ConsumerWidget {
  const _NotesBody({
    required this.searchCtrl,
    required this.filterCategory,
    required this.onFilterCategoryChanged,
    required this.onCreateNote,
  });

  final TextEditingController searchCtrl;
  final String? filterCategory;
  final ValueChanged<String?> onFilterCategoryChanged;
  final VoidCallback onCreateNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final notesAsync = ref.watch(notesProvider);
    final categories = ref.watch(noteCategoriesProvider);

    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Breakpoints.maxWideContentWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(context.horizontalPagePadding,
                  AppSpacing.md, context.horizontalPagePadding, AppSpacing.sm),
              child: context.isCompact
                  ? Column(
                      children: [
                        AnimatedTextField(
                          controller: searchCtrl,
                          label: 'Search',
                          hint: 'Search notes...',
                          prefixIcon: Icons.search_rounded,
                          onChanged: (_) => onFilterCategoryChanged(null),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DropdownButtonFormField<String?>(
                          value: filterCategory,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Category', isDense: true),
                          items: [
                            const DropdownMenuItem(
                                value: null, child: Text('All')),
                            ...categories.map((c) =>
                                DropdownMenuItem(value: c, child: Text(c))),
                          ],
                          onChanged: onFilterCategoryChanged,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AnimatedTextField(
                            controller: searchCtrl,
                            label: 'Search',
                            hint: 'Search notes...',
                            prefixIcon: Icons.search_rounded,
                            onChanged: (_) => onFilterCategoryChanged(null),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: DropdownButtonFormField<String?>(
                            value: filterCategory,
                            isExpanded: true,
                            decoration: const InputDecoration(
                                labelText: 'Category', isDense: true),
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text('All')),
                              ...categories.map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c))),
                            ],
                            onChanged: onFilterCategoryChanged,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        Expanded(
          child: notesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
                child: Text('Unable to load notes. Please try again.',
                    style: AppTypography.bodyMedium)),
            data: (notes) {
              final filtered = _filterNotes(notes);
              if (filtered.isEmpty) {
                return _EmptyNotes(cs: cs, onCreate: onCreateNote);
              }
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: Breakpoints.maxWideContentWidth),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.horizontalPagePadding,
                        vertical: AppSpacing.sm),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final note = filtered[i];
                      return _NoteCard(
                          note: note,
                          onTap: () => _showNoteForm(context, note: note));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Note> _filterNotes(List<Note> notes) {
    final query = searchCtrl.text.trim().toLowerCase();
    final pinned = <Note>[];
    final others = <Note>[];
    for (final n in notes) {
      if (n.pinned) {
        pinned.add(n);
      } else {
        others.add(n);
      }
    }
    final list = [...pinned, ...others];
    return list.where((n) {
      if (filterCategory != null &&
          filterCategory!.isNotEmpty &&
          n.category != filterCategory) {
        return false;
      }
      if (query.isNotEmpty &&
          !n.title.toLowerCase().contains(query) &&
          !(n.content ?? '').toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showNoteForm(BuildContext context, {Note? note}) {
    final state = context.findAncestorStateOfType<_NotesScreenState>();
    state?._showNoteForm(context, note: note);
  }
}

class _EmptyNotes extends StatelessWidget {
  const _EmptyNotes({required this.cs, required this.onCreate});

  final ColorScheme cs;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: AppSpacing.md),
            const Text('No notes yet', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create your first note'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.onTap});

  final Note note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(
            color: cs.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
        color: AppColors.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: AppTypography.titleSmall
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (note.pinned)
                    Icon(Icons.push_pin_rounded, size: 18, color: cs.primary),
                ],
              ),
              if (note.content != null && note.content!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  note.content!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium
                      .copyWith(color: cs.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  if (note.category != null && note.category!.isNotEmpty)
                    StatusChip(
                      label: note.category!,
                      isSelected: false,
                      variant: ChipVariant.elevated,
                    ),
                  const Spacer(),
                  Text(_formatDate(note.createdAt),
                      style: AppTypography.caption),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }
    return '${d.month}/${d.day}/${d.year}';
  }
}
