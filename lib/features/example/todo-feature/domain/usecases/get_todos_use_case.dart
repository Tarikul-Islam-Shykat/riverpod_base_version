import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodosUseCase {
  GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, List<TodoEntity>>> call() {
    return _repository.getTodos();
  }
}
