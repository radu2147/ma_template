import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/api/api_response.dart';
import 'package:buddy_finder/view/widgets/form_input_bool.dart';
import 'package:buddy_finder/view/widgets/form_input_number.dart';
import 'package:buddy_finder/view/widgets/form_input_string.dart';
import 'package:buddy_finder/view/widgets/padding_widget.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _AddState();

}

class _AddState extends State<AddScreen> {

  String tip = "";
  int discount = 0;
  int pret = 0;
  int quantity = 0;
  String nume = "";
  bool status = false;

  Widget getBody(BuildContext context, ApiResponse apiResponse){
    switch(apiResponse.status){
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      default:
        return Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 35.0, 25.0, 0),
          child:
          Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0,0, 0, 30),
                    child:
                    Row(
                        children:const [
                          Text("Add an activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),)
                        ])
                ),

                const PaddingWidget(text: "nume"),
                FormInputString(binding: (e){
                  setState(() {
                    nume = e;
                  });},
                  text: "nume", initialValue: nume,),
                const PaddingWidget(text: "tip"),
                FormInputString(binding: (e){
                  setState(() {
                    tip = e;
                  });}, text: "tip", initialValue: tip,),
                const PaddingWidget(text: "quantity"),
                FormInputNumber(binding: (e){
                  setState(() {
                    quantity = int.parse(e);
                  });}, text: "quantity", initialValue: quantity,),
                const PaddingWidget(text: "pret"),
                FormInputNumber(binding: (e){
                  setState(() {
                    pret = int.parse(e);
                  });}, text: "pret", initialValue: pret,),
                const PaddingWidget(text: "discount"),
                FormInputNumber(binding: (e){
                  setState(() {
                    discount = int.parse(e);
                  });}, text: "discount", initialValue: discount,),
                const PaddingWidget(text: "status"),
                FormInputBool(binding: (e){
                  setState(() {
                    status = e;
                  });}, text: "status", initialValue: status,),
                Expanded(
                    child:
                    Row(
                        children:[
                          MaterialButton(onPressed: () async {
                            setState(() {

                            });
                            await Provider.of<SportsActivityViewModel>(context, listen: false).addActivity(
                                SportsActivity(id: BigInt.from(-1), nume: nume, status: status, discount: discount, pret: pret, cantitate: quantity, tip: tip)
                            );
                            if(Provider.of<SportsActivityViewModel>(context, listen: false).addApiResponse.status != Status.ERROR){
                              Navigator.pop(context);
                            }
                            else{
                              _showDialog(context, Provider.of<SportsActivityViewModel>(context, listen: false).addApiResponse.message!);
                              setState(() {

                              });
                            }
                          },
                            color: Colors.deepPurple,
                            child: const Text("ADD"),
                            textColor: Colors.white,
                            minWidth: MediaQuery.of(context).size.width - 50,
                          )
                        ]
                    )
                )

              ]
          ),
        );
    }
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
            getBody(context, Provider.of<SportsActivityViewModel>(context, listen: false).addApiResponse)

      );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(message),
      );
    });
  }
}