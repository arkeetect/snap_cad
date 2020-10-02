import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/projects.dart';
import '../widgets/user_project_item.dart';
import '../widgets/app_drawer.dart';
import 'edit_project_screen.dart';

class UserProjectsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProjects(BuildContext context) async {
    await Provider.of<Projects>(context, listen: false)
        .fetchAndSetProjects(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Projects>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Projects',
          textScaleFactor: 0.7,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProjectScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProjects(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProjects(context),
                    child: Consumer<Projects>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProjectItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
