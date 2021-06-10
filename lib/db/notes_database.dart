import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_database_example/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();//Initialized the calss with this constructore

  static Database? _database;//Ensures one instance of database ie ever created

  NotesDatabase._init();//We created a private constructor.It will run when we create a new Database instance

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');//If database doesen't exist we have to initialize it so we call the function which we created
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {//Take a file path
    final dbPath = await getDatabasesPath();//The path in which our file is gonna be stored
    //If you want it to get stored at a different directory you have to use path_provider package
    final path = join(dbPath, filePath);//We join the mobile path and our path which we want

    return await openDatabase(path, version: 1, onCreate: _createDB);//We open the databse using the joined path
  }

  Future _createDB(Database db, int version) async {//Executed inly if notes.db is not in your file system else it's executed
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';//Type of id ie column which we put in create Table
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
/*Executed the sql statement CreateTable(id INTEGER,isIMPORTANT BOOLEAN and so on)*/
/*Note field is a class which we had created containing names of columns*/
/*You can add one more Create Table statement after this if you want*/
 //Don't put comments inside sql statements
    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType)
''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');//we use raw inswert if we want to execute our own sql  statements

    final id = await db.insert(tableNotes, note.toJson());//We get a unique id returned which we wanna execute
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,//table name
      columns: NoteFields.values,//columns which u wanna retrieve
      where: '${NoteFields.id} = ?',//We wanna have the id accessed .The value is given by ? .It prevents sql injection attacks.
      whereArgs: [id],//We pass the value of the id here to prevent sql injection attacks
      //where: '${NoteFields.id} = ? ?'//where args passes the value of the ?
      //whereArgs: [id,name]
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);//We convert our json list to notes and we use .first to access the first item only
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {//Here we return all the notes
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC';//We wanna order by ascending order
    // final result =//Doing the same thing
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],//whereargs is providing the value for the ? in where
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {//We are closing the db
    final db = await instance.database;

    db.close();
  }
}
