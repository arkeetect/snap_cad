import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/projects.dart';

class ProjectDetailScreen extends StatelessWidget {
  static const routeName = '/project-detail';

  @override
  Widget build(BuildContext context) {
    final projectId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProject = Provider.of<Projects>(
      context,
      listen: false,
    ).findById(projectId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProject.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProject.title),
              background: Hero(
                tag: loadedProject.id,
                child: Image.network(
                  loadedProject.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '\$${loadedProject.category}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProject.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
