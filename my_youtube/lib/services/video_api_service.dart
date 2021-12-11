// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:my_youtube/models/main_model.dart';
// import 'package:my_youtube/utilities/keys.dart';
//
// class APIService2 {
//   APIService2._instantiate();
//
//   static final APIService2 instance = APIService2._instantiate();
//
//   final String _baseUrl = 'www.googleapis.com';
//
//   Future<VideoStatus> fetchVideoStatus({String videoId}) async { // url 만들기
//     Map<String, String> parameters = {
//       'part': 'snippet(title,description,publishedAt), contentDetails(duration), statistics',
//       'id': videoId,
//       'key': API_KEY,
//     };
//     Uri uri = Uri.https(
//       _baseUrl,
//       '/youtube/v3/channels',
//       parameters,
//     );
//     Map<String, String> headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//     };
//
//     // Get Channel
//     var response = await http.get(uri, headers: headers);
//     if (response.statusCode == 200) { // data 받기 성공
//       Map<String, dynamic> data = json.decode(response.body)['items'][0];
//       VideoStatus videoStatus = VideoStatus.fromMap(data);
//
//       // Fetch first batch of status pf videos from uploads videos
//       // videoStatus.videos = await fetchVideosFromPlaylist(
//       //   statusId: videoStatus.uploadPlaylistId,
//       // );
//       return videoStatus;
//     } else {
//       throw json.decode(response.body)['error']['message'];
//     }
//   }
// }