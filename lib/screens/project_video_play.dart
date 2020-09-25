import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/projects.dart';

class ProjectVideoScreen extends StatelessWidget {
// final String title;

  static const routeName = '/project-video';

  @override
  Widget build(BuildContext context) {
    final projectId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProject = Provider.of<Projects>(
      context,
      listen: false,
    ).findById(projectId);
    print(
      loadedProject.url,
    );
    //final videoId = YoutubePlayer.convertUrlToId(loadedProject.url);
    // if (videoId == null) {
    //   return Center(
    //     child: Text('Unable to load video'),
    //   );

    return Scaffold(
      appBar: AppBar(
        title: Text('Start watching ${loadedProject.title}'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            if (await canLaunch(loadedProject.url)) {
              await launch(loadedProject.url, forceWebView: true);
            } else {
              print('Could not launch ${loadedProject.url}');
            }
          },
          child: Text('Play'),
        ),
      ),
    );
  }
}
