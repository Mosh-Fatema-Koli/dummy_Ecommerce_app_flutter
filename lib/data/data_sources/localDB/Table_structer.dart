

import 'package:sqflite/sqflite.dart';

class TableStructure {

  Future<void> createUserInfoTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS UserInfo (
      Id TEXT,
      Email TEXT,
      UserId INTEGER,
      IsActive INTEGER,
      FullName TEXT,
      PhoneNumber TEXT,
      Username TEXT,
      Token TEXT,
      Designation TEXT,
      StaffID TEXT,
      Organization TEXT,
      Password TEXT
    )
  ''');
  }

  Future<void> createCartTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Cart (
      id INTEGER,
      title TEXT ,
      price REAL ,
      thumbnail TEXT ,
      quantity INTEGER 
    )
  ''');
  }

}