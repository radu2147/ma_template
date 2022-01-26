import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormInputString extends StatefulWidget{

  Function binding;
  final String text;
  final String initialValue;
  FormInputString( {Key? key, required this.binding, required this.text, required this.initialValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormInputStringState(binding, text, initialValue);
}

class _FormInputStringState extends State<FormInputString> {

  Function binding;
  String text;
  String initialValue;

  _FormInputStringState(this.binding, this.text, this.initialValue);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0,0, 0, 30),
        child:
        Row(
            children: [
              Expanded(
                  child:
                  TextFormField(
                    initialValue: initialValue,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5.0),
                      hintText: "Enter a $text",
                    ),
                    onChanged: (e) => binding(e),
                  )
              )]
        )
    );
  }
}