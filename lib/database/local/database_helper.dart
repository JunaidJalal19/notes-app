import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/note_colors.dart';

class DatabaseHelper {

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String Table_Name = "notes";
  static const String Title_Col = "title";
  static const String Description_Col = "desc";
  static const String Date_Col = "created_at";
  static const String Bg_Color_Col = "bgColor";
  static const String Note_Id_Col = "id";

  Database? _database;

  Future<Database> _getDb() async {
    _database ??= await openDb();
    return _database!;
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "notes_database.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute("""
      create table $Table_Name (
      $Note_Id_Col integer primary key autoincrement, 
      $Title_Col text, $Description_Col text, 
      $Bg_Color_Col integer,
      $Date_Col text default current_timestamp
      )
      """);
    });
  }

  /// fetch notes
  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final Database db = await _getDb();
    return await db.query(Table_Name);

  }


  // fetch single note
  Future<Map<String, Object?>?> fetchSingleNote({required int id}) async{
    final Database db = await _getDb();
    var result = await db.query(Table_Name, where: "$Note_Id_Col = ?", whereArgs: [id]);

    if(result.isNotEmpty) {
      return result.first;
    }

    return null;
  }


  // add notes
  Future<bool> addNote({String? title, String? desc}) async {
    final Database  db = await _getDb();
    
    int effectedRow = await db.insert(Table_Name, {
      Title_Col: title ?? "",
      Description_Col: desc ?? "",
      Bg_Color_Col: Random().nextInt(backgroundColors.length)
    });

    return effectedRow > 0;
  }


  // updates
  Future<bool> updateNote({required int id, required String title, required String desc}) async {
    final Database db = await _getDb();

    int effectedRow = await db.update(Table_Name, {
      Title_Col: title,
      Description_Col: desc,
      Date_Col: DateTime.now().toIso8601String()
    }, where: "$Note_Id_Col = ?", whereArgs: [id] );

    return effectedRow > 0;


  }



}