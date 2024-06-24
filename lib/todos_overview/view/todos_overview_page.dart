import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';
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
      appBar: AppBar(title: Text(l10n.todosOverviewAppBarTitle), actions: const <Widget>[
        // TodosOverviewFilterButton(),
        // TodosOverviewOptionsButton(),
      ]),
      body: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, next) => previous.status != next.status,
            listener: (_, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(l10n.todosOverviewErrorSnackBarText)));
              }
            },
          ),
        ],
        child: Container(),
      ),
    );
  }
}
