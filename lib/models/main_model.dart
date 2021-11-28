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
