import 'package:flashpark_client/widgets/Menu_widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class VideoApp extends StatefulWidget {
  String video = '';
  VideoApp(String s) {
    this.video = s;
  }

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayuda',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Ayuda",
            style: TextStyles.appPartnerTextStyle
                .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orange,
          toolbarHeight: 70,
          centerTitle: true,
        ),
        drawer: Menu().getDrawer(context),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
