import 'package:flutter/material.dart';

class PaddingWidget extends StatelessWidget{

  final String text;

  const PaddingWidget({Key? key, required this.text}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0,0, 0, 15),
        child:
        Row(
          children: [
            Text("Update $text",
              style: const TextStyle(fontSize: 9.0),
            ),
          ],
        )
    );
  }
}