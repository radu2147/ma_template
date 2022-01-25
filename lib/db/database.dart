import 'dart:async';

import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/repository/activity_repository.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BuddyDatabase implements Repository{
  BuddyDatabase._init();

  static final db = BuddyDatabase._init();
  static Database? _database;

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDb('activity.db');
    return _database!;
  }

  Future<Database> _initDb(String s) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, s);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db2, int version) async{
    await db2.execute('''
      CREATE TABLE $dbName(
      ${SportsActivityFields.id} ${SportsActivityFields.idType},
      ${SportsActivityFields.location} ${SportsActivityFields.locationType},
      ${SportsActivityFields.date} ${SportsActivityFields.dateType},
      ${SportsActivityFields.closed} ${SportsActivityFields.closedType},
      ${SportsActivityFields.type} ${SportsActivityFields.typeType}
      )
    ''');
    await db2.execute('''
      CREATE TABLE sync(
        ${SportsActivityFields.id} ${SportsActivityFields.idType}
      )
    ''');
  }
  
  Future<SportsActivity> add(SportsActivity activity) async{
    var dtb = await db.database;
    var map  = activity.mapToJson();
    var id = await dtb.insert(dbName, map);
    activity.id = BigInt.from(id);
    return activity;
  }

  Future<void> addSync(BigInt id) async{
    var dtb = await db.database;
    await dtb.insert(dbName, {SportsActivityFields.id: id.toInt()});
  }



  Future<List<SportsActivity>> readAll() async{
    var dtb = await db.database;
    var rez = await dtb.query(dbName);
    var ret = rez.map((e) => SportsActivity.fromJson(e)).toList();
    return ret;
  }

  @override
  Future<void> delete(BigInt id) async {
    var dtb = await db.database;
    dtb.delete(dbName, where: '${SportsActivityFields.id} = $id');
  }

  @override
  Future<SportsActivity> update(SportsActivity sportsActivity) async {
    var dtb = await db.database;
    var whr = sportsActivity.mapToJson(add: false);
    await dtb.update(dbName, whr, where: '${SportsActivityFields.id} = ${sportsActivity.id.toInt()}');
    return sportsActivity;
  }

  @override
  Future<SportsActivity> readById(BigInt int) async {
    // TODO: implement readById
    var dtb = await db.database;
    var rez = await dtb.query(dbName, where: '${SportsActivityFields.id} = $int');
    var ret = rez.map((e) => SportsActivity.fromJson(e)).toList()[0];
    return ret;
  }

  @override
  late List<SportsActivity> listState;

  @override
  SportsActivityViewModel observer = SportsActivityViewModel();

}