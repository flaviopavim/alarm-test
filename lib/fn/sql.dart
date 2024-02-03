import 'dart:core';
import 'package:sqflite/sqflite.dart';

create(db) async {
  /* Cria o banco de dados */
  await db.execute(
      'CREATE TABLE calendar ('
          'id INTEGER PRIMARY KEY, '
          'frequency_period TEXT, '
          'frequency_value INT, '
          'duration_period TEXT, '
          'duration_value INT '
          ')');
}

//conexão e criação do banco de dados local (offline)
connection() async {
  var databasesPath = await getDatabasesPath();
  String path = '${databasesPath}database.db';
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        create(db);
      });

  return database;
}

select(sql) async {
  //print('SQL ${sql}');
  Database database=await connection();
  var ret=await database.rawQuery(sql);
  //await database.close();
  return ret;
}

fetch(sql) async {
  var fetch_=await select(sql);
  return fetch_[0];
}

insert(sql) async {
  //print(sql);
  Database database=await connection();
  await database.rawInsert(sql);
}

update(sql) async {
  print("UPDATE: $sql");
  Database database=await connection();
  await database.rawUpdate(sql);
}

delete(sql) async {
  print(sql);
  Database database=await connection();
  await database.rawDelete(sql);
}