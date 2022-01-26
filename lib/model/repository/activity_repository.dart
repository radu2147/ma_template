import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/view_model/view_model.dart';

abstract class Repository{

  late List<SportsActivity> listState;
  late SportsActivityViewModel observer;

  Future<void> delete(BigInt id);
  Future<List<SportsActivity>> readAll({saveLocally: true});

  Future<SportsActivity> readById(BigInt int);

  Future<SportsActivity> add(SportsActivity el);

  Future<SportsActivity> update(SportsActivity sportsActivity);

  void dispose() {}
}