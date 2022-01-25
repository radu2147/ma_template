import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:http/http.dart';

import '../../activity.dart';
import 'package:http/http.dart' as http;

class Apis {
  static const String api = '/';
  static const String url = 'http://10.152.2.119:8080/api';
}

abstract class ApiClient {

  Future<SportsActivity> update(SportsActivity sportsActivity);

  Future<List<SportsActivity>> readAll();

  Future<void> delete(BigInt id);

  Future<SportsActivity> add(SportsActivity el);
}

class ApiClientImpl implements ApiClient{

  @override
  Future<SportsActivity> add(SportsActivity el) async {
    late Response response;
    try {
      var elem = el.mapToJson(add: true);
      response = await http.post(
          Uri.parse(Apis.url), body: jsonEncode(elem), headers: {'Content-type': 'application/json'}).timeout(const Duration(seconds: 5));
    }
    on TimeoutException catch(_){
      throw Exception("Cannot add element");
    }
    catch(e){
      print(e);
    }
    if(response.statusCode != 200){
      throw Exception("Something is wrong");
    }
    return SportsActivity.fromJsonServer(jsonDecode(response.body));
  }

  @override
  Future<void> delete(BigInt id) async  {
    var resp = await http.delete(Uri.parse("${Apis.url}/${id.toInt()}"));
    if(resp.statusCode != 200){
      throw Exception("Something is wrong");
    }
  }

  @override
  Future<List<SportsActivity>> readAll() async {
    try {
      var response = await http.get(Uri.parse(Apis.url)).timeout(
          const Duration(seconds: 5));
      List<dynamic> values = jsonDecode(response.body);
      List<SportsActivity> fin = [];
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            var elem = SportsActivity.fromJsonServer(map);
            fin.add(elem);
          }
        }
      }
      return fin;
    }on TimeoutException catch(e){
      throw Exception("Error fetching data from server");
    }
  }

  @override
  Future<SportsActivity> update(SportsActivity el) async {
    var body = el.mapToJsonServer(add: false);
    var resp = await http.put(Uri.parse(Apis.url), body: jsonEncode(body), headers: {'Content-type': 'application/json'});
    if(resp.statusCode != 200){
      throw Exception("Something is wrong");
    }
    return el;
  }

}