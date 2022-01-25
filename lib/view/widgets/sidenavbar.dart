import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('User'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.stacked_bar_chart),
            title: const Text('Stats'),
            onTap: () => null,
          ),
        ],
      )
    );
  }
}