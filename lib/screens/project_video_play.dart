import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

    // find a variable length hex value at the beginning of the line
    //final regexp = RegExp(r'.*\\?v=(.+?)&.+');

// find the first match though you could also do `allMatches`
    //final matched = regexp.firstMatch(loadedProject.url);
    final _videoId = YoutubePlayer.convertUrlToId(loadedProject.url);
    YoutubePlayer.getThumbnail(videoId: loadedProject.url, webp: false);
    //print('video Id:' + _videoId);
    //FlutterYoutubeViewController _controller;
    //final videoId = YoutubePlayer.convertUrlToId(loadedProject.url);
    // if (videoId == null) {
    //   return Center(
    //     child: Text('Unable to load video'),
    //   );

    return _videoId == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              title: const Text(''),
              actions: <Widget>[],
            ),
            //drawer: AppDrawer(),
            body: Container(
                child: FlutterYoutubeView(
                    onViewCreated: _onYoutubeCreated,
                    //listener: this,
                    scaleMode:
                        YoutubeScaleMode.none, // <option> fitWidth, fitHeight
                    params: YoutubeParam(
                        videoId: _videoId,
                        showUI: true,
                        startSeconds: 0.0, // <option>
                        autoPlay: true,
                        showFullScreen: true) // <option>
                    )));
  }

  _onYoutubeCreated(controller) async {
    await controller.play();
  }
}
