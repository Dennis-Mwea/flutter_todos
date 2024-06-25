import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';
import 'package:flutter_todos/todos_overview/view/widgets/todo_list_tile.dart';
import 'package:flutter_todos/todos_overview/view/widgets/todos_overview_filter_button.dart';
import 'package:flutter_todos/todos_overview/view/widgets/todos_overview_options_button.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: const TodosOverviewView(),
      create: (BuildContext context) => TodosOverviewBloc(todosRepository: context.read<TodosRepository>())..add(const TodosOverviewSubscriptionRequested()),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todosOverviewAppBarTitle),
        actions: const <Widget>[TodosOverviewFilterButton(), TodosOverviewOptionsButton()],
      ),
      body: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (_, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(l10n.todosOverviewErrorSnackBarText)));
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) => previous.lastDeletedTodo != current.lastDeletedTodo && current.lastDeletedTodo != null,
            listener: (_, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(l10n.todosOverviewTodoDeletedSnackBarText(deletedTodo.title)),
                    action: SnackBarAction(
                      label: l10n.todosOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context.read<TodosOverviewBloc>().add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(builder: (_, state) {
          if (state.todos.isEmpty) {
            if (state.status == TodosOverviewStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == TodosOverviewStatus.success) {
              return const SizedBox();
            } else {
              return Center(child: Text(l10n.todosOverviewEmptyText, style: Theme.of(context).textTheme.bodySmall));
            }
          }

          return CupertinoScrollbar(
            child: ListView.builder(
              itemCount: state.filteredTodos.length,
              itemBuilder: (_, int index) {
                final todo = state.filteredTodos[index];

                return TodoListTile(
                  todo: todo,
                  onTap: () => Navigator.of(context).push(EditTodoPage.route(initialTodo: todo)),
                  onDismissed: (_) => context.read<TodosOverviewBloc>().add(TodosOverviewTodoDeleted(todo: todo)),
                  onToggleCompleted: (bool isCompleted) =>
                      context.read<TodosOverviewBloc>().add(TodosOverviewTodoCompletionToggled(todo: todo, isCompleted: isCompleted)),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
