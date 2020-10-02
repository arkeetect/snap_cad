import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_cad/screens/project_video_play.dart';

import './screens/cart_screen.dart';
import './screens/projects_overview_screen.dart';
import './screens/project_detail_screen.dart';
import './providers/projects.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/snap_auth.dart';
import './screens/orders_screen.dart';
import './screens/user_projects_screen.dart';
import './screens/edit_project_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred!'),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: SnapAuth(),
                ),
                ChangeNotifierProxyProvider<SnapAuth, Projects>(
                  create: (ctx) => Projects('', '', []),
                  update: (ctx, auth, previousProjects) => Projects(
                    auth.token,
                    auth.userId,
                    previousProjects == null ? [] : previousProjects.items,
                  ),
                ),
                ChangeNotifierProvider.value(
                  value: Cart(),
                ),
                ChangeNotifierProxyProvider<SnapAuth, Orders>(
                  create: (ctx) => Orders('', '', []),
                  update: (ctx, auth, previousOrders) => Orders(
                    auth.token,
                    auth.userId,
                    previousOrders == null ? [] : previousOrders.orders,
                  ),
                ),
              ],
              child: Consumer<SnapAuth>(
                builder: (ctx, auth, _) => MaterialApp(
                  title: 'SnapCAD',
                  theme: ThemeData(
                    primarySwatch: Colors.purple,
                    accentColor: Colors.deepOrange,
                    fontFamily: 'Lato',
                  ),
                  home: auth.isAuth ? ProjectsOverviewScreen() : AuthScreen(),
                  routes: {
                    ProjectDetailScreen.routeName: (ctx) =>
                        ProjectDetailScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    OrdersScreen.routeName: (ctx) => OrdersScreen(),
                    UserProjectsScreen.routeName: (ctx) => UserProjectsScreen(),
                    EditProjectScreen.routeName: (ctx) => EditProjectScreen(),
                    ProjectVideoScreen.routeName: (ctx) => ProjectVideoScreen(),
                  },
                ),
              ),
            );
          }
        });
  }
}
