import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormInputBool extends StatefulWidget{

  Function binding;
  final String text;
  DateTime initialValue;
  FormInputBool( {Key? key, required this.binding, required this.text, required this.initialValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormInputBoolState(binding, text, initialValue);
}

class _FormInputBoolState extends State<FormInputBool> {

  Function binding;
  String text;
  DateTime initialValue;

  _FormInputBoolState(this.binding, this.text, this.initialValue);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0,0, 0, 30),
        child:
        Row(
            children: [
              Expanded(
                  child:
                  SfDateRangePicker(
                    onSelectionChanged: (e) => binding(e.value))
                  )
              ]
        )
    );
  }
}