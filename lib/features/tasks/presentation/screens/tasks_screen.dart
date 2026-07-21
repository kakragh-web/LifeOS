import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/tasks/domain/task.dart';
import 'package:lifeos_ai/features/tasks/providers/task_providers.dart';
import 'package:lifeos_ai/shared/widgets/animated_fab.dart';
import 'package:lifeos_ai/shared/widgets/animated_text_field.dart';
import 'package:lifeos_ai/shared/widgets/app_bottom_sheet.dart';
import 'package:lifeos_ai/shared/widgets/app_dialog.dart';
import 'package:lifeos_ai/shared/widgets/glass_card.dart';
import 'package:lifeos_ai/shared/widgets/status_chip.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskPriority _filterPriority = TaskPriority.medium;
  TaskStatus _filterStatus = TaskStatus.todo;
  String? _filterCategory;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tasksAsync = ref.watch(tasksProvider);
    final categories = ref.watch(taskCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withOpacity( 0.9),
        foregroundColor: cs.onSurface,
        elevation: 0,
        title: Text('Tasks', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add task',
            onPressed: () => _showTaskForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _Filters(
            cs: cs,
            categories: categories,
            filterPriority: _filterPriority,
            filterStatus: _filterStatus,
            filterCategory: _filterCategory,
            searchCtrl: _searchCtrl,
            onPriorityChanged: (p) => setState(() => _filterPriority = p),
            onStatusChanged: (s) => setState(() => _filterStatus = s),
            onCategoryChanged: (c) => setState(() => _filterCategory = c),
            onSearchChanged: (_) => setState(() {}),
          ),
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Error: $e', style: AppTypography.bodyMedium),
              ),
              data: (tasks) {
                final filtered = _filterTasks(tasks);
                if (filtered.isEmpty) {
                  return _EmptyTasks(cs: cs, onCreate: () => _showTaskForm(context));
                }
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Breakpoints.maxWideContentWidth),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: context.horizontalPagePadding, vertical: AppSpacing.sm),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final task = filtered[i];
                        return _TaskTile(
                          task: task,
                          onToggleStatus: () => _updateStatus(context, task, _nextStatus(task.status)),
                          onEdit: () => _showTaskForm(context, task: task),
                          onDelete: () => _confirmDelete(context, task),
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
      floatingActionButton: AnimatedFAB(
        icon: Icons.add_rounded,
        label: 'Add Task',
        isExtended: true,
        onPressed: () => _showTaskForm(context),
      ),
    );
  }

  TaskStatus _nextStatus(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo: return TaskStatus.inProgress;
      case TaskStatus.inProgress: return TaskStatus.done;
      case TaskStatus.done: return TaskStatus.todo;
    }
  }

  List<Task> _filterTasks(List<Task> tasks) {
    final query = _searchCtrl.text.trim().toLowerCase();
    return tasks.where((t) {
      if (_filterPriority != TaskPriority.medium && t.priority != _filterPriority) return false;
      if (_filterStatus != TaskStatus.todo && t.status != _filterStatus) return false;
      if (_filterCategory != null && _filterCategory!.isNotEmpty && t.category != _filterCategory) return false;
      if (query.isNotEmpty && !t.title.toLowerCase().contains(query) && !(t.description ?? '').toLowerCase().contains(query)) return false;
      return true;
    }).toList();
  }

  void _showTaskForm(BuildContext context, {Task? task}) {
    final isEdit = task != null;
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    final catCtrl = TextEditingController(text: task?.category ?? '');
    final dueCtrl = TextEditingController(
      text: task?.dueDate != null ? '${task!.dueDate!.year}-${task.dueDate!.month.toString().padLeft(2, '0')}-${task.dueDate!.day.toString().padLeft(2, '0')}' : '',
    );
    var priority = task?.priority ?? TaskPriority.medium;
    var status = task?.status ?? TaskStatus.todo;

    AppDialog.show(
      context: context,
      title: isEdit ? 'Edit Task' : 'New Task',
      actions: [
        if (isEdit)
          DialogAction(
            label: 'Delete',
            onTap: () async {
              final repo = ref.read(taskRepositoryProvider);
              await repo.deleteTask(task.id);
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
            final repo = ref.read(taskRepositoryProvider);
            final now = DateTime.now();
            final due = dueCtrl.text.trim().isEmpty ? null : DateTime.tryParse(dueCtrl.text.trim());
            final taskModel = Task(
              id: task?.id ?? '${now.millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch}',
              createdAt: task?.createdAt ?? now,
              updatedAt: now,
              title: title,
              description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
              priority: priority,
              status: status,
              category: catCtrl.text.trim().isEmpty ? null : catCtrl.text.trim(),
              dueDate: due,
            );
            if (isEdit) {
              await repo.updateTask(taskModel);
            } else {
              await repo.createTask(taskModel);
            }
            if (navigator.context.mounted) navigator.pop();
          },
          isPrimary: true,
        ),
      ],
    );
  }

  void _updateStatus(BuildContext context, Task task, TaskStatus newStatus) async {
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(taskRepositoryProvider).updateTask(task.copyWith(status: newStatus, updatedAt: DateTime.now()));
    if (mounted) {
      messenger.showSnackBar(SnackBar(content: Text('Task updated to ${newStatus.name}')));
    }
  }

  void _confirmDelete(BuildContext context, Task task) {
    AppDialog.showConfirm(
      context: context,
      title: 'Delete task?',
      message: '"${task.title}" will be removed permanently.',
      confirmText: 'Delete',
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(taskRepositoryProvider).deleteTask(task.id);
      }
    });
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks({required this.cs, required this.onCreate});

  final ColorScheme cs;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 48, color: cs.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text('No tasks yet', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create your first task'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.cs,
    required this.categories,
    required this.filterPriority,
    required this.filterStatus,
    required this.filterCategory,
    required this.searchCtrl,
    required this.onPriorityChanged,
    required this.onStatusChanged,
    required this.onCategoryChanged,
    required this.onSearchChanged,
  });

  final ColorScheme cs;
  final List<String> categories;
  final TaskPriority filterPriority;
  final TaskStatus filterStatus;
  final String? filterCategory;
  final TextEditingController searchCtrl;
  final ValueChanged<TaskPriority> onPriorityChanged;
  final ValueChanged<TaskStatus> onStatusChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final priorityDropdown = DropdownButtonFormField<TaskPriority>(
      value: filterPriority,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Priority', isDense: true),
      items: [
        const DropdownMenuItem(value: TaskPriority.medium, child: Text('Any')),
        ...TaskPriority.values.where((p) => p != TaskPriority.medium).map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))),
      ],
      onChanged: (v) => onPriorityChanged(v ?? TaskPriority.medium),
    );

    final statusDropdown = DropdownButtonFormField<TaskStatus>(
      value: filterStatus,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Status', isDense: true),
      items: [
        const DropdownMenuItem(value: TaskStatus.todo, child: Text('Any')),
        ...TaskStatus.values.where((s) => s != TaskStatus.todo).map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))),
      ],
      onChanged: (v) => onStatusChanged(v ?? TaskStatus.todo),
    );

    final categoryDropdown = DropdownButtonFormField<String?>(
      value: filterCategory,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Category', isDense: true),
      items: [
        const DropdownMenuItem(value: null, child: Text('Any')),
        ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c))),
      ],
      onChanged: onCategoryChanged,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.maxWideContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.horizontalPagePadding, AppSpacing.md, context.horizontalPagePadding, AppSpacing.sm),
          child: Column(
            children: [
              AnimatedTextField(
                controller: searchCtrl,
                label: 'Search',
                hint: 'Search tasks...',
                prefixIcon: Icons.search_rounded,
                isGlass: true,
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (context.isCompact) ...[
                Row(
                  children: [
                    Expanded(child: priorityDropdown),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: statusDropdown),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                categoryDropdown,
              ] else
                Row(
                  children: [
                    Expanded(child: priorityDropdown),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: statusDropdown),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: categoryDropdown),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final priorityColor = switch (task.priority) {
      TaskPriority.low => cs.tertiary,
      TaskPriority.medium => cs.primary,
      TaskPriority.high => cs.error,
    };

    return GlassCard(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      elevation: 1,
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.done,
          onChanged: (_) => onToggleStatus(),
        ),
        title: Text(
          task.title,
          style: AppTypography.bodyLarge.copyWith(
            decoration: task.status == TaskStatus.done ? TextDecoration.lineThrough : null,
            color: task.status == TaskStatus.done ? cs.onSurfaceVariant : cs.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusChip(
                  label: task.priority.name.toUpperCase(),
                  isSelected: true,
                  backgroundColor: priorityColor.withOpacity( 0.12),
                  foregroundColor: priorityColor,
                  variant: ChipVariant.outlined,
                ),
                if (task.category != null && task.category!.isNotEmpty)
                  StatusChip(
                    label: task.category!,
                    isSelected: false,
                    variant: ChipVariant.elevated,
                  ),
                if (task.dueDate != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: cs.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${task.dueDate!.year}-${task.dueDate!.month.toString().padLeft(2, '0')}-${task.dueDate!.day.toString().padLeft(2, '0')}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_rounded), onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete_outline_rounded, color: cs.error), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
