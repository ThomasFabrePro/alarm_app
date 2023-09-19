// Fichier créé le 17.06.2021 par b.lacaille (LINKIA)
// Fonctions SQLite

import 'dart:io';
import 'dart:core';

import 'package:alarm_app/src/alarm_feature/alarm_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String _databaseName = 'AlarmApp.db';
  int _databaseVersion = 1;

  //singleton class
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _database;

  // TODO à modifier pour permettre une meilleure gestion lors des maj
  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  deleteDbLocal() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    if (await databaseExists(dbPath)) deleteDatabase(dbPath);
  }

  Future _onCreateDB(Database db, int version) async {
    //create tables
    await db.execute('''
      CREATE TABLE alarms(
      id INTEGER PRIMARY KEY,
      title TEXT,
      description TEXT,
      time TEXT
      )
      ''');
  }

  //create a function that insert a new AlarmItem in the table alarm
  Future<int> insertAlarm(AlarmItem alarm) async {
    Database db = await database;
    return await db.insert('alarms', alarm.toMap());
  }

  Future<List<AlarmItem>> fetchAlarms() async {
    Database db = await database;
    List<Map<String, dynamic>> alarms = await db.query('alarms');
    return alarms.isEmpty
        ? []
        : alarms.map((x) => AlarmItem.fromMap(x)).toList();
  }

  //create a function that update an AlarmItem in the table alarm
  Future<int> updateAlarm(AlarmItem alarm) async {
    Database db = await database;
    return await db.update('alarms', alarm.toMap(),
        where: 'id = ?', whereArgs: [alarm.id]);
  }

  //create a function that delete an AlarmItem in the table alarm
  Future<int> deleteAlarm(int id) async {
    Database db = await database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }
}
