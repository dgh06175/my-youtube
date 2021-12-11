// channel_search_model.dart 는 채널 검색 페이지에서 사용할 클래스들을 작성한 파일이다.

class SearchedChannelStatus {
  final String channelId;
  final String title;
  final String profilePictureUrl;
  SearchedChannelStatus({
    this.channelId,
    this.title,
    this.profilePictureUrl,
  });

  factory SearchedChannelStatus.fromMap(Map<String, dynamic> map) {
    return SearchedChannelStatus(
      title: map['snippet']['title'],
      channelId: map['id']['channelId'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
    );
  }
}