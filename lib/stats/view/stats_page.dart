import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/stats/bloc/stats_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatsBloc>(
      child: const StatsView(),
      create: (_) => StatsBloc(todosRepository: context.read<TodosRepository>())..add(const StatsSubscriptionRequested()),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.statsAppBarTitle)),
      body: Column(children: <Widget>[
        ListTile(
          leading: const Icon(Icons.check_rounded),
          key: const Key('statsView_completedTodos_listTile'),
          title: Text(context.l10n.statsCompletedTodoCountLabel),
          trailing: Text('${context.watch<StatsBloc>().state.completedTodos}', style: Theme.of(context).textTheme.headlineSmall),
        ),
        ListTile(
          key: const Key('statsView_activeTodos_listTile'),
          title: Text(context.l10n.statsActiveTodoCountLabel),
          leading: const Icon(Icons.radio_button_unchecked_rounded),
          trailing: Text('${context.watch<StatsBloc>().state.activeTodos}', style: Theme.of(context).textTheme.headlineSmall),
        ),
      ]),
    );
  }
}
