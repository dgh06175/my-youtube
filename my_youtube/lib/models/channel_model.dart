// channel_model.dart 는 채널 페이지에서 사용할 클래스들을 작성한 파일이다.
import 'package:my_youtube/models/video_model.dart';

class Channel { // API 호출로 채널 정보를 불러올 때 필요한 정보들
  final String id;
  final String title;
  final String profilePictureUrl;
  String subscriberCount = '0'; // 구독자 수를 비공개처리 해놓은 채널들을 위한 초기화
  final String videoCount;
  final String uploadPlaylistId;
  List<Video> videos; // 채널의 비디오들의 정보가 들어갈 리스트
  Channel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.videos,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    ); // JSON 에서 필요한 정보들을 가져오기 위한 변수들
  }
}
