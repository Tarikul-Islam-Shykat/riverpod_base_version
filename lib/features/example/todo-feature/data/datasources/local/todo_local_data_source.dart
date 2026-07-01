import '../../models/todo_model.dart';

class TodoLocalDataSource {
  TodoLocalDataSource() {
    _seedIfNeeded();
  }

  static final List<TodoModel> _todos = [];
  static const Duration _fakeLatency = Duration(milliseconds: 900);

  void _seedIfNeeded() {
    if (_todos.isNotEmpty) {
      return;
    }

    _todos.addAll([
      const TodoModel(id: '1', title: 'Learn Riverpod', isDone: false),
      const TodoModel(
        id: '2',
        title: 'Understand clean architecture',
        isDone: true,
      ),
      const TodoModel(
        id: '3',
        title: 'Build one small feature',
        isDone: false,
      ),
    ]);
  }

  Future<List<TodoModel>> getTodos() async {
    await Future.delayed(_fakeLatency);
    return List.unmodifiable(_todos);
  }

  Future<TodoModel> addTodo(String title) async {
    await Future.delayed(_fakeLatency);
    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
    );
    _todos.insert(0, todo);
    return todo;
  }

  Future<TodoModel> toggleTodo(String id) async {
    await Future.delayed(_fakeLatency);
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      throw StateError('Todo not found');
    }

    final updated = _todos[index].copyWith(isDone: !_todos[index].isDone);
    _todos[index] = updated;
    return updated;
  }

  Future<bool> deleteTodo(String id) async {
    await Future.delayed(_fakeLatency);
    final before = _todos.length;
    _todos.removeWhere((todo) => todo.id == id);
    return _todos.length != before;
  }
}
