import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/notes/domain/note.dart';
import 'package:lifeos_ai/features/notes/providers/note_providers.dart';
import 'package:lifeos_ai/shared/widgets/app_text_field.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _searchCtrl = TextEditingController();
  String? _filterCategory;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final notesAsync = ref.watch(notesProvider);
    final categories = ref.watch(noteCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add note',
            onPressed: () => _showNoteForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: Breakpoints.maxWideContentWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(context.horizontalPagePadding, 12,
                    context.horizontalPagePadding, 8),
                child: context.isCompact
                    ? Column(
                        children: [
                          TextField(
                            controller: _searchCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Search notes...',
                              prefixIcon: Icon(Icons.search_rounded),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String?>(
                            value: _filterCategory,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              isDense: true,
                            ),
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text('All')),
                              ...categories.map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c))),
                            ],
                            onChanged: (v) =>
                                setState(() => _filterCategory = v),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _searchCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Search notes...',
                                prefixIcon: Icon(Icons.search_rounded),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              value: _filterCategory,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                isDense: true,
                              ),
                              items: [
                                const DropdownMenuItem(
                                    value: null, child: Text('All')),
                                ...categories.map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c))),
                              ],
                              onChanged: (v) =>
                                  setState(() => _filterCategory = v),
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
                child: Semantics(
                  label: 'Error loading notes',
                  child: Text('Error: $e'),
                ),
              ),
              data: (notes) {
                final filtered = _filterNotes(notes);
                if (filtered.isEmpty) {
                  return _EmptyNotes(
                      cs: cs, onCreate: () => _showNoteForm(context));
                }
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: Breakpoints.maxWideContentWidth),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.horizontalPagePadding,
                          vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final note = filtered[i];
                        return _NoteCard(
                          note: note,
                          onTap: () => _showNoteForm(context, note: note),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Note'),
      ),
    );
  }

  List<Note> _filterNotes(List<Note> notes) {
    final query = _searchCtrl.text.trim().toLowerCase();
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
      if (_filterCategory != null &&
          _filterCategory!.isNotEmpty &&
          n.category != _filterCategory) return false;
      if (query.isNotEmpty &&
          !n.title.toLowerCase().contains(query) &&
          !(n.content ?? '').toLowerCase().contains(query)) return false;
      return true;
    }).toList();
  }

  void _showNoteForm(BuildContext context, {Note? note}) {
    final isEdit = note != null;
    final titleCtrl = TextEditingController(text: note?.title ?? '');
    final contentCtrl = TextEditingController(text: note?.content ?? '');
    final catCtrl = TextEditingController(text: note?.category ?? '');
    var pinned = note?.pinned ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Note' : 'New Note'),
        content: SizedBox(
          width: (MediaQuery.sizeOf(context).width - 80)
              .clamp(0.0, 420.0)
              .toDouble(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: titleCtrl,
                  label: 'Title',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: contentCtrl,
                  label: 'Content',
                  maxLines: 6,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: catCtrl,
                        label: 'Category',
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilterChip(
                      label: const Text('Pinned'),
                      selected: pinned,
                      onSelected: (v) => setState(() => pinned = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (isEdit)
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await ref.read(noteRepositoryProvider).deleteNote(note.id);
                if (mounted) navigator.pop();
              },
              child: Text('Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
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
              if (mounted) navigator.pop();
            },
            child: Text(isEdit ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotes extends StatelessWidget {
  const _EmptyNotes({required this.cs, required this.onCreate});
  final ColorScheme cs;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: 'No notes yet icon',
                    child: Icon(Icons.note_outlined,
                        size: 56, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: 'No notes yet',
                    child: Text('No notes yet',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Create your first note button',
                    child: TextButton.icon(
                      onPressed: onCreate,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create your first note'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  if (note.pinned)
                    Icon(Icons.push_pin_rounded, size: 18, color: cs.primary),
                ],
              ),
              if (note.content != null && note.content!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  note.content!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (note.category != null && note.category!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        note.category!,
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSecondaryContainer,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    _formatDate(note.createdAt),
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
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
