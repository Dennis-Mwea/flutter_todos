import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodosOverviewBloc bloc) => bloc.state.todos);
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return PopupMenuButton<TodosOverviewOption>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: context.l10n.todosOverviewOptionsTooltip,
      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      onSelected: (options) {
        switch (options) {
          case TodosOverviewOption.toggleAll:
            context.read<TodosOverviewBloc>().add(const TodosOverviewToggleAllRequested());
          case TodosOverviewOption.clearCompleted:
            context.read<TodosOverviewBloc>().add(const TodosOverviewClearCompletedRequested());
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: todos.isNotEmpty,
          value: TodosOverviewOption.toggleAll,
          child: Text(
            completedTodosAmount == todos.length ? context.l10n.todosOverviewOptionsMarkAllIncomplete : context.l10n.todosOverviewOptionsMarkAllComplete,
          ),
        ),
        PopupMenuItem(
          value: TodosOverviewOption.clearCompleted,
          enabled: todos.isNotEmpty && completedTodosAmount > 0,
          child: Text(context.l10n.todosOverviewOptionsClearCompleted),
        ),
      ],
    );
  }
}
