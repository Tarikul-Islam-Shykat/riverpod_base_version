import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUseCase {
  DeleteTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, bool>> call(String id) {
    return _repository.deleteTodo(id);
  }
}
