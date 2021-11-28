// https://www.googleapis.com/youtube/v3/search?key=AIzaSyA7kLmkh6-u6-boHBLPHBZzIBxeqvvDUD8&type=channel&maxResults=5&q=%EB%B9%A0%EB%8B%88%EB%B3%B4%ED%8B%80
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
//
// class SearchedChannelInfo {
//   final String title;
//   final String profilePictureUrl;
//
//   SearchedChannelInfo({
//     this.title,
//     this.profilePictureUrl,
//   });
//
//   factory SearchedChannelInfo.fromMap(Map<String, dynamic> map) {
//     return SearchedChannelInfo(
//       title: map['snippet']['title'],
//       profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
//     );
//   }
// }
