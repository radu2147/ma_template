import 'dart:developer';

import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/api/api_response.dart';
import 'package:buddy_finder/model/repository/activity_repository.dart';
import 'package:buddy_finder/model/repository/retorift_repository.dart';
import 'package:flutter/cupertino.dart';

class SportsActivityViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

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

  List<SportsActivity>? get listState{
    return repo.listState;
  }

  SportsActivity? get act {
    return _act;
  }

  Future<void> fetchSportsActivityData() async {
    _apiResponse = ApiResponse.loading('Fetching artist data');
    notifyListeners();
    try {
      log("Getting all activities");
      List<SportsActivity> list = await repo.readAll();
      repo.listState = list;
      _apiResponse = ApiResponse.completed(list);
    } catch (e) {
      log("Error fetching from server");
      _apiResponse = ApiResponse.error(e.toString());
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
    _apiResponse = ApiResponse.loading("Deleting activity");
    notifyListeners();
    try{
      log("Adding activity");
      await repo.add(el);
      _apiResponse = ApiResponse.completed(repo.listState);
    }
    catch(e){
      log("Error adding activity");
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  void setSelectedSportsActivity(SportsActivity? spo) {
    _act = spo;
    notifyListeners();
  }

  Future<void> updateActivity(SportsActivity sportsActivity) async {
    _apiResponse = ApiResponse.loading("Deleting activity");
    notifyListeners();
    try{
      log("Updating activity");
      await repo.update(sportsActivity);
      _apiResponse = ApiResponse.completed(repo.listState);
    }
    catch(e){
      log("Error updating");
    _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  void reset() {
    log("Reseying");
    _apiResponse = repo.listState.isEmpty ? ApiResponse.initial("Empty data") : ApiResponse.completed(repo.listState);
    notifyListeners();
  }
}