import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../data/datasources/local/todo_local_data_source.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/add_todo_use_case.dart';
import '../../domain/usecases/delete_todo_use_case.dart';
import '../../domain/usecases/get_todos_use_case.dart';
import '../../domain/usecases/toggle_todo_use_case.dart';

final todoLocalDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  return TodoLocalDataSource();
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final localDataSource = ref.read(todoLocalDataSourceProvider);
  return TodoRepositoryImpl(localDataSource);
});

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return GetTodosUseCase(repository);
});

final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return AddTodoUseCase(repository);
});

final toggleTodoUseCaseProvider = Provider<ToggleTodoUseCase>((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return ToggleTodoUseCase(repository);
});

final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  final repository = ref.read(todoRepositoryProvider);
  return DeleteTodoUseCase(repository);
});

class TodoController extends AsyncNotifier<List<TodoEntity>> {
  @override
  Future<List<TodoEntity>> build() async {
    return _loadTodos();
  }

  Future<List<TodoEntity>> _loadTodos() async {
    final result = await ref.read(getTodosUseCaseProvider)();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (todos) => todos,
    );
  }

  Future<void> addTodo(String title) async {
    await _runMutation(() => ref.read(addTodoUseCaseProvider)(title));
  }

  Future<void> toggleTodo(String id) async {
    await _runMutation(() => ref.read(toggleTodoUseCaseProvider)(id));
  }

  Future<void> deleteTodo(String id) async {
    await _runMutation(() => ref.read(deleteTodoUseCaseProvider)(id));
  }

  Future<void> _runMutation<T>(
    Future<Either<Failure, T>> Function() operation,
  ) async {
    final result = await operation();
    var success = false;

    result.fold(
      (failure) {
        state = AsyncError(Exception(failure.message), StackTrace.current);
      },
      (_) {
        success = true;
      },
    );

    if (success) {
      state = AsyncData(await _loadTodos());
    }
  }
}

final todoControllerProvider =
    AsyncNotifierProvider<TodoController, List<TodoEntity>>(TodoController.new);
