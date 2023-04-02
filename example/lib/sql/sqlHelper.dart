import 'package:sqflite/sqflite.dart' as sql;
import 'package:logger/logger.dart';

class SqlHelper {
  static String DBName = "scanDatabase.db";

  //create Table
  static Future<void> createTable(sql.Database database) async {
    String command = """CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        scannedData TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""";
    await database.execute(command);
  }

  // create DB
  static Future<sql.Database> db() {
    return sql.openDatabase(
      DBName,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  // add single item
  static Future<int> createItem(String scannedData) async {
    final db = await SqlHelper.db();

    final data = {'scannedData': scannedData};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //get all database
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();
    try {
      return db.query(
        'items',
        orderBy: "id DESC",
      );
    } catch (e) {
      return [];
    }
  }

  static Future<bool> clearTable() async {
    final db = await SqlHelper.db();
    try {
      await db.execute('delete from items');
      return true;
    } catch (e) {
      await db.execute('TRUNCATE TABLE items');
      return false;
    }
  }
}
