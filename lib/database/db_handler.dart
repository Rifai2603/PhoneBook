import 'package:flutter/material.dart';
import 'package:phone_book/userType/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHandler {
  DbHandler._privateConstructor();
  static final DbHandler instance = DbHandler._privateConstructor();

  static const _databaseName = "Contacts.db";
  static const _databaseVersion = 1;

  static const table = 'Contacts';

  static const colId = 'id';
  static const colPhoto = 'photo';
  static const colName = 'name';
  static const colMobile = 'mobile';
  static const colEmail = 'email';
  static const colIsFav = 'isfav';

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  //open database if create
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  //create database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $colId VARCHAR PRIMARY KEY,
        $colPhoto VARCHAR,
        $colName VARCHAR,
        $colMobile VARCHAR(10),
        $colEmail VARCHAR,
        $colIsFav INTEGER(1)
      );
    ''');
    debugPrint('database created');
  }

  //handler methods

  //add contact
  Future<void> insert(Contact contact) async {
    try {
      Database db = await instance.database;
      await db.insert(table, contact.toMap());
    } on Exception catch (e) {
      debugPrint('error in database insertion : ${e.toString()}');
    }
  }

  //delete contact
  Future<void> delete(String id) async {
    try {
      Database db = await instance.database;
      await db.delete(
        table,
        where: '$colId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('error in deleting contact : ${e.toString()}');
    }
  }

  //update contact
  Future<void> update(Contact contact) async {
    try {
      Database db = await instance.database;
      await db.update(
        table,
        contact.toMap(),
        where: '$colId = ?',
        whereArgs: [contact.id],
      );
    } catch (e) {
      debugPrint('error in updating : ${e.toString()}');
    }
  }

  //search contact
  Future<Contact> search(String id) async {
    Database db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$colId = ?',
      whereArgs: [id],
    );

    return Contact.fromMap(maps.first);
  }

  //check for duplicate
  Future<bool> checkForDuplicate(String name) async {
    Database db = await instance.database;

    final List<Map<String, dynamic>> duplicate = await db.query(table, where: '$colName = ?', whereArgs: [name]);

    return duplicate.isEmpty;
  }

  //get all contacts
  Future<List<Contact>> getAllContacts() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.query(table, orderBy: '$colName ASC');

    return List.generate(
      maps.length,
      (index) => Contact.fromMap(maps[index]),
    );
  }

  //get favorite cantacts
  Future<List<Contact>> getFavContacts() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$colIsFav = ?',
      whereArgs: [1],
      orderBy: '$colName ASC',
    );

    return List.generate(
      maps.length,
      (index) => Contact.fromMap(maps[index]),
    );
  }
}
