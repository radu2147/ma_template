import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/api/api_response.dart';
import 'package:buddy_finder/view/widgets/activity_list_widget.dart';
import 'package:buddy_finder/view/widgets/sidenavbar.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondScreen extends StatefulWidget{
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> implements Observer{

  @override
  dispose(){
    super.dispose();
  }

  Widget getWidget(BuildContext context, ApiResponse apiResponse) {
    Provider.of<SportsActivityViewModel>(context, listen: false).observers.add(this);
    List<SportsActivity>? mediaList = apiResponse.data;
    switch (apiResponse.status) {
      case Status.LOADING:
        return const Center(child: CircularProgressIndicator());
      case Status.ERROR:
        return RefreshIndicator(child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(child: Text(apiResponse.message!)),
        ), onRefresh: () => Provider.of<SportsActivityViewModel>(context, listen: false).fetchDataSorted());
      case Status.INITIAL:

      case Status.COMPLETED:
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 8,
              child: SportsActivityListWidget(mediaList!, (SportsActivity sa) {}),
            ),
          ],
        );
    }
  }


  @override
  Widget build(BuildContext context){
    ApiResponse apiResponse = Provider.of<SportsActivityViewModel>(context).secondScreenResponse;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text("BuddyFinder"),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
        ),
        body:
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0),
          child:
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                child: Row(
                    children: const [
                      Text("Message for the first page", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)
                    ]
                ),
              ),
              const Divider(thickness: 1.5,),
              Expanded(child: getWidget(context, apiResponse)),
            ],
          ),
        )
    );
  }

  @override
  void showSnackBar(String elem) {
    final snackBar = SnackBar(
      content: Text("This item has been added recently: " + elem),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}