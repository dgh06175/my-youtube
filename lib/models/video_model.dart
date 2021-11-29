// video_model.dart 는 비디오 재생 페이지에서 사용할 클래스들을 작성한 파일이다.

class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String description;
  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
    this.description,
  });

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['medium']['url'],
      channelTitle: snippet['channelTitle'],
      description: snippet['description'],
    );
  }
}
