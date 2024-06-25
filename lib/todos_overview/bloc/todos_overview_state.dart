part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final class TodosOverviewState extends Equatable {
  const TodosOverviewState({this.todos = const <Todo>[], this.lastDeletedTodo, this.filter = TodosViewFilter.all, this.status = TodosOverviewStatus.initial});

  final List<Todo> todos;
  final Todo? lastDeletedTodo;
  final TodosViewFilter filter;
  final TodosOverviewStatus status;

  @override
  List<Object?> get props => [status, todos, filter, lastDeletedTodo];

  List<Todo> get filteredTodos => filter.applyAll(todos).toList();

  TodosOverviewState copyWith(
      {List<Todo> Function()? todos, Todo? Function()? lastDeletedTodo, TodosViewFilter Function()? filter, TodosOverviewStatus Function()? status}) {
    return TodosOverviewState(
        todos: todos != null ? todos() : this.todos,
        filter: filter != null ? filter() : this.filter,
        status: status != null ? status() : this.status,
        lastDeletedTodo: lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo);
  }
}
