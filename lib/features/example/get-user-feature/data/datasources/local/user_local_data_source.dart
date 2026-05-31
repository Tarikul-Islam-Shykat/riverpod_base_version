import '../../../../../../core/services/local_storage_service/shared/app_db.dart';
import '../../../domain/entities/local_user_entity.dart';

class UserLocalDataSource {
  UserLocalDataSource(this._database);

  final AppDatabase _database;

  Future<void> saveUser(LocalUserEntity user) async {
    await _database.deleteUser();
    await _database.saveUser(user.toDriftUser());
  }

  Future<LocalUserEntity?> getSavedUser() async {
    final user = await _database.getUser();
    return user?.toEntity();
  }

  Future<void> updateSavedUser(LocalUserEntity user) async {
    await _database.deleteUser();
    await _database.saveUser(user.toDriftUser());
  }

  Future<void> deleteSavedUser() async {
    await _database.deleteUser();
  }
}

extension on LocalUserEntity {
  User toDriftUser() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
    );
  }
}

extension on User {
  LocalUserEntity toEntity() {
    return LocalUserEntity(
      id: id,
      email: email,
      fullName: fullName,
    );
  }
}
