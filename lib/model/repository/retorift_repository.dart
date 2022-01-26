import 'dart:async';
import 'dart:convert';

import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/repository/activity_repository.dart';
import 'package:buddy_finder/model/repository/api/api.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BuddyDatabaseAndServerRepo implements Repository{

  ApiClient restClient = ApiClientImpl();

  bool _hasInternetConnection = true;

  late SportsActivityViewModel observer;

  late WebSocketChannel channel;

  @override
  late List<SportsActivity> listState = [];

  BuddyDatabaseAndServerRepo._internal(){
    initConnectivity();
    /*offlineSupport(() async{
      var dtb = await db.database;
      offlineDelete(dtb);
    });*/

    offlineSupport(() async{
      var dtb = await db.database;
      offlineAdd(dtb);
    });

    offlineSupport(() async{
      var dtb = await db.database;
      offlineUpdate(dtb);
    });
  }


  static final db = BuddyDatabaseAndServerRepo._internal();
  static Database? _database;

  initWebsocket(){
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.152.2.119:2025/'),
    );
    channel.stream.listen((message) {
      var map = jsonDecode(message);
      var activity = SportsActivity.fromJson(map, SportsActivityFields.idServer);
      observer.update(activity.nume);
    });
  }

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDb('activity.db');
    return _database!;
  }

  Future<Database> _initDb(String s) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, s);

    return await openDatabase(path, version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // you can execute drop table and create table
      await db.execute('''
      CREATE TABLE sync(
        ${SportsActivityFields.id} ${SportsActivityFields.idType}
      )
      ''');
    }
  }

  FutureOr<void> _onCreate(Database db2, int version) async{
    await db2.execute('''
      CREATE TABLE $dbName(
      ${SportsActivityFields.id} ${SportsActivityFields.idType},
      ${SportsActivityFields.nume} ${SportsActivityFields.numeType},
      ${SportsActivityFields.quantity} ${SportsActivityFields.quantityType},
      ${SportsActivityFields.discount} ${SportsActivityFields.discountType},
      ${SportsActivityFields.pret} ${SportsActivityFields.pretType},
      ${SportsActivityFields.status} ${SportsActivityFields.statusType},
      ${SportsActivityFields.tip} ${SportsActivityFields.tipType}
      )
    ''');

    await db2.execute('''
      CREATE TABLE sync(
        ${SportsActivityFields.id} ${SportsActivityFields.idType}
      )
      ''');

    await db2.execute('''
      CREATE TABLE syncDelete(
        ${SportsActivityFields.id} ${SportsActivityFields.idType}
      )
      ''');

    await db2.execute('''
      CREATE TABLE syncUpdate(
        ${SportsActivityFields.id} ${SportsActivityFields.idType}
      )
      ''');
  }

  Future<SportsActivity> add(SportsActivity activity) async{
    var dtb = await db.database;
    var map  = activity.mapToJson(SportsActivityFields.id);
    if(_hasInternetConnection){
      try {
        activity =
        await restClient.add(activity).timeout(const Duration(seconds: 5));
        map[SportsActivityFields.id] = activity.id.toInt();
        await dtb.insert(dbName, map);

        listState.add(activity);
      }
      on TimeoutException catch(_){
        throw Exception("Cannot add element");
      }
    }
    else{
      var id = await dtb.insert(dbName, map);
      activity.id = BigInt.from(id);
      listState.add(activity);
      addSync(id, "sync");
    }
    return activity;
  }

  Future<void> addSync(int id, String tableName) async{
    var dtb = await db.database;
    await dtb.insert(tableName, {SportsActivityFields.id: id});
  }

  Future<List<SportsActivity>> readAllPlain() async{
    if(_hasInternetConnection){
      try {
        return await restClient.readAll().timeout(const Duration(seconds: 5));
      }
      catch(e){
        throw Exception("Cannot get the data");
      }
    }
    throw Exception("Cannot get the data");
  }

  Future<List<SportsActivity>> readAll({saveLocally: true}) async{
    if(_hasInternetConnection){
      try {
        var elems = await restClient.readAll().timeout(const Duration(seconds: 5));
        if(saveLocally) {
          var dtb = await db.database;
          dtb.delete(dbName);
          elems.forEach((element) async {
            try {
              var body = element.mapToJson(SportsActivityFields.id, add: false);
              await dtb.insert(dbName, body);
            }
            catch (e) {

            }
          });
        }
        return elems;
      }
      catch(e){
        throw Exception("Cannot get the data");
      }
    }
    throw Exception("Cannot get the data");
  }

  @override
  Future<void> delete(BigInt id) async {
    var dtb = await db.database;
    if(_hasInternetConnection){
      await restClient.delete(id);

      dtb.delete(dbName, where: '${SportsActivityFields.id} = $id');

      listState.removeWhere((element) => element.id == id);
    }
    else{
      throw Exception("No internet connection");
      await dtb.delete(dbName, where: '${SportsActivityFields.id} = $id');
      listState.removeWhere((element) => element.id == id);
      addSync(id.toInt(), "syncDelete");
    }
  }

  offlineSupport(Function callback){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
          await callback();
          observer.notifyListeners();
        }
    });
  }

  offlineAdd(Database dtb) async{
    var lista = await readSyncTable("sync");
    for(var element in lista) {
      var act = await readById(BigInt.from(element));
      late SportsActivity activity;
      while (true) {
        try {
          activity = await restClient.add(act).timeout(
              const Duration(seconds: 5));
          break;
        }
        on TimeoutException catch (_) {}
      }
      await dtb.delete(
          dbName, where: '${SportsActivityFields.id} = ${BigInt.from(element)}');
      var body = activity.mapToJson(SportsActivityFields.id, add: false);
      await dtb.insert(dbName, body);
      listState.removeWhere((el) => el.id.toInt() == element);
      listState.add(activity);
    }
  }

  offlineDelete(Database dtb) async{
    var lista = await readSyncTable("syncDelete");
    for(var element in lista) {
      while (true) {
        try {
          await restClient.delete(BigInt.from(element)).timeout(
              const Duration(seconds: 5));
          break;
        }
        on TimeoutException catch (_) {}
      }
    }
  }

  offlineUpdate(Database dtb) async{
    var lista = await readSyncTable("syncUpdate");
    for(var element in lista) {
      var act = await readById(BigInt.from(element));
      while (true) {
        try {
          await restClient.update(act).timeout(
              const Duration(seconds: 5));
          break;
        }
        on TimeoutException catch (_) {}
      }
    }
  }

  @override
  Future<SportsActivity> update(SportsActivity sportsActivity) async {
    var dtb = await db.database;
    if(_hasInternetConnection){
      await restClient.update(sportsActivity);
      var whr = sportsActivity.mapToJson(SportsActivityFields.id, add: false);
      await dtb.update(dbName, whr, where: '${SportsActivityFields.id} = ${sportsActivity.id.toInt()}');

      for (int i = 0; i < listState.length; i ++) {
        if(listState[i].id == sportsActivity.id){
          listState[i].tip = sportsActivity.tip;
          listState[i].discount = sportsActivity.discount;
          listState[i].pret = sportsActivity.pret;
          listState[i].cantitate = sportsActivity.cantitate;
          listState[i].status = sportsActivity.status;
          listState[i].nume = sportsActivity.nume;
        }
      }
    }
    else{
      await dtb.update(dbName, sportsActivity.mapToJson(SportsActivityFields.id, add: false), where: '${SportsActivityFields.id} = ${sportsActivity.id}');
      addSync(sportsActivity.id.toInt(), "syncUpdate");
      for (int i = 0; i < listState.length; i ++) {
        if(listState[i].id == sportsActivity.id){
          listState[i].tip = sportsActivity.tip;
          listState[i].discount = sportsActivity.discount;
          listState[i].pret = sportsActivity.pret;
          listState[i].cantitate = sportsActivity.cantitate;
          listState[i].status = sportsActivity.status;
          listState[i].nume = sportsActivity.nume;
        }
      }
    }
    return sportsActivity;
  }

  void initConnectivity() async {
    var res = await Connectivity().checkConnectivity();
    _hasInternetConnection = res == ConnectivityResult.wifi || res == ConnectivityResult.mobile;

    Connectivity().onConnectivityChanged.listen((event) {
      _hasInternetConnection = event == ConnectivityResult.wifi || event == ConnectivityResult.mobile;
      if(_hasInternetConnection){
        initWebsocket();
      }
      else{
        channel.sink.close();
      }
    });
  }

  @override
  Future<SportsActivity> readById(BigInt int) async{
    var dtb = await db.database;
    var rez = await dtb.query(dbName, where: '${SportsActivityFields.id} = $int');
    var ret = rez.map((e) => SportsActivity.fromJson(e, SportsActivityFields.id)).toList()[0];
    return ret;
  }

  Future<List<int>> readSyncTable(String tableName) async{
    var dtb = await db.database;
    var rez = await dtb.query(tableName);
    await dtb.delete(tableName);
    var ret = rez.map((e) => e[SportsActivityFields.id] as int).toList();
    return ret;
  }

  @override
  void dispose() {
    channel.sink.close();
  }

}