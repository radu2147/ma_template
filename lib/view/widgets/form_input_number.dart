import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormInputNumber extends StatefulWidget{

  Function binding;
  final String text;
  int initialValue;
  FormInputNumber( {Key? key, required this.binding, required this.text, required this.initialValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormInputNumberState(binding, text, initialValue);
}

class _FormInputNumberState extends State<FormInputNumber> {

  Function binding;
  String text;
  int initialValue;

  _FormInputNumberState(this.binding, this.text, this.initialValue);

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
                    initialValue: initialValue.toString(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5.0),
                      hintText: "Enter a $text",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (e) => binding(e),
                  )
              )]
        )
    );
  }
}