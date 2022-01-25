import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/view_model/view_model.dart';

class SportsActivityRepository extends Repository {

  final all = <SportsActivity>[
    SportsActivity(
      closed: false,
      location: "Cluj-Napoca", 
      date: DateTime.now(), 
      id: new BigInt.from(1), 
      type: SportsType.TENNIS,
    ),
    SportsActivity(
      closed: false,
      location: "Targu-Mures", 
      date: DateTime.now(), 
      id: new BigInt.from(2),
      type: SportsType.TENNIS,
    ),
  ];

  Future<List<SportsActivity>> readAll() async {
    return all;
  }

  Future<void> delete(BigInt id) async {
    all.removeWhere((element) => element.id == id);
  }

  @override
  Future<SportsActivity> add(SportsActivity el) async {
    el.id = BigInt.from(all.length + 1);
    all.add(el);
    return el;
  }

  @override
  Future<SportsActivity> update(SportsActivity sportsActivity) async {
    all.removeWhere((element) => element.id == sportsActivity.id);
    all.add(sportsActivity);

    return sportsActivity;
  }

  @override
  Future<SportsActivity> readById(BigInt int) {
    // TODO: implement readById
    throw UnimplementedError();
  }

  
}

abstract class Repository{

  late List<SportsActivity> listState;
  late SportsActivityViewModel observer;

  Future<void> delete(BigInt id);
  Future<List<SportsActivity>> readAll();

  Future<SportsActivity> readById(BigInt int);

  Future<SportsActivity> add(SportsActivity el);

  Future<SportsActivity> update(SportsActivity sportsActivity);
}