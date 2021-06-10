final String tableNotes = 'notes';//Name of table

class NoteFields {//Column names in our table later on
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];
  //How we wanna name our fields
  static final String id = '_id';//In SQL by default u put an _ in front of id
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {//All the fields we wanna store in our db later
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({//This is a function with named arguments
    int? id,//Our main aim is to copy this id which we had gotten returned
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(//Convert our json to note
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant] == 1,//We convert integer 1 and 0 to boolean type
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),//json to string to dateTime
      );

  Map<String, Object?> toJson() => {//We are converting our data to a json format.It will be in a String which we get from Notefield.something to the variables
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.isImportant: isImportant ? 1 : 0,//Our sql database understands 1 and 0 only
        NoteFields.number: number,
        NoteFields.description: description,
        NoteFields.time: createdTime.toIso8601String(),
      };
}
