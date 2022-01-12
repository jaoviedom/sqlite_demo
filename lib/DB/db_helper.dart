import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_demo/Models/grocery.dart';

class DBHelper {
  final int _version = 1;
  final String _tableName = "groceries";
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "groceries.db");
    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name STRING
      )
    ''');
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query(_tableName, orderBy: "name");
    List<Grocery> groceryList = groceries.isNotEmpty ?
        groceries.map((c) => Grocery.fromMap(c)).toList() :
        [];
    return groceryList;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return db.insert(_tableName, grocery.toMap());
  }
}