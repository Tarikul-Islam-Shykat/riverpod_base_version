import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._localDataSource);

  final TodoLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos() async {
    try {
      final todos = await _localDataSource.getTodos();
      return Right(
        todos
            .map(
              (model) => TodoEntity(
                id: model.id,
                title: model.title,
                isDone: model.isDone,
              ),
            )
            .toList(growable: false),
      );
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> addTodo(String title) async {
    try {
      final todo = await _localDataSource.addTodo(title);
      return Right(
        TodoEntity(
          id: todo.id,
          title: todo.title,
          isDone: todo.isDone,
        ),
      );
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> toggleTodo(String id) async {
    try {
      final todo = await _localDataSource.toggleTodo(id);
      return Right(
        TodoEntity(
          id: todo.id,
          title: todo.title,
          isDone: todo.isDone,
        ),
      );
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTodo(String id) async {
    try {
      final deleted = await _localDataSource.deleteTodo(id);
      return Right(deleted);
    } catch (error) {
      return Left(UnknownFailure(error.toString()));
    }
  }
}
