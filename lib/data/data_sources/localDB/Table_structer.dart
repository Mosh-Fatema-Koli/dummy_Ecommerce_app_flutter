

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
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL,
      price REAL NOT NULL,
      thumbnail TEXT NOT NULL
    )
  ''');
  }



  createOfflineLeaveQueueTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS LeaveOfflineQueue (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      LeaveTypes TEXT,
      StartDate TEXT,
      EndDate TEXT,
      Reason TEXT,
      ImagePath TEXT
    )
  ''');
  }


}