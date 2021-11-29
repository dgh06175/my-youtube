// main_model.dart 는 채널의 프로필 사진과, 채널명이 포함되어있는 카드 에서 사용할 클래스들을 작성한 파일이다. channel_search_screen.dart 의 SearchedCard 와 main_screen.dart 의 SubscribeCard 에서 사용된다.

class ChannelStatus {
  final String title;
  final String profilePictureUrl;

  ChannelStatus({
    this.title,
    this.profilePictureUrl,
  });

  factory ChannelStatus.fromMap(Map<String, dynamic> map) {
    return ChannelStatus(
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
    );
  }
}
