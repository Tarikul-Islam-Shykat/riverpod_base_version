import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodos();
  Future<Either<Failure, TodoEntity>> addTodo(String title);
  Future<Either<Failure, TodoEntity>> toggleTodo(String id);
  Future<Either<Failure, bool>> deleteTodo(String id);
}
