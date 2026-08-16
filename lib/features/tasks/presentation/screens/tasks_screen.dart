import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos_ai/core/constants/app_constants.dart';
import 'package:lifeos_ai/core/theme/design_system.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/tasks/domain/task.dart';
import 'package:lifeos_ai/features/tasks/providers/task_providers.dart';
import 'package:lifeos_ai/shared/widgets/animated_text_field.dart';
import 'package:lifeos_ai/shared/widgets/app_dialog.dart';
import 'package:lifeos_ai/shared/widgets/responsive_scaffold.dart';
import 'package:lifeos_ai/shared/widgets/status_chip.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final _destinations = <({IconData icon, String label, String route})>[
    (icon: Icons.dashboard_outlined, label: 'Home', route: AppRoutes.dashboard),
    (icon: Icons.check_circle_outline_rounded, label: 'Tasks', route: AppRoutes.tasks),
    (icon: Icons.event_outlined, label: 'Calendar', route: AppRoutes.calendar),
    (icon: Icons.note_outlined, label: 'Notes', route: AppRoutes.notes),
    (icon: Icons.smart_toy_outlined, label: 'AI Chat', route: AppRoutes.chat),
    (icon: Icons.settings_outlined, label: 'Settings', route: AppRoutes.settings),
  ];

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
    return ResponsiveShell(
      title: 'Tasks',
      currentIndex: 1,
      onDestinationSelected: (index) {
        final route = _destinations[index].route;
        context.push(route);
      },
      destinations: _destinations,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add task',
          onPressed: () => _showTaskForm(context),
        ),
      ],
      body: _TasksBody(
        filterPriority: _filterPriority,
        filterStatus: _filterStatus,
        filterCategory: _filterCategory,
        searchCtrl: _searchCtrl,
        onPriorityChanged: (p) => setState(() => _filterPriority = p),
        onStatusChanged: (s) => setState(() => _filterStatus = s),
        onCategoryChanged: (c) => setState(() => _filterCategory = c),
        onShowTaskForm: _showTaskForm,
        onUpdateStatus: _updateStatus,
        onConfirmDelete: _confirmDelete,
      ),
    );
  }

  TaskStatus _nextStatusLocal(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.done;
      case TaskStatus.done:
        return TaskStatus.todo;
    }
  }

  void _showTaskForm(BuildContext context, {Task? task}) {
    final isEdit = task != null;
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    final catCtrl = TextEditingController(text: task?.category ?? '');
    final dueCtrl = TextEditingController(
      text: task?.dueDate != null
          ? '${task!.dueDate!.year}-${task.dueDate!.month.toString().padLeft(2, '0')}-${task.dueDate!.day.toString().padLeft(2, '0')}'
          : '',
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
            final due = dueCtrl.text.trim().isEmpty
                ? null
                : DateTime.tryParse(dueCtrl.text.trim());
            final taskModel = Task(
              id: task?.id ??
                  '${now.millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch}',
              createdAt: task?.createdAt ?? now,
              updatedAt: now,
              title: title,
              description:
                  descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
              priority: priority,
              status: status,
              category:
                  catCtrl.text.trim().isEmpty ? null : catCtrl.text.trim(),
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
    await ref.read(taskRepositoryProvider).updateTask(
        task.copyWith(status: newStatus, updatedAt: DateTime.now()));
    if (mounted) {
      messenger.showSnackBar(
          SnackBar(content: Text('Task updated to ${newStatus.name}')));
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

class _TasksBody extends ConsumerWidget {
  const _TasksBody({
    required this.filterPriority,
    required this.filterStatus,
    required this.filterCategory,
    required this.searchCtrl,
    required this.onPriorityChanged,
    required this.onStatusChanged,
    required this.onCategoryChanged,
    required this.onShowTaskForm,
    required this.onUpdateStatus,
    required this.onConfirmDelete,
  });

  final TaskPriority filterPriority;
  final TaskStatus filterStatus;
  final String? filterCategory;
  final TextEditingController searchCtrl;
  final ValueChanged<TaskPriority> onPriorityChanged;
  final ValueChanged<TaskStatus> onStatusChanged;
  final ValueChanged<String?> onCategoryChanged;
  final void Function(BuildContext, {Task? task}) onShowTaskForm;
  final void Function(BuildContext, Task, TaskStatus) onUpdateStatus;
  final void Function(BuildContext, Task) onConfirmDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tasksAsync = ref.watch(tasksProvider);
    final categories = ref.watch(taskCategoriesProvider);

    return Column(
      children: [
        _Filters(
          cs: cs,
          categories: categories,
          filterPriority: filterPriority,
          filterStatus: filterStatus,
          filterCategory: filterCategory,
          searchCtrl: searchCtrl,
          onPriorityChanged: onPriorityChanged,
          onStatusChanged: onStatusChanged,
          onCategoryChanged: onCategoryChanged,
          onSearchChanged: (_) {},
        ),
        Expanded(
          child: tasksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Unable to load tasks. Please try again.',
                  style: AppTypography.bodyMedium),
            ),
            data: (tasks) {
              final filtered = _filterTasks(tasks);
              if (filtered.isEmpty) {
                return _EmptyTasks(
                    cs: cs, onCreate: () => onShowTaskForm(context));
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
                      final task = filtered[i];
                      return _TaskTile(
                        task: task,
                        onToggleStatus: () => onUpdateStatus(
                            context, task, _nextStatusLocal(task.status)),
                        onEdit: () => onShowTaskForm(context, task: task),
                        onDelete: () => onConfirmDelete(context, task),
                      );
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

  List<Task> _filterTasks(List<Task> tasks) {
    final query = searchCtrl.text.trim().toLowerCase();
    return tasks.where((t) {
      if (filterPriority != TaskPriority.medium &&
          t.priority != filterPriority) {
        return false;
      }
      if (filterStatus != TaskStatus.todo && t.status != filterStatus) {
        return false;
      }
      if (filterCategory != null &&
          filterCategory!.isNotEmpty &&
          t.category != filterCategory) {
        return false;
      }
      if (query.isNotEmpty &&
          !t.title.toLowerCase().contains(query) &&
          !(t.description ?? '').toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();
  }

  TaskStatus _nextStatusLocal(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.done;
      case TaskStatus.done:
        return TaskStatus.todo;
    }
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
            const Text('No tasks yet', style: AppTypography.titleMedium),
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
        ...TaskPriority.values.where((p) => p != TaskPriority.medium).map((p) =>
            DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))),
      ],
      onChanged: (v) => onPriorityChanged(v ?? TaskPriority.medium),
    );

    final statusDropdown = DropdownButtonFormField<TaskStatus>(
      value: filterStatus,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Status', isDense: true),
      items: [
        const DropdownMenuItem(value: TaskStatus.todo, child: Text('Any')),
        ...TaskStatus.values.where((s) => s != TaskStatus.todo).map((s) =>
            DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))),
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
        constraints:
            const BoxConstraints(maxWidth: Breakpoints.maxWideContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.horizontalPagePadding,
              AppSpacing.md, context.horizontalPagePadding, AppSpacing.sm),
          child: Column(
            children: [
                AnimatedTextField(
                  controller: searchCtrl,
                  label: 'Search',
                  hint: 'Search tasks...',
                  prefixIcon: Icons.search_rounded,
                  onChanged: onSearchChanged,
                ),
              const SizedBox(height: AppSpacing.sm),
              if (context.isCompact)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: priorityDropdown),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: statusDropdown),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    categoryDropdown,
                  ],
                )
              else
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

    return Card(
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
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.done,
          onChanged: (_) => onToggleStatus(),
        ),
        title: Text(
          task.title,
          style: AppTypography.bodyLarge.copyWith(
            decoration: task.status == TaskStatus.done
                ? TextDecoration.lineThrough
                : null,
            color: task.status == TaskStatus.done
                ? cs.onSurfaceVariant
                : cs.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusChip(
                  label: task.priority.name.toUpperCase(),
                  isSelected: true,
                  backgroundColor: priorityColor.withOpacity(0.12),
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
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: cs.onSurfaceVariant),
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
            IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
