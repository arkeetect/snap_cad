import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/projects.dart';

class ProjectVideoScreen extends StatelessWidget {
// final String title;
  // final double price;

  // ProjectDetailScreen(this.title, this.price);
  static const routeName = '/project-video';

  @override
  Widget build(BuildContext context) {
    final projectId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProject = Provider.of<Projects>(
      context,
      listen: false,
    ).findById(projectId);

    final videoId = YoutubePlayer.convertUrlToId(loadedProject.url);
    if (videoId == null) {
      return Center(
        child: Text('Unable to load video'),
      );
    }
      YoutubePlayerController _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ));

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProject.title),
      // ),
      body: _controller != null

          ? YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.purpleAccent,
            )
          : Center(
              child: Text('Unable to load video'),
            ),

      //HtmlWidget(
      //     '''
      //        <iframe width="100%" height='100%'
      //         src="https://www.facebook.com/v2.3/plugins/video.php?
      //         allowfullscreen=true&autoplay=true&href=${loadedProject.url}" </iframe>
      //  ''',
      //     webView: true,
      //   ),
    );
  }
}
