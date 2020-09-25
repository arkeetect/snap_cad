import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/projects.dart';

class ProjectVideoScreen extends StatefulWidget {
// final String title;

  static const routeName = '/project-video';

  @override
  _ProjectVideoScreenState createState() => _ProjectVideoScreenState();
}

class _ProjectVideoScreenState extends State<ProjectVideoScreen> {
  YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  PlayerState _playerState; // = PlayerState.unStarted;

  @override
  void initState() {
    super.initState();
    this._playerState = PlayerState.playing;
    // this._controller = YoutubePlayerController(
    //   initialVideoId: 'lgkZC_Ss6YE',
    //   flags: YoutubePlayerFlags(
    //     mute: false,
    //     autoPlay: true,
    //     disableDragSeek: true,
    //     loop: false,
    //     isLive: false,
    //     //forceHideAnnotation: true,
    //     forceHD: false,
    //     enableCaption: true,
    //   ),
    // )..addListener(_videoPlayerListner);
  }

  void _videoPlayerListner() {
    //if (_isPlayerReady) {
    setState(() {
      _playerState = _controller.value.playerState;
    });
    //}
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    this._controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ))
      ..addListener(_videoPlayerListner);

    return YoutubePlayer(
      // appBar: AppBar(
      //   title: Text(loadedProject.title),
      // ),

      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.purpleAccent,

      //HtmlWidget(
      //     '''
      //        <iframe width="100%" height='100%'
      //         src="https://www.facebook.com/v2.3/plugins/video.php?
      //         allowfullscreen=true&autoplay=true&href=${loadedProject.url}" </iframe>
      //  ''',
      //     webView: true,
      //   ),
      onReady: () {
        _isPlayerReady = true;
      },
      onEnded: (data) {},
    );
  }
}
