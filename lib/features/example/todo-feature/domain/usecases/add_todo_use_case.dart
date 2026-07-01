import 'package:fpdart/fpdart.dart';

import '../../../../../core/services/network/error/failure.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class AddTodoUseCase {
  AddTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, TodoEntity>> call(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return Left(ValidationFailure('Todo title cannot be empty'));
    }

    return _repository.addTodo(trimmedTitle);
  }
}
