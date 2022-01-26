import 'package:buddy_finder/view_model/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertScreen extends StatelessWidget{

  String? err;

  AlertScreen(this.err, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
        title: const Text("BuddyFinder"),
    leading: IconButton(onPressed: () {

      Navigator.pop(context); }, icon: const Icon(Icons.arrow_back),
    )
    ),
    body:
        Center(
          child:
            Text(err ?? "Eroare")
        ));
  }

}