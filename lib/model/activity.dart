import 'package:flutter/material.dart';

const String dbName = 'actvitiy';

class SportsActivityFields{
  static const String id = '_id';
  static const String idServer = 'id';
  static const String idType = 'INTEGER PRIMARY KEY';
  static const String location = 'location';
  static const String locationType = 'VARCHAR(100) NOT NULL';
  static const String date = 'date';
  static const String dateType = 'TEXT NOT NULL';
  static const String closed = 'closed';
  static const String closedType = 'BOOLEAN NOT NULL';
  static const String type = 'type';
  static const String typeType = 'TEXT NOT NULL';
}

class SportsActivity{
  BigInt id;
  String location;
  DateTime date;
  bool closed;
  SportsType type;

  SportsActivity({
    required this.id,
    required this.location,
    required this.date,
    required this.closed,
    required this.type,
  });

  String get dateShort{
    return date.toString().split(" ")[0];
  }

  static Color mapTypeToColor(SportsType type){
    late Color col;
    switch(type){
      case SportsType.TABLE_TENNIS:
        col = Colors.red;
        break;
      case SportsType.TENNIS:
        col = Colors.green;
        break;
      default:
        col = Colors.blue;
    }
    return col;
  }

  static String mapTypeToText(SportsType type){
    late String col;
    switch(type){
      case SportsType.TABLE_TENNIS:
        col = "TABLE_TENNIS";
        break;
      case SportsType.TENNIS:
        col = "TENNIS";
        break;
      default:
        col = "JOGGING";
    }
    return col;
  }

  static SportsType mapTextToType(String type){
    switch(type){
      case "TABLE_TENNIS":
        return SportsType.TABLE_TENNIS;
      case "TENNIS":
        return SportsType.TENNIS;
      default:
        return SportsType.JOGGING;
    }
  }

  Map<String, Object?> mapToJson({bool add = true}) => {
      SportsActivityFields.id: add ? null : id.toInt(),
      SportsActivityFields.location: location,
      SportsActivityFields.type: mapTypeToText(type),
      SportsActivityFields.closed: closed,
      SportsActivityFields.date: date.toString().split(" ")[0],
    };

  Map<String, Object?> mapToJsonServer({bool add = true}) => {
    SportsActivityFields.idServer: add ? null : id.toInt(),
    SportsActivityFields.location: location,
    SportsActivityFields.type: mapTypeToText(type),
    SportsActivityFields.closed: closed,
    SportsActivityFields.date: date.toString().split(" ")[0],
  };


  static SportsActivity fromJson(Map<String, Object?> map) =>
      SportsActivity(
        id: BigInt.from(map[SportsActivityFields.id] as int),
        location: map[SportsActivityFields.location] as String,
        closed: map[SportsActivityFields.closed] == 1,
        date: DateTime.parse(map[SportsActivityFields.date] as String),
        type: mapTextToType(map[SportsActivityFields.type] as String)
      );

  static SportsActivity fromJsonServer(Map<String, Object?> map) =>
      SportsActivity(
          id: BigInt.from(map[SportsActivityFields.idServer] as int),
          location: map[SportsActivityFields.location] as String,
          closed: map[SportsActivityFields.closed] == 1,
          date: DateTime.parse(map[SportsActivityFields.date] as String),
          type: mapTextToType(map[SportsActivityFields.type] as String)
      );
}

enum SportsType{
  TABLE_TENNIS, TENNIS, JOGGING
}
