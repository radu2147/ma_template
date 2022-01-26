import 'dart:developer';

import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/api/api_response.dart';
import 'package:buddy_finder/model/repository/activity_repository.dart';
import 'package:buddy_finder/model/repository/retorift_repository.dart';
import 'package:flutter/cupertino.dart';

class SportsActivityViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');
  ApiResponse _addApiResponse = ApiResponse.initial('Empty data');
  ApiResponse _updateApiResponse = ApiResponse.initial('Empty data');
  ApiResponse _secondScreenApiResponse = ApiResponse.initial('Empty data');

  Set<Observer> observers = {};

  late Repository repo;

  SportsActivityViewModel(){
    repo = BuddyDatabaseAndServerRepo.db;
    repo.observer = this;
    fetchSportsActivityData();
  }

  void notify(){
    notifyListeners();
  }

  SportsActivity? _act;

  ApiResponse get response {
    return _apiResponse;
  }

  ApiResponse get secondScreenResponse {
    return _secondScreenApiResponse;
  }

  ApiResponse get addApiResponse {
    return _addApiResponse;
  }

  ApiResponse get updateApiResponse {
    return _updateApiResponse;
  }

  List<SportsActivity>? get listState{
    return repo.listState;
  }

  SportsActivity? get act {
    return _act;
  }

  @override
  void dispose(){
    super.dispose();
    repo.dispose();
  }

  Future<void> fetchSportsActivityData() async {

    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      log("Getting all activities");
      var list = await repo.readAll();
      repo.listState = list;
      _apiResponse = ApiResponse.completed(repo.listState);
    } catch (e) {
      log("Error fetching from server");
      _apiResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  Future<void> fetchDataSorted() async {
    _secondScreenApiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      log("Getting sorted activities");
      List<SportsActivity> list = await repo.readAll(saveLocally: false);
      list.sort((a, b) => a.pret - b.pret);
      _secondScreenApiResponse = ApiResponse.completed(list);
    } catch (e) {
      log("Error fetching from server");
      _secondScreenApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteActivity(BigInt id) async {
    _apiResponse = ApiResponse.loading("Deleting activity");
    notifyListeners();
    try{
      log("Deleting activity with id ${id.toInt()}");
      await repo.delete(id);
      _apiResponse = ApiResponse.completed(repo.listState);
    }
    catch(e){
      log("Error deleting...");
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> addActivity(SportsActivity el) async {
    _addApiResponse = ApiResponse.loading("Deleting activity");
    notifyListeners();
    try{
      log("Adding activity");
      await repo.add(el);
      _apiResponse = ApiResponse.completed(repo.listState);
      _addApiResponse = ApiResponse.initial("Add api response");
    }
    catch(e){
      log("Error adding activity");
      _addApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  void setSelectedSportsActivity(SportsActivity? spo) {
    _act = spo;
    notifyListeners();
  }

  Future<void> updateActivity(SportsActivity sportsActivity) async {
    _updateApiResponse = ApiResponse.loading("Updating activity");
    notifyListeners();
    try{
      log("Updating activity");
      await repo.update(sportsActivity);
      _apiResponse = ApiResponse.completed(repo.listState);
      _updateApiResponse = ApiResponse.initial("Updating");
    }
    catch(e){
      log("Error updating");
    _updateApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  void update(String elem) {
    for(var el in observers){
      el.showSnackBar(elem);
    }
  }


}

abstract class Observer{
  void showSnackBar(String elem);
}