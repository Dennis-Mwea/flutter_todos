import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/models/todos_view_filter.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter = context.select((TodosOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      initialValue: activeFilter,
      icon: const Icon(Icons.filter_list_rounded),
      tooltip: context.l10n.todosOverviewFilterTooltip,
      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      onSelected: (filter) => context.read<TodosOverviewBloc>().add(TodosOverviewFilterChanged(filter)),
      itemBuilder: (context) => [
        PopupMenuItem(value: TodosViewFilter.all, child: Text(context.l10n.todosOverviewFilterAll)),
        PopupMenuItem(value: TodosViewFilter.activeOnly, child: Text(context.l10n.todosOverviewFilterActiveOnly)),
        PopupMenuItem(value: TodosViewFilter.completedOnly, child: Text(context.l10n.todosOverviewFilterCompletedOnly)),
      ],
    );
  }
}
