part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

final class StatsState extends Equatable {
  const StatsState({this.activeTodos = 0, this.completedTodos = 0, this.status = StatsStatus.initial});

  final int activeTodos;
  final int completedTodos;
  final StatsStatus status;

  @override
  List<Object> get props => [status, completedTodos, activeTodos];

  StatsState copyWith({int? activeTodos, int? completedTodos, StatsStatus? status}) =>
      StatsState(status: status ?? this.status, activeTodos: activeTodos ?? this.activeTodos, completedTodos: completedTodos ?? this.completedTodos);
}
