import 'package:flutter/material.dart';
import 'package:my_youtube/models/channel_model.dart';
import 'package:my_youtube/models/video_model.dart';
import 'package:my_youtube/screens/video_screen.dart';
import 'package:my_youtube/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({@required this.id});
  final String id;

  @override
  _HomeScreenState createState() => _HomeScreenState(id: id);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState({@required this.id});
  final String id;

  Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  // _channel 변수에 id가 주소인 채널의 정보를 저장해주는 함수 _initChannel()
  _initChannel() async {
    Channel channel = await APIService.instance.fetchChannel(channelId: id);
    // 채널 id로 api_service.dart 의 fetchChannel 실행
    // -> channel 변수에 받아온 데이터들을 Channel 형식으로 저장
    setState(() {
      _channel = channel;
      // home_screen 에서 사용할 _channel 사용가능하게 함
      // setState 안에 해줘야 실시간으로 값이 변하고, 사용 가능
    });
  } // channelId 에 기반해서 채널을 fetch 하는 함수
  // 프로필 부분 불러오는 함수
  _buildProfileInfo() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff252525),
            boxShadow: [
              BoxShadow(
                color: Color(0xff080808),
                offset: Offset(0, 1),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 35.0,
                      backgroundImage: NetworkImage(_channel.profilePictureUrl),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _channel.title ?? '이름 없음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    int.parse(_channel.subscriberCount ?? '0') > 10000
                        ? Text(
                            '구독자 ${(int.parse(_channel.subscriberCount ?? '0') / 10000).floor()}만명',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            '구독자 ${(int.parse(_channel.subscriberCount ?? '0')).floor()}명',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                width: 50.0,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 7.5,
        ),
      ],
    );
  }

  // 비디오 목록중 한 부분 불러오는 함수
  _buildVideo(Video video) {
    // 동영상 목록들을 구성하는 한 칸
    double myMargin = 8.0;
    return GestureDetector(
      // 비디오 목록 클릭, 영상 재생화면 열기
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(myVideo: video), // id 인수 전달, class 실행
        ),
      ),
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: myMargin * 2, vertical: myMargin),
        height: 90.0,
        color: Color(0xff212121),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 박스 내에서 위로 정렬
          children: [
            Image(
              // 썸네일 불러오기
              height: 90.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: myMargin * 2),
            Expanded(
              // 이걸 해야 글자가 넘치면 overflow 되지 않고 아래로 내려감
              child: Text(
                video.title,
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 비디오 목록 더 불러오는 함수
  _loadMoreVideos() async {
    _isLoading = true;
    // 이 함수 실행 도중에 이 함수가 또 실행되는걸 방지하기 위해 쓰는 변수
    List<Video> moreVideos = await APIService.instance.fetchVideosFromPlaylist(
        playlistId: _channel.uploadPlaylistId, isScroll: true);
    // _nextPageToken 이 pageToken 에 들어갔으므로 다음 영상들 불러옴
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      // _channel.videos 를 업데이트 해준다. stateful 이여서 가능.
      _channel.videos = allVideos;
    });
    _isLoading = false; // 로딩 끝
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: _channel != null
          ? Column(
              children: [
                _buildProfileInfo(),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollDetails) {
                      // 스크롤 내렸을때
                      if (!_isLoading &&
                              // 이미 다음 목록들을 로딩하는중이 아닐때 (중복로딩 방지)
                              _channel.videos.length !=
                                  int.parse(_channel.videoCount ?? '0') &&
                              // 채널의 최대 동영상 개수만큼 로딩되지 않았을때
                              scrollDetails.metrics.pixels ==
                                  scrollDetails.metrics.maxScrollExtent
                          // 스크롤을 최대로 내렸을때
                          ) {
                        _loadMoreVideos(); // 스크롤을 내렸고, 세 조건이 맞을 때 비디오 목록의 정보를 수정한다.
                      }
                      return false;
                    },
                    child: ListView.builder(
                      // ListView 생성
                      itemCount: _channel.videos.length ?? 0,
                      // 1을 더한 이유는 비디오 개수 + 채널정보 화면도 하나 더 있어야하기 때문
                      itemBuilder: (BuildContext context, int index) {
                        Video video = _channel.videos[index]; // 나머지는 비디오목록
                        return _buildVideo(video);
                      },
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}
