import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_projects_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Main Menu'),
            automaticallyImplyLeading: false,
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.computer),
            title: Text('View All'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.bookmark_border),
            title: Text('View 3ds Max'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Upgrade'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (ctx) => OrdersScreen(),
              //   ),
              // );
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.cloud_upload),
            title: Text('Manage Projects'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProjectsScreen.routeName);
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Inbox'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.youtube_searched_for),
            title: Text('Search Projects'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProjectsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
