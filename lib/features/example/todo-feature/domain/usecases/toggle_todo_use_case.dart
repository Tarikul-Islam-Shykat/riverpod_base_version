import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoUseCase {
  ToggleTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, TodoEntity>> call(String id) {
    return _repository.toggleTodo(id);
  }
}
