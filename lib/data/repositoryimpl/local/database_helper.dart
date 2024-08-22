import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;
  static const _databaseVersion = 1; // Incremented version

  //Calling from main page
  static Future<void> initialize() async {
    _database = await _initDatabase();
  }

  //Opening database & calling function to create tables
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Alarm.db');
    _database = await openDatabase(path,
        version: _databaseVersion,
        onCreate: (Database db, int newVersion) async {
          await _createTables(db, newVersion);
        },

    );
    return _database;
  }

  //For getting database
  Future<Database> getDatabase() async {
    if (_database == null) {
      await initialize();
    }
    return _database;
  }

  static Future<void> _createTables(Database db, int version) async {
    try {
      await db.transaction((txn) async {
        //alarmtable
        await txn.execute('''
             CREATE TABLE alarmtable 	
              (
              id 		        INTEGER 			NOT NULL	              CHECK (typeof(id) = 'integer'),
              label 	      VARCHAR(150)	NOT NULL           	    CHECK (length(label) <= 150),
              alarmtime 	  TIMESTAMP WITHOUT TIME ZONE	NOT NULL,           
            
              CONSTRAINT pk_mobtablelist_id PRIMARY KEY(id)
              );
        ''');
      });
    } catch (error) {
      throw Exception('Error enabling foreign key constraints: $error');
    }
  }
}