import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:news/models/articles_model.dart';

import '../models/saved_item_model.dart';

class SavedItemsDatabase {
  static final SavedItemsDatabase instance = SavedItemsDatabase._init();

  static Database? _database;

  SavedItemsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('saved_items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';


    await db.execute('''
CREATE TABLE $tableItems ( 
  ${SavedItemFields.id} $idType, 
  ${SavedItemFields.author} $textType,
  ${SavedItemFields.description} $textType,
  ${SavedItemFields.urlToImage} $textType,
  ${SavedItemFields.content} $textType,
  ${SavedItemFields.title} $textType,
  ${SavedItemFields.url} $textType,
  ${SavedItemFields.publishedAt} $textType
  )
''');
  }

  Future<SavedItem> create(SavedItem savedItem) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableItems, savedItem.toJson());
    print(id);
    return savedItem.copy(id: id);
  }

  Future<SavedItem> readItem(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableItems,
      columns: SavedItemFields.values,
      where: '${SavedItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return SavedItem.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<SavedItem>> readAllItems() async {
    final db = await instance.database;

    final orderBy = '${SavedItemFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableItems, orderBy: orderBy);

    return result.map((json) => SavedItem.fromJson(json)).toList();
  }

  Future<int> update(SavedItem note) async {
    final db = await instance.database;

    return db.update(
      tableItems,
      note.toJson(),
      where: '${SavedItemFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableItems,
      where: '${SavedItemFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}