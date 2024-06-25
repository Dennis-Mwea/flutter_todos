import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';
import 'package:flutter_todos/home/cubit/home_cubit.dart';
import 'package:flutter_todos/stats/stats.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(create: (_) => HomeCubit(), child: const HomeView());
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(index: selectedTab.index, children: const <Widget>[TodosOverviewPage(), StatsPage()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
        key: const Key('homeView_addTodo_floatingActionButton'),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.list_rounded),
            onPressed: () => context.read<HomeCubit>().setTab(HomeTab.todos),
            color: selectedTab == HomeTab.todos ? Theme.of(context).colorScheme.secondary : null,
          ),
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.show_chart_rounded),
            onPressed: () => context.read<HomeCubit>().setTab(HomeTab.stats),
            color: selectedTab == HomeTab.stats ? Theme.of(context).colorScheme.secondary : null,
          ),
        ]),
      ),
    );
  }
}
