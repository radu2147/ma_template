import 'package:buddy_finder/view/screens/second_screen.dart';
import 'package:buddy_finder/view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Second screen'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondScreen()));

              Provider.of<SportsActivityViewModel>(context, listen: false).fetchDataSorted();
            },
          ),
        ],
      )
    );
  }
}