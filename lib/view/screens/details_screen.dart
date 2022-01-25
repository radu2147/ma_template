import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/api/api_response.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'alert.dart';

class DetailsScreen extends StatefulWidget{

  SportsActivity elem;
  DetailsScreen(this.elem, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailsState(elem);

}

class _DetailsState extends State<DetailsScreen>{

  final SportsActivity _elem;
  SportsType? type;
  late String location;
  late DateTime date;
  _DetailsState(this._elem){
    type = _elem.type;
    date = _elem.date;
    location=  _elem.location;
  }


  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
            appBar: AppBar(
            title: const Text("BuddyFinder"),
            leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back),
              )
            ),
            body:

              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 35.0, 25.0, 0),
                child:
                Column(
                  children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0, 0, 30),
                          child:
                            Row(
                              children:const [
                                Text("Update this activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),)
                              ])
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(0,0, 0, 15),
                            child:
                            Row(
                              children: const [
                                Text("Update location",
                                  style: TextStyle(fontSize: 9.0),
                                ),
                              ],
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0,0, 0, 30),
                            child:
                            Row(
                              children: [
                                Expanded(
                                    child:
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(5.0),
                                          hintText: "Enter a location",
                                        ),
                                        initialValue: location,
                                        onChanged: (e){
                                          setState(() {
                                            location = e;
                                          });
                                        },
                                      )
                                ),
                              ],
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0,0, 0, 15),
                            child:
                            Row(
                              children: const [
                                Text("Update sport type",
                                  style: TextStyle(fontSize: 9.0),
                                ),
                              ],
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0,0, 0, 30),
                            child:
                            Row(
                                children: [
                                  Expanded(
                                    child:
                            DropdownButton(
                              value: type,
                              items: SportsType.values.map((e) =>
                                  DropdownMenuItem(
                                      value: e,
                                      child: Text(SportsActivity.mapTypeToText(e))
                                  )).toList(),

                              onChanged: (SportsType? e){
                                setState(() {
                                  type = e;
                                });
                              },

                            )
                           )]
                            )

                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0,0, 0, 15),
                            child:
                            Row(
                              children: const [
                                Text("Update date",
                                  style: TextStyle(fontSize: 9.0),
                                ),
                              ],
                            )
                        ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0,0, 0, 30),
                        child:
                        Row(
                          children: [
                            Expanded(
                                child:
                                SfDateRangePicker(
                                  initialDisplayDate: _elem.date,
                                  onSelectionChanged: (e){
                                    setState(() {
                                      date = e.value;
                                    });
                                  },
                                )
                            ),
                          ],
                        )
                    ),
                    Expanded(
                      child:
                          Row(
                            children:[
                              MaterialButton(onPressed: () async {
                                if(type == null){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AlertScreen(Provider.of<SportsActivityViewModel>(context, listen: false).response.message)));
                                }
                                await Provider.of<SportsActivityViewModel>(context, listen: false).updateActivity(
                                    SportsActivity(id: _elem.id, location: location, date: date, closed: false, type: type! )
                                );
                                if(Provider.of<SportsActivityViewModel>(context, listen: false).response.status != Status.ERROR){
                                  Navigator.pop(context);
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AlertScreen(Provider.of<SportsActivityViewModel>(context, listen: false).response.message)));
                                }
                              },
                                color: Colors.deepPurple,
                                child: const Text("UPDATE"),
                                textColor: Colors.white,
                                minWidth: MediaQuery.of(context).size.width - 50,
                              )
                            ]
                          )
                    )

                          ]
                      ),
                    )
        );
  }

}