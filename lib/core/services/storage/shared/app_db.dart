import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'app_db.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get fullName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;


  Future<int> saveUser(User user) => into(users).insertOnConflictUpdate(user);

  Future<User?> getUser() => select(users).getSingleOrNull();

  Stream<User?> watchUser() => select(users).watchSingleOrNull();

  Future<void> deleteUser() => delete(users).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

// Provider for the database
final appDbProvider = Provider((ref) => AppDatabase());
