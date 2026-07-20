import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/core/utils/responsive.dart';
import 'package:lifeos_ai/features/tasks/domain/task.dart';
import 'package:lifeos_ai/features/tasks/providers/task_providers.dart';
import 'package:lifeos_ai/shared/widgets/app_text_field.dart';

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
      appBar: AppBar(
        title: const Text('Tasks'),
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
                child: Semantics(
                  label: 'Error loading tasks',
                  child: Text('Error: $e'),
                ),
              ),
              data: (tasks) {
                final filtered = _filterTasks(tasks);
                if (filtered.isEmpty) {
                  return _EmptyTasks(
                      cs: cs, onCreate: () => _showTaskForm(context));
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
                        final task = filtered[i];
                        return _TaskTile(
                          task: task,
                          onToggleStatus: () => _updateStatus(
                              context, task, _nextStatus(task.status)),
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
    );
  }

  TaskStatus _nextStatus(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.done;
      case TaskStatus.done:
        return TaskStatus.todo;
    }
  }

  List<Task> _filterTasks(List<Task> tasks) {
    final query = _searchCtrl.text.trim().toLowerCase();
    return tasks.where((t) {
      if (_filterPriority != TaskPriority.medium &&
          t.priority != _filterPriority) return false;
      if (_filterStatus != TaskStatus.todo && t.status != _filterStatus) {
        return false;
      }
      if (_filterCategory != null &&
          _filterCategory!.isNotEmpty &&
          t.category != _filterCategory) return false;
      if (query.isNotEmpty &&
          !t.title.toLowerCase().contains(query) &&
          !(t.description ?? '').toLowerCase().contains(query)) return false;
      return true;
    }).toList();
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Task' : 'New Task'),
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
                  controller: descCtrl,
                  label: 'Description',
                  maxLines: 3,
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
                    Expanded(
                      child: DropdownButtonFormField<TaskPriority>(
                        value: priority,
                        decoration:
                            const InputDecoration(labelText: 'Priority'),
                        items: [
                          const DropdownMenuItem(
                            value: TaskPriority.medium,
                            child: Text('Medium'),
                          ),
                          ...TaskPriority.values.map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            ),
                          ),
                        ],
                        onChanged: (v) => priority = v ?? priority,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: dueCtrl,
                        label: 'Due date (YYYY-MM-DD)',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<TaskStatus>(
                        value: status,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: [
                          const DropdownMenuItem(
                            value: TaskStatus.todo,
                            child: Text('Todo'),
                          ),
                          ...TaskStatus.values.map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.name.toUpperCase()),
                            ),
                          ),
                        ],
                        onChanged: (v) => status = v ?? status,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              final navigator = Navigator.of(context);
              final due = dueCtrl.text.trim().isEmpty
                  ? null
                  : DateTime.tryParse(dueCtrl.text.trim());
              final repo = ref.read(taskRepositoryProvider);
              final now = DateTime.now();
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
              if (mounted) navigator.pop();
            },
            child: Text(isEdit ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _updateStatus(
      BuildContext context, Task task, TaskStatus newStatus) async {
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(taskRepositoryProvider).updateTask(
        task.copyWith(status: newStatus, updatedAt: DateTime.now()));
    if (mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text('Task updated to ${newStatus.name}')),
      );
    }
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await ref.read(taskRepositoryProvider).deleteTask(task.id);
              if (mounted) navigator.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks({required this.cs, required this.onCreate});
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
                    label: 'No tasks yet icon',
                    child: Icon(Icons.check_circle_outline_rounded,
                        size: 56, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: 'No tasks yet',
                    child: Text('No tasks yet',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: 'Create your first task button',
                    child: TextButton.icon(
                      onPressed: onCreate,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create your first task'),
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
      decoration: const InputDecoration(
        labelText: 'Priority',
        isDense: true,
      ),
      items: [
        const DropdownMenuItem(
          value: TaskPriority.medium,
          child: Text('Any'),
        ),
        ...TaskPriority.values
            .where((p) => p != TaskPriority.medium)
            .map(
              (p) => DropdownMenuItem(
                value: p,
                child: Text(p.name.toUpperCase()),
              ),
            ),
      ],
      onChanged: (v) => onPriorityChanged(v ?? TaskPriority.medium),
    );

    final statusDropdown = DropdownButtonFormField<TaskStatus>(
      value: filterStatus,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Status',
        isDense: true,
      ),
      items: [
        const DropdownMenuItem(
          value: TaskStatus.todo,
          child: Text('Any'),
        ),
        ...TaskStatus.values
            .where((s) => s != TaskStatus.todo)
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: Text(s.name.toUpperCase()),
              ),
            ),
      ],
      onChanged: (v) => onStatusChanged(v ?? TaskStatus.todo),
    );

    final categoryDropdown = DropdownButtonFormField<String?>(
      value: filterCategory,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Category',
        isDense: true,
      ),
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
          padding: EdgeInsets.fromLTRB(context.horizontalPagePadding, 12,
              context.horizontalPagePadding, 8),
          child: Column(
            children: [
              TextField(
                controller: searchCtrl,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 10),
              // On phones the three dropdowns don't fit side-by-side, so they
              // stack; on wider screens they sit in a single row.
              if (context.isCompact) ...[
                Row(
                  children: [
                    Expanded(child: priorityDropdown),
                    const SizedBox(width: 10),
                    Expanded(child: statusDropdown),
                  ],
                ),
                const SizedBox(height: 10),
                categoryDropdown,
              ] else
                Row(
                  children: [
                    Expanded(child: priorityDropdown),
                    const SizedBox(width: 10),
                    Expanded(child: statusDropdown),
                    const SizedBox(width: 10),
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.done,
          onChanged: (_) => onToggleStatus(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.done
                ? TextDecoration.lineThrough
                : null,
            color: task.status == TaskStatus.done ? cs.onSurfaceVariant : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: priorityColor,
                    ),
                  ),
                ),
                if (task.category != null && task.category!.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.category!,
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
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
                        style:
                            TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
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
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: cs.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
