import 'package:buddy_finder/model/activity.dart';
import 'package:buddy_finder/model/api/api_response.dart';
import 'package:buddy_finder/view/screens/alert.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SportsActivityListWidget extends StatefulWidget {
  final List<SportsActivity> _sportsActivityList;
  final Function _function;

  const SportsActivityListWidget(this._sportsActivityList, this._function, {Key? key}) : super(key: key);

  @override
  _SportsActivityListWidgetState createState() => _SportsActivityListWidgetState();
}

class _SportsActivityListWidgetState extends State<SportsActivityListWidget> {
  Widget _buildItem(SportsActivity sa) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Row(
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child:
                  Icon(
                    Icons.person,
                  )
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child:
                      Text(
                        SportsActivity.mapTypeToText(sa.type),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: SportsActivity.mapTypeToColor(sa.type),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child:
                        Text(
                          sa.location,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                    Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child:
                        Text(
                          sa.date.toString(),
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                    ),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child:
                      Text(
                        "Hosted by Anonymous",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                  const SizedBox(
                    height: 2,
                  ),

                ]),
          ),
            IconButton(
                onPressed: () {
                    _showDialog(context, sa);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                )
            ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, SportsActivity sa){
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Click outside the box if you don t want to delete it.'),
              MaterialButton(
                onPressed: () async {
                    await Provider.of<SportsActivityViewModel>(
                        context, listen: false).deleteActivity(sa.id);
                    Navigator.pop(context, false);
                    if(Provider.of<SportsActivityViewModel>(
                        context, listen: false).response.status == Status.ERROR)
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AlertScreen(Provider.of<SportsActivityViewModel>(
                          context, listen: false).response.message)));
                  },
                child: const Text("Delete")
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: widget._sportsActivityList.length,
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            SportsActivity data = widget._sportsActivityList[index];
            return InkWell(
              onTap: () {
                widget._function(data);
              },
              child: _buildItem(data),
            );
          },
        ),
      ]),
    );
  }
}