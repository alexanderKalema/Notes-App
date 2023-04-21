import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';

class DBService {
  Database? _db;

  Future<int> deleteAllNames() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(nameTable);
    return numberOfDeletions;
  }

  Future<DatabaseName> getNames({required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final notes = await db.query(
      nameTable,
      where: 'uid = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      return DatabaseName(firstName: "", lastName: "", uid: id);
    } else {
      final note = DatabaseName.fromRow(notes.first);
      // _name.removeWhere((note) => note.uid == id);
      // _name.add(note);
      // _nameStreamController.add(_name);
      return note;
    }
  }

  Future<DatabaseColor> getColor({required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final notes = await db.query(
      colTable,
      where: 'doc_id = ?',
      whereArgs: [id],
    );
    // print("mycolTab $notes");

    if (notes.isEmpty) {
      // print("empty color?");
      return DatabaseColor(colorType: "", colorNumber: -1, docid: id);
    } else {
      final note = DatabaseColor.fromRow(notes.first);
      // _name.removeWhere((note) => note.uid == id);
      // _name.add(note);
      // _nameStreamController.add(_name);
      return note;
    }
  }

  Future<DatabasePreference> getPreference({required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final pref = await db.query(
      preferenceTable,
      where: 'uid = ?',
      whereArgs: [id],
    );

    if (pref.isEmpty) {
      return DatabasePreference(language: "", theme: "", uid: "");
    } else {
      final note = DatabasePreference.fromRow(pref.first);
      return note;
    }
  }
  //
  //
  //
  //
  // Future<DatabaseName> createNote({required DatabaseName owner}) async {
  //   await _ensureDbIsOpen();
  //   final db = _getDatabaseOrThrow();
  //
  //   // make sure owner exists in the database with the correct id
  //   final dbUser = await getUser(email: owner.email);
  //   if (dbUser != owner) {
  //     throw CouldNotFindUser();
  //   }
  //
  //   const text = '';
  //   // create the note
  //   final noteId = await db.insert(noteTable, {
  //     userIdColumn: owner.id,
  //     textColumn: text,
  //     isSyncedWithCloudColumn: 1,
  //   });
  //
  //   final note = DatabaseName
  //     id: noteId,
  //     userId: owner.id,
  //     text: text,
  //     isSyncedWithCloud: true,
  //   );
  //
  //   _name.add(note);
  //   _nameStreamController.add(_name);
  //
  //   return note;
  // }
  //
  // Future<DatabaseName> getUser({required String firstName ,required String lastName, required String uid }) async {
  //   await _ensureDbIsOpen();
  //   final db = _getDatabaseOrThrow();
  //
  //   final results = await db.query(
  //     nameTable,
  //     limit: 1,
  //     where: 'email = ?',
  //     whereArgs: [email.toLowerCase()],
  //   );
  //
  //   if (results.isEmpty) {
  //     throw CouldNotFindUser();
  //   } else {
  //     return DatabaseName.fromRow(results.first);
  //   }
  // }

  Future<DatabaseName> createUser(
      {required String firstName,
      required String lastName,
      required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(nameTable, {
      fnameCoulmn: firstName.toLowerCase(),
      lnameCoulmn: lastName.toLowerCase(),
      idColumn: id
    });

    // print("I am insertijng this ${col}");
    final mydb = DatabaseName(
      firstName: firstName,
      lastName: lastName,
      uid: id,
    );
    _db = db;
    return mydb;
  }

  Future<DatabaseColor> createColor(
      {required String colType,
      required int colNum,
      required String id}) async {
    print("how bout here1");
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    print("how bout here");
    final existing = await getColor(id: id);
    print("how bout here2");
    if (existing.colorNumber == -1) {
      await db.insert(colTable, {
        ctypeCoulmn: colType,
        cnumCoulmn: colNum,
        docidColumn: id,
      });
    }

    final mydb = DatabaseColor(
      colorType: colType,
      colorNumber: colNum,
      docid: id,
    );
    _db = db;
    return mydb;
  }

  Future<void> deleteColor({required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final existing = await getColor(id: id);

    if (existing.colorNumber != -1) {
      await db.delete(
        colTable,
        where: 'doc_id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> updateColor(
      {required String colType,
      required int colNum,
      required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.update(
      colTable,
      {
        ctypeCoulmn: colType,
        cnumCoulmn: colNum,
        docidColumn: id,
      },
      where: 'doc_id = ?',
      whereArgs: [id],
    );
  }

  Future<DatabasePreference> createPreference(
      {required String theme,
      required String uid,
      required String language}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(preferenceTable, {
      langCoulmn: language,
      themeColumn: theme,
      pidColumn: uid,
    });

    final mydb = DatabasePreference(
      language: language,
      theme: theme,
      uid: uid,
    );
    _db = db;
    return mydb;
  }

  Future<DatabasePreference> updatePreference(
      {required String theme,
      required String uid,
      required String language}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.update(
      preferenceTable,
      {
        langCoulmn: language,
        themeColumn: theme,
        pidColumn: uid,
      },
      where: 'uid = ?',
      whereArgs: [uid],
    );

    final mydb = DatabasePreference(
      language: language,
      theme: theme,
      uid: uid,
    );
    _db = db;
    return mydb;
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    //try {
    await open();
    //}
    // on DatabaseAlreadyOpenException {
    //   // empty
    // }
  }

  Future<void> open() async {
    if (_db != null) {
      // throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);

      // create the user table
      await db.execute(createNameTable);
      await db.execute(createColorTable);
      _db = db;
    } on MissingPlatformDirectoryException {
      //  throw UnableToGetDocumentsDirectory();
    }
  }
}

class DatabaseName {
  String firstName;
  String lastName;
  String uid;

  DatabaseName({
    required this.firstName,
    required this.lastName,
    required this.uid,
  });

  DatabaseName.fromRow(Map<String, Object?> map)
      : firstName = map[fnameCoulmn] as String,
        lastName = map[lnameCoulmn] as String,
        uid = map[idColumn] as String;

  @override
  String toString() => 'Note, firstName = $firstName, lastName = $lastName';

  @override
  bool operator ==(covariant DatabaseName other) =>
      firstName == other.firstName;

  @override
  int get hashCode => 4;
}

class DatabaseColor {
  String colorType;
  int colorNumber;
  String docid;

  DatabaseColor({
    required this.colorType,
    required this.colorNumber,
    required this.docid,
  });

  DatabaseColor.fromRow(Map<String, Object?> map)
      : colorType = map[ctypeCoulmn] as String,
        colorNumber = map[cnumCoulmn] as int,
        docid = map[docidColumn] as String;

  @override
  String toString() =>
      'Note, colorType = $colorType, colorNumber = $colorNumber';

  @override
  bool operator ==(covariant DatabaseColor other) =>
      colorType == other.colorType;

  @override
  int get hashCode => 4;
}

class DatabasePreference {
  String language;
  String uid;
  String theme;

  DatabasePreference({
    required this.uid,
    required this.language,
    required this.theme,
  });

  DatabasePreference.fromRow(Map<String, Object?> map)
      : language = map[langCoulmn] as String,
        uid = map[pidColumn] as String,
        theme = map[themeColumn] as String;

  @override
  String toString() => 'Preference, theme = $theme, language = $language';

  @override
  bool operator ==(covariant DatabasePreference other) => uid == other.uid;

  @override
  int get hashCode => 4;
}

const fnameCoulmn = 'first_name';
const lnameCoulmn = 'last_name';
const dbName = 'newnames.db';
const idColumn = 'uid';
const nameTable = 'nameInfo';

const ctypeCoulmn = 'col_type';
const cnumCoulmn = 'col_number';
const docidColumn = 'doc_id';
const colTable = 'colorInfo';

const pidColumn = 'uid';
const langCoulmn = 'Language';
const themeColumn = 'Theme';
const preferenceTable = 'Preference';

const createNameTable = '''CREATE TABLE IF NOT EXISTS "nameInfo" (
          "uid"	TEXT NOT NULL ,
        "first_name"	TEXT,
        "last_name"	TEXT ,
        "identify"	INTEGER NOT NULL,
         PRIMARY KEY("identify" AUTOINCREMENT)
      );''';

const createColorTable = '''CREATE TABLE IF NOT EXISTS "colorInfo" (
          "doc_id"	TEXT NOT NULL ,
        "col_type"	TEXT,
        "col_number"	INTEGER ,
        "colidentify"	INTEGER NOT NULL,
         PRIMARY KEY("colidentify" AUTOINCREMENT)
      );''';
const createPreferenceTable = '''CREATE TABLE IF NOT EXISTS "Preference" (
        "uid"	TEXT NOT NULL ,
        "Language"	TEXT,
        "Theme" TEXT ,
         PRIMARY KEY("uid")
      );''';
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "text"	TEXT,
//         "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
