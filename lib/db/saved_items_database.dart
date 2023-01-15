import 'dart:async';
import 'dart:convert';

import 'package:news/models/save_item_model.dart';
import 'package:news/models/item_model.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:news/models/articles_model.dart';
import 'package:http/http.dart' as http;

import '../constants/newsApi_constants.dart';


class SavedItemsDatabase {
  static final SavedItemsDatabase instance = SavedItemsDatabase._init();

  static Database? _database;

  SavedItemsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favourite_items.db');
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
    final statusType = "TEXT NOT NULL DEFAULT 'not_downloaded'";
    final textNullType = 'TEXT NULL';


    await db.execute('''
            CREATE TABLE $tableSavedItems ( 
            ${SavedItemFields.id} $idType,
            ${SavedItemFields.cid} $textType,
            ${SavedItemFields.title} $textType,
            ${SavedItemFields.description} $textType,
            ${SavedItemFields.type} $textType,
            ${SavedItemFields.genres} $textType,
            ${SavedItemFields.age} $textType,
            ${SavedItemFields.coverPhoto} $textType,
            ${SavedItemFields.basePhoto} $textType,
            ${SavedItemFields.bannerPhoto} $textType,
            ${SavedItemFields.duration} $textType,
            ${SavedItemFields.quality} $textType,
            ${SavedItemFields.status} $textType,
            ${SavedItemFields.views} $textType,
            ${SavedItemFields.rating} $textType,
            ${SavedItemFields.comments} $textType,
            ${SavedItemFields.releasedYear} $textType,
            ${SavedItemFields.dateAdded} $textType,
            ${SavedItemFields.link} $textType,
            ${SavedItemFields.trailer} $textType,
            ${SavedItemFields.offlineStatus} $statusType,
            ${SavedItemFields.offlinePath} $textNullType

  )
''');
  }








  Future<SavedItemModel> create(ItemModel ItemGot) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableSavedItems, ItemGot.toJson());
    print(id);
    final savedItem = await readItem(id);
    final savedItem2 = await savedItem.copyWith(id: id);

    final imgUrl = savedItem2.coverPhoto;
    http.Response response = await http.get(Uri.parse(ThidasaApiConstants.imageCardBaseURL+imgUrl!));
    final bytes = response?.bodyBytes;
    final new_cover_photo;
    if(bytes != null){
      new_cover_photo =  base64Encode(bytes);
    }
    else{
      new_cover_photo = imgUrl;
    }
    final coverphotoUpdatedSavedItem = savedItem.copyWith(coverPhoto: new_cover_photo);
    final isUpdated = await instance.update(coverphotoUpdatedSavedItem);
    if (isUpdated != null) {
      return coverphotoUpdatedSavedItem;
    }
    return coverphotoUpdatedSavedItem;

  }

  Future<SavedItemModel> readItem(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSavedItems,
      columns: SavedItemFields.values,
      where: '${SavedItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return SavedItemModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<SavedItemModel>> readAllItems() async {
    final db = await instance.database;

    final orderBy = '${SavedItemFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableSavedItems, orderBy: orderBy);

    return result.map((json) => SavedItemModel.fromJson(json)).toList();
  }

  Future<int> update(SavedItemModel item) async {
    final db = await instance.database;

    return db.update(
      tableSavedItems,
      item.toJson(),
      where: '${SavedItemFields.id} = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableSavedItems,
      where: '${SavedItemFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}