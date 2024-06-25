import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_api/todos_api.dart';

/// {@template local_storage_todos_api}
/// A flutter implementation of the TodosApi that uses local storage.
/// {@endtemplate}
class LocalStorageTodosApi extends TodosApi {
  /// {@macro local_storage_todos_api}
  LocalStorageTodosApi({required SharedPreferences plugin}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  late final _todosStreamControl = BehaviorSubject<List<Todo>>.seeded(const <Todo>[]);

  /// The key used for storing the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kTodosCollectionKey = '__todos_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) => _plugin.setString(key, value);

  void _init() {
    final todosJson = _getValue(kTodosCollectionKey);
    if (todosJson != null) {
      final todos = List<Map<String, dynamic>>.from(json.decode(todosJson) as List<dynamic>).map(Todo.fromJson).toList();
      _todosStreamControl.add(todos);
    } else {
      _todosStreamControl.add(<Todo>[]);
    }
  }

  @override
  Future<int> clearCompleted() async {
    final todos = [..._todosStreamControl.value];
    final completedTodosAmount = todos.where((t) => t.isCompleted).length;
    todos.removeWhere((t) => t.isCompleted);
    _todosStreamControl.add(todos);

    await _setValue(kTodosCollectionKey, json.encode(todos));

    return completedTodosAmount;
  }

  @override
  Future<void> close() {
    return _todosStreamControl.close();
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final todos = [..._todosStreamControl.value];
    final changedTodosAmount = todos.where((t) => t.isCompleted != isCompleted).length;
    final newTodos = [for (final todo in todos) todo.copyWith(isCompleted: isCompleted)];
    _todosStreamControl.add(newTodos);
    await _setValue(kTodosCollectionKey, json.encode(newTodos));

    return changedTodosAmount;
  }

  @override
  Future<void> deleteTodo(String id) {
    final todos = [..._todosStreamControl.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todosStreamControl.add(todos);

      return _setValue(kTodosCollectionKey, json.encode(todos));
    }
  }

  @override
  Stream<List<Todo>> getTodos() => _todosStreamControl.asBroadcastStream();

  @override
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todosStreamControl.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex != -1) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }

    _todosStreamControl.add(todos);
    return _setValue(kTodosCollectionKey, json.encode(todos));
  }
}
