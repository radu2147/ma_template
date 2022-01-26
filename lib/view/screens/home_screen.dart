import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/api/api_response.dart';
import 'package:buddy_finder/view/screens/add_screen.dart';
import 'package:buddy_finder/view/screens/details_screen.dart';
import 'package:buddy_finder/view/widgets/activity_list_widget.dart';
import 'package:buddy_finder/view/widgets/sidenavbar.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> implements Observer{


  @override
  dispose(){
    super.dispose();
  }

  Widget getWidget(BuildContext context, ApiResponse apiResponse) {
    Provider.of<SportsActivityViewModel>(context, listen: false).observers.add(this);
    List<SportsActivity>? mediaList = apiResponse.data;
    print(apiResponse.status);
    switch (apiResponse.status) {
      case Status.LOADING:
        return const Center(child: CircularProgressIndicator());
      case Status.ERROR:
        return RefreshIndicator(child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(child: Text(apiResponse.message!)),
        ), onRefresh: () => Provider.of<SportsActivityViewModel>(context, listen: false).fetchSportsActivityData());
      case Status.INITIAL:

      case Status.COMPLETED:
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 8,
              child: SportsActivityListWidget(mediaList!, (SportsActivity sa) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(sa)));
              }),
            ),

          ],
        );
    }
  }


  
  @override
  Widget build(BuildContext context) {
    ApiResponse apiResponse = Provider.of<SportsActivityViewModel>(context).response;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text("BuddyFinder"),
        leading: IconButton(onPressed: () => _scaffoldKey.currentState?.openDrawer(), icon: const Icon(Icons.menu)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen()));
      },
        child: const Icon(Icons.add)
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