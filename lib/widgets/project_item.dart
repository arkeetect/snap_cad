import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/project_video_play.dart';
import '../providers/project.dart';
//import '../providers/cart.dart';
import '../providers/auth.dart';

class ProjectItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProjectItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final project = Provider.of<Project>(context, listen: false);
    //final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            project.setIsViewedInPerfs(authData.token, authData.userId);
            Navigator.of(context).pushNamed(
              ProjectVideoScreen.routeName,
              arguments: project.id,
            );
          },
          child: Hero(
            tag: project.id,
            child: FadeInImage(
              placeholder:
                  AssetImage('assets/images/quentin-grignet-unsplash.jpg'),
              image: NetworkImage(project.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: Container(
          height: 25,
          child: GridTileBar(
            backgroundColor: Colors.purple,
            leading: Consumer<Project>(
              builder: (ctx, project, _) => IconButton(
                iconSize: 20,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                icon: Icon(
                  project.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  project.toggleFavorite(
                    authData.token,
                    authData.userId,
                  );
                },
              ),
            ),
            title: Text(
              project.title,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textWidthBasis: TextWidthBasis.longestLine,
              //textScaleFactor: 0.9,
            ),
            // trailing: IconButton(
            //   icon: Icon(
            //     Icons.bookmark,
            //   ),
            //   onPressed: () {
            //     cart.addItem(project.id, 0, project.title);
            //     Scaffold.of(context).hideCurrentSnackBar();
            //     Scaffold.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(
            //           'Bookmarked!',
            //         ),
            //         duration: Duration(seconds: 2),
            //         action: SnackBarAction(
            //           label: 'UNDO',
            //           onPressed: () {
            //             cart.removeSingleItem(project.id);
            //           },
            //         ),
            //       ),
            //     );
            //   },
            //   color: Theme.of(context).accentColor,
            // ),
          ),
        ),
      ),
    );
  }
}
