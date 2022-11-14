import 'dart:async';

import 'package:flutter/foundation.dart';
// import 'package:mynotes/extensions/list/filter.dart';
// import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';

class NotesService {

  Database? _db;

  // List<DatabaseName> _name = [];
  // DatabaseName? _user;

  // static final NotesService _shared = NotesService._sharedInstance();
  // NotesService._sharedInstance() {
  //   _nameStreamController = StreamController<List<DatabaseName>>.broadcast(
  //     onListen: () {
  //       _nameStreamController.sink.add(_name);
  //     },
  //   );
  // }
  // factory NotesService() => _shared;
  //
  // late final StreamController<List<DatabaseName>> _nameStreamController;

  // Stream<List<DatabaseName>> get allNotes =>
  //     _nameStreamController.stream.filter((note) {
  //       final currentUser = _user;
  //       if (currentUser != null) {
  //         return note.userId == currentUser.id;
  //       } else {
  //         throw UserShouldBeSetBeforeReadingAllNotes();
  //       }
  //     });

  // Future<DatabaseName> getOrCreateUser({
  //   required String email,
  //   bool setAsCurrentUser = true,
  // }) async {
  //   try {
  //     final user = await getUser(email: email);
  //     if (setAsCurrentUser) {
  //       _user = user;
  //     }
  //     return user;
  //   } on CouldNotFindUser {
  //     final createdUser = await createUser(email: email);
  //     if (setAsCurrentUser) {
  //       _user = createdUser;
  //     }
  //     return createdUser;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<void> _cacheNotes() async {
  //   final allNotes = await getAllNotes();
  //   _name = allNotes.toList();
  //   _nameStreamController.add(_name);
  // }
  //
  //
  // Future<Iterable<DatabaseName>> getAllNotes() async {
  //   await _ensureDbIsOpen();
  //   final db = _getDatabaseOrThrow();
  //   final notes = await db.query(noteTable);
  //
  //   print(notes);
  //
  //   return notes.map((noteRow) => DatabaseName.fromRow(noteRow));
  // }
  //
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
      return DatabaseName( firstName: "", lastName: "",uid: id
      );
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
    print("mycolTab $notes");

    if (notes.isEmpty) {
     // print("empty color?");
      return DatabaseColor( colorType: "", colorNumber: 1 , docid: id);

    } else {
      final note = DatabaseColor.fromRow(notes.first);
      // _name.removeWhere((note) => note.uid == id);
      // _name.add(note);
      // _nameStreamController.add(_name);
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

  Future<DatabaseName> createUser({required String firstName,required String lastName,required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
   await db.insert(
        nameTable,
        {
      fnameCoulmn: firstName.toLowerCase(),
          lnameCoulmn: lastName.toLowerCase(),
          idColumn:id
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

  Future<DatabaseColor> createColor ({required String colType,required int colNum, required String id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(
        colTable,
        {
        ctypeCoulmn : colType,
         cnumCoulmn : colNum,
          docidColumn:id,

        });
     // var view  = await  db.query(
     //     colTable,
     //     );

    //print("I am insertijng this ${view}");
    final mydb = DatabaseColor(
      colorType : colType,
      colorNumber : colNum,
      docid:id,
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
        uid = map[idColumn] as String
  ;

  @override
  String toString() =>
      'Note, firstName = $firstName, lastName = $lastName';

  @override
  bool operator ==(covariant DatabaseName other) => firstName == other.firstName;

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
        docid = map[docidColumn] as String
  ;

  @override
  String toString() =>
      'Note, colorType = $colorType, colorNumber = $colorNumber';

  @override
  bool operator ==(covariant DatabaseColor other) => colorType == other.colorType;

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
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "text"	TEXT,
//         "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
