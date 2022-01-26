import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:http/http.dart';

import '../../activity.dart';
import 'package:http/http.dart' as http;

class Apis {
  static const String api = '/';
  static const String url = 'http://10.152.2.119:2025';
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
    var elem = el.mapToJson(SportsActivityFields.idServer, add: true);
    response = await http.post(Uri.parse("${Apis.url}/product"), body: jsonEncode(elem), headers: {'Content-type': 'application/json'}).timeout(const Duration(seconds: 5));
    if(response.statusCode != 200){
      throw Exception("Something is wrong");
    }
    return SportsActivity.fromJson(jsonDecode(response.body), SportsActivityFields.idServer);
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
      var response = await http.get(Uri.parse("${Apis.url}/products")).timeout(
          const Duration(seconds: 5));
      List<dynamic> values = jsonDecode(response.body);
      List<SportsActivity> fin = [];
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            var elem = SportsActivity.fromJson(map, SportsActivityFields.idServer);
            fin.add(elem);
          }
        }
      }
      return fin;
    }on TimeoutException catch(_){
      throw Exception("Error fetching data from server");
    }
  }

  @override
  Future<SportsActivity> update(SportsActivity el) async {
    var body = el.mapToJson(SportsActivityFields.idServer, add: false);
    var resp = await http.put(Uri.parse(Apis.url), body: jsonEncode(body), headers: {'Content-type': 'application/json'});
    if(resp.statusCode != 200){
      throw Exception("Something is wrong");
    }
    return el;
  }

}