import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_youtube/models/channel_model.dart';
import 'package:my_youtube/models/video_model.dart';
import 'package:my_youtube/models/main_model.dart';
import 'package:my_youtube/models/channel_search_model.dart';
import 'package:my_youtube/utilities/keys.dart';

class APIService {
  // _nextPageToken 이 실시간으로 데이터를 추적하기 위해
  // APIService 클래스를 singleton 으로 만들어주는 메소드 정의
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  // 데이터를 요청할 url 의 첫번째 부분
  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = ''; // 다음 비디오 결과 페이지의 토큰를 저장할 토큰

  // channelId를 받고 Future<ChannelStatus>를 반환하는 함수 fetchChannelStatus 선언
  Future<ChannelStatus> fetchChannelStatus({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      ChannelStatus channelStatus = ChannelStatus.fromMap(data);
      return channelStatus;
    } else {
      // api 데이터 받아오기 실패
      throw json.decode(response.body)['error']['message'];
    }
  }

  // channelId를 받고 Future<Channel>을 반환하는 함수 fetchChannel 선언
  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    }; // 특정 데이터를 가져올 parameter 정하기

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    ); // 데이터를 가져오기위한 uri 생성

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    }; // 이것은 JSON 오브젝트로부터 데이터를 받게 해준다. (?)

    // Channel 의 정보를 요청한다. 만든 uri 과 headers 를 전달
    var response = await http.get(uri, headers: headers);
    // response 에 http.get 으로 받아온 api 데이터를 넣는데,
    // 응답을 기다려야 한다는것을 await 로 알려줌

    if (response.statusCode == 200) {
      // 데이터 받기 성공
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      // response 의 body 의 items 의 첫번째 부분에 채널 데이터가 들어있다.
      // Map<String, dynamic> 형식의 data 변수를 선언하는 동시에 데이터를 받았다.
      Channel channel = Channel.fromMap(data);
      // Factory 메소드로 Map 형식의 data 를 channel object 로 바꿔준다.

      // videos 의 첫번째 부분 (channel 의 videos 는 list 형식임)을
      // 뒤에 작성할 fetchVideosFromPlaylist 라는 함수로 playlistId에 패치해준다
      channel.videos = await fetchVideosFromPlaylist(
          playlistId: channel.uploadPlaylistId, isScroll: false);
      return channel; // Future<Channel> 형식의 channel 을 반환
    } else {
      // api 데이터 받아오기 실패
      throw json.decode(response.body)['error']['message'];
    }
  }

  // 위에서 받아온 playlistId 를 매개변수로 가지고,
  // Future<List<Video>>형식을 리턴하는 함수 정의
  Future<List<Video>> fetchVideosFromPlaylist(
      {String playlistId, bool isScroll}) async {
    if (isScroll == false) {
      _nextPageToken = '';
    }
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId, // 매개변수
      'maxResults': '8', // 매개변수
      'pageToken': _nextPageToken,
      'key': API_KEY,
    }; // 특정 데이터를 가져올 parameter 정하기

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    ); // uri 만들기

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    }; // 이것은 JSON 오브젝트로부터 데이터를 받게 해준다. (?)

    // Playlist Videos 의 정보를 요청한다. 만든 uri 과 headers 를 전달
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      // 데이터 불러오기 성공
      var data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'] ?? '';
      // data['nextPageToken'] 이 비어있거나 null 이면 _nextPageToken 을 빈 문자열로 해줌
      List<dynamic> videosJson = data['items'];
      // 리스트 videoJson 선언, 받아온 데이터의 items 항목을 넣어줌

      // 업로드 플레이리스트에서 앞의 8개의 영상을 패치함
      List<Video> videos = []; // Video 형식의 리스트 videos 빈 리스트로 선언
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      ); // videosJson 에서 snippet 만만 하나씩 videos 리스트에 넣어줌
      return videos;
    } else {
      // 데이터 받기 실패
      throw json.decode(response.body)['error']['message'];
    }
  }

  // 채널 검색한 결과를 리턴하는 함수 정의
  Future<SearchedChannelStatus> fetchSearchedChannelStatus(
      {String inputText}) async {
    Map<String, String> parameters = {
      'part': 'snippet, id',
      'q': inputText,
      'key': API_KEY,
      'type': 'channel',
      'maxResults': '1',
    }; // 특정 데이터를 가져올 parameter 정하기

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    ); // 데이터를 가져오기위한 uri 생성

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    }; // 이것은 JSON 오브젝트로부터 데이터를 받게 해준다. (?)

    // Channel 의 정보를 요청한다. 만든 uri 과 headers 를 전달
    var response = await http.get(uri, headers: headers);
    // response 에 http.get 으로 받아온 api 데이터를 넣는데,
    // 응답을 기다려야 한다는것을 await 로 알려줌

    if (response.statusCode == 200) {
      // 데이터 받기 성공
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      // response 의 body 의 items 의 첫번째 부분에 채널 데이터가 들어있다.
      // Map<String, dynamic> 형식의 data 변수를 선언하는 동시에 데이터를 받았다.
      SearchedChannelStatus searchChannel = SearchedChannelStatus.fromMap(data);
      // Factory 메소드로 Map 형식의 data 를 SearchedChannelStatus object 로 바꿔준다.

      return searchChannel; // Future<Channel> 형식의 channel 을 반환
    } else {
      // api 데이터 받아오기 실패
      throw json.decode(response.body)['error']['message'];
    }
  }
}
