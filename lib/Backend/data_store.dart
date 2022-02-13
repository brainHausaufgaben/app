

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';

part "data_store.g.dart";

class Todos extends Table {

  TextColumn get name => text()();
  TextColumn get color => text()();
}

@DataClassName("Category")
class Categories extends Table {

  IntColumn get id => integer().autoIncrement()();

}

LazyDatabase _openConnection() {

  return LazyDatabase(() async {

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'subjects.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Todos, Categories])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());
  Future<List<Todo>> get allTodoEntries => select(todos).get();
  Future<int> addTodo(TodosCompanion entry) {
    return into(todos).insert(entry);
  }

  @override
  int get schemaVersion => 1;
}


