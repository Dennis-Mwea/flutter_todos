part of 'edit_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusExtension on EditTodoStatus {
  bool get isLoadingOrSuccess => <EditTodoStatus>[EditTodoStatus.loading, EditTodoStatus.success].contains(this);
}

final class EditTodoState extends Equatable {
  const EditTodoState({this.title = '', this.description = '', this.status = EditTodoStatus.initial, this.initialTodo});

  final String title;
  final Todo? initialTodo;
  final String description;
  final EditTodoStatus status;

  @override
  List<Object?> get props => <Object?>[title, initialTodo, description, status];

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({String? title, Todo? initialTodo, String? description, EditTodoStatus? status}) {
    return EditTodoState(
        title: title ?? this.title, status: status ?? this.status, initialTodo: initialTodo ?? this.initialTodo, description: description ?? this.description);
  }
}
