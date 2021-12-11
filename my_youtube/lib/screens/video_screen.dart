import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:my_youtube/models/video_model.dart';

// home_screen 에서 비디오를 누르면 나오는 비디오 재생 스크린이다.
class VideoScreen extends StatefulWidget {
  final Video myVideo;
  VideoScreen({this.myVideo});
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.myVideo.id,
      flags: YoutubePlayerFlags(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: SafeArea(
        child: Container(
          color: Color(0xff212121),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector( // 비디오 화면을 아래로 드래그하면 뒤로가기됨
                onVerticalDragEnd: (dragEndDetails) {
                  if(dragEndDetails.primaryVelocity>500.0) {
                      Navigator.pop(context);
                  }
                },
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    print('Player is ready.');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.myVideo.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                // 설명 부분 위의 선
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[700],
                ),
              ),
              Expanded(
                child: Padding(
                  // 영상 설명 텍스트 부분
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.myVideo.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
