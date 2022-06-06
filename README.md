![Platform](https://img.shields.io/badge/Platform-Android-orange.svg)

## 📺 My 유튜브
My 유튜브는 유튜브 채널 목록을 관리하고 해당 채널의 동영상을 보는 프로그램입니다. 유튜브 알고리즘에 의해 추천되는 동영상들을 제외하고, 원하는 채널의 동영상만 보기 위해 고안됐습니다.

## 🛠 기능
* 선호하는 유튜브 채널들을 목록으로 관리합니다.
* 채널 카드를 터치해서 채널에 업로드 되어있는 동영상을 시청합니다.
* 직접 고른 채널의 동영상만 시청하게 됨으로써, 재미있어 보이는 추천 동영상들을 하루종일 보게되는 유튜브 알고리즘의 늪에서 빠져 나올 수 있습니다.

## 🎦 작동 영상
[![My Youtube](https://img.youtube.com/vi/UMtYgqvdzfk/0.jpg)](https://youtu.be/UMtYgqvdzfk)

## 🎮 실행 방법
lib/utilities 경로에 keys.dart 파일을 생성하고, 다음과 같은 코드를 입력해 줘야 합니다.
#### keys.dart
```groovy
const String API_KEY = '본인의 유튜브 API 키';
```
위 작업을 완료한 후, Android Studio를 이용해서 실행해야 합니다.

### 유튜브 API 키 발급 받는 방법
https://console.cloud.google.com/ 에 접속한다.
1. 새로운 프로젝트를 만든다
2. 만든 프로젝트를 선택하고, 대시보드 상단의 검색창을 클릭한다.
3. youtube data API v3 를 검색해서 누르고, 사용 버튼을 클릭한다.
4. 사용자 인증 정보 만들기 버튼을 클릭한다.
5. API 선택에서는 youtube data API v3 를, 엑세스 할 데이터는 공개 데이터를 선택하고 다음 버튼을 누른다.
6. 발급된 API 키를 복사하고 완료 버튼을 누른다.
7. API 키를 프로젝트의 lib/utilities/keys.dart 파일에 위의 예시과 같게 적용한다.
