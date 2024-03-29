import 'dart:async' show StreamController;
import 'package:flutter/material.dart';
import 'package:learningdart/services/crud/exceptions.dart';
import 'package:sqflite/sqflite.dart' show openDatabase, Database;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'dart:developer' show log;

class NoteService {
  Database? _db;
  DatabaseUser? _user;

  List<DatabaseNote> _notes = [];

  late final StreamController<List<DatabaseNote>> _noteStreamController;

  Stream<List<DatabaseNote>> get allNotes => _noteStreamController.stream;

  static final NoteService _shared = NoteService._sharedInstance();

  NoteService._sharedInstance() {
    _noteStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _noteStreamController.sink.add(_notes);
      },
    );
  }

  factory NoteService() => _shared;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      _user = user;
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      _user = createdUser;
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final user = _user;
    if (user == null) throw UserShouldBeSetBeforeReadingAllNotes();
    final notes = await getAllnotes(user: user);
    _notes = notes.toList();
    _noteStreamController.add(_notes);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatbaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatbaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatbaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTableQuery);

      await db.execute(createNoteTableQuery);

      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatbaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) throw UserAlreadyExists();
    final userId = await db.insert(
      userTable,
      {
        emailColumn: email,
      },
    );
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) throw CouldNotFindUser();
    return DatabaseUser.fromRow(results.first);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUser();
    const text = '';
    final updatedAt = DateTime.now();

    final noteId = await db.insert(noteTable, {
      userIdColumn: dbUser.id,
      textColumn: text,
      updatedAtColumn: updatedAt.toString(),
    });
    final note = DatabaseNote(
        id: noteId, userId: owner.id, text: text, updatedAt: updatedAt);
    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) throw CouldNotDeleteNote();
    _notes.removeWhere((note) => note.id == id);
    _noteStreamController.add(_notes);
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final noOfDeletions = await db.delete(noteTable);
    _notes = [];
    _noteStreamController.add(_notes);
    return noOfDeletions;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) throw CouldNotFindNote();
    final note = DatabaseNote.fromRow(notes.first);
    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  Future<Iterable<DatabaseNote>> getAllnotes({
    required DatabaseUser user,
  }) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      where: 'user_id = ?',
      whereArgs: [user.id],
    );

    final userNotes =
        notes.map((noteRow) => DatabaseNote.fromRow(noteRow)).toList();

    return userNotes;
  }

  Future<DatabaseNote> updateNote({
    required int id,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id: id);
    final updatedCount = await db.update(
      noteTable,
      {
        textColumn: text,
        updatedAtColumn: DateTime.now().toString(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    if (updatedCount == 0) throw CouldNotUpdateNote();
    return await getNote(id: id);
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, Id=$id, email=$email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final DateTime updatedAt;
  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.updatedAt,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        updatedAt = DateTime.parse('${map[updatedAtColumn]}');

  @override
  String toString() => 'Note, Id=$id, userId=$userId';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const updatedAtColumn = "updated_at";
const createUserTableQuery = '''CREATE TABLE IF NOT EXISTS "user" (
	        "id"	INTEGER NOT NULL,
	        "email"	TEXT NOT NULL UNIQUE,
	        PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';
const createNoteTableQuery = '''CREATE TABLE  IF NOT EXISTS  "note" (
          "id"	INTEGER NOT NULL,
          "user_id"	INTEGER NOT NULL,
          "text"	TEXT,
          "updated_at" TEXT,
          FOREIGN KEY("user_id") REFERENCES "user"("id"),
          PRIMARY KEY("id")
          );
      ''';
