import 'package:flutter/material.dart';

const String dbName = 'actvitiy';

class SportsActivityFields{
  static const String id = '_id';
  static const String idServer = 'id';
  static const String idType = 'INTEGER PRIMARY KEY';
  static const String nume = 'nume';
  static const String numeType = 'VARCHAR(100) NOT NULL';
  static const String tip = 'tip';
  static const String tipType = 'VARCHAR(100) NOT NULL';
  static const String status = 'status';
  static const String statusType = 'BOOLEAN NOT NULL';
  static const String quantity = 'cantitate';
  static const String quantityType = 'integer';
  static const String pret= 'pret';
  static const String pretType = 'integer';
  static const String discount= 'discount';
  static const String discountType = 'integer';
}

class SportsActivity{
  BigInt id;
  String nume;
  String tip;
  bool status;
  int discount;
  int pret;
  int cantitate;

  SportsActivity({
    required this.id,
    required this.nume,
    required this.status,
    required this.discount,
    required this.pret,
    required this.tip,
    required this.cantitate,
  });

  Map<String, Object?> mapToJson(String idKey, {bool add = true}) => {
      idKey: add ? idKey == SportsActivityFields.id ? null : -1 : id.toInt(),
      SportsActivityFields.nume: nume,
      SportsActivityFields.tip: tip,
      SportsActivityFields.status: status,
      SportsActivityFields.quantity: cantitate,
      SportsActivityFields.pret: pret,
      SportsActivityFields.discount: discount,
    };


  static SportsActivity fromJson(Map<String, Object?> map, String idKey) =>
      SportsActivity(
        id: BigInt.from(map[idKey] as int),
        nume: map[SportsActivityFields.nume] as String,
        status: map[SportsActivityFields.status] == 1,
        tip: map[SportsActivityFields.tip] as String,
        cantitate: map[SportsActivityFields.quantity] as int,
        pret: map[SportsActivityFields.pret] as int,
        discount: map[SportsActivityFields.discount] as int
      );

  @override
  String toString(){
    return id.toString() + ", " + nume;
  }
}
