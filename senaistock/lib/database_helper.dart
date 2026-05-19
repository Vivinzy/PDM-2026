import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  static const _dbName = 'almoxarifado.db';
  static const _dbVersion = 1;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  // IMPORTANTE: ativa FK (sem isso teu cascade não funciona)
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'almoxarife'
          CHECK(role IN ('almoxarife', 'coordenador')),
        unidade TEXT,
        remember_token TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE livros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        isbn TEXT NOT NULL UNIQUE,
        materia TEXT NOT NULL,
        saldo INTEGER NOT NULL DEFAULT 0,
        estoque_minimo INTEGER NOT NULL DEFAULT 10,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT,
        deleted_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE movimentacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        livro_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        tipo TEXT NOT NULL CHECK(tipo IN ('entrada', 'saida')),
        quantidade INTEGER NOT NULL,
        saldo_anterior INTEGER NOT NULL,
        saldo_atual INTEGER NOT NULL,
        turma TEXT,
        remessa TEXT,
        observacao TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT,
        FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}