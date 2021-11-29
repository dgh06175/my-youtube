![Platform](https://img.shields.io/badge/Platform-Android-orange.svg)

## 📺 My 유튜브
My 유튜브는 유튜브 채널 목록을 관리하고 해당 채널의 동영상을 보는 프로그램입니다. 유튜브 알고리즘에 의해 추천되는 동영상들을 제외하고, 원하는 채널의 동영상만 보기 위해 고안됐습니다.

## 🛠 기능
* 선호하는 유튜브 채널들을 목록으로 관리합니다.
* 채널 카드를 터치해서 채널에 업로드 되어있는 동영상을 시청합니다.
* 직접 고른 채널의 동영상만 시청하게 됨으로써, 재미있어 보이는 추천 동영상들을 하루종일 보게되는 유튜브 알고리즘의 늪에서 빠져 나올 수 있습니다.

## 🎦 예시 영상
[![My Youtube](https://img.youtube.com/vi/UMtYgqvdzfk/0.jpg)](https://youtu.be/UMtYgqvdzfk)

## 🛠 실행 방법
lib/utilities 경로에 keys.dart 파일을 생성하고, 다음과 같은 코드를 입력해 줘야 합니다.
#### lib/utilities/keys.dart
```groovy
const String API_KEY = '본인의 유튜브 API 키';
```