import 'dart:async';
import 'package:extra_staff/utils/ab.dart';
import 'package:extra_staff/views/page_controller_v.dart';
import 'package:extra_staff/views/confirm_code_v.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController? _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset('lib/images/Splash.mp4');
    _controller!.initialize().then((_) {
      _controller!.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller!.play();
          _visible = true;
        });
      });
    });

    Future.delayed(Duration(milliseconds: 2990), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        if ((localStorage?.getString('passcode') ?? '').isNotEmpty) {
          return EnterCode(isFromStart: true);
        } else {
          return PageControllerView();
        }
      }), (e) => false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: VideoPlayer(_controller!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
          ],
        ),
      ),
    );
  }
}
