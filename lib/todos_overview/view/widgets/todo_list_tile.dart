import 'package:flutter/material.dart';
import 'package:todos_api/todos_api.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({required this.todo, this.onTap, this.onToggleCompleted, this.onDismissed, super.key});

  final Todo todo;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: onDismissed,
      direction: DismissDirection.startToEnd,
      key: Key('todoListTile_dismissible_${todo.id}'),
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Color(0xAAFFFFFF)),
      ),
      child: ListTile(
        onTap: onTap,
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        subtitle: Text(todo.description, maxLines: 1, overflow: TextOverflow.ellipsis),
        title: Text(
          todo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: !todo.isCompleted ? null : TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, decoration: TextDecoration.lineThrough),
        ),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: onToggleCompleted == null ? null : (value) => onToggleCompleted!(value!),
          shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
    );
  }
}
