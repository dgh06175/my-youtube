import 'package:flutter/material.dart';
import 'package:my_youtube/screens/home_screen.dart';
import 'package:my_youtube/screens/channel_search_screen.dart';
import 'package:my_youtube/services/api_service.dart';
import 'package:my_youtube/models/main_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isSetting = false;
List<String> idLists = [];

// MainScreen 은 어플을 실행하면 나오는 구독 목록과 검색 버튼 등이 있는 스크린이다.
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  // 어플을 껐다 켜도 구독 목록을 유지하기 위해 SharedPreferences 를 사용한다.
  // 시작할 떄 counter 값을 불러온다. 이전에 저장했던 idList 를 불러온다.
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idLists = (prefs.getStringList('counter') ?? 0);
    });
  }

  addIdInList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idLists.add(id);
      prefs.setStringList('counter', idLists);
    });
  }

  removeIdInList(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idLists.removeAt(index);
    prefs.setStringList('counter', idLists);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 24.0),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    setState(
                      () {
                        isSetting ? isSetting = false : isSetting = true;
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: isSetting ? Colors.red : Colors.white,
                  ),
                  splashRadius: 20.0,
                ),
                Column(
                  children: [
                    Text(
                      '구독 목록',
                      style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 2.5,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 150.0,
                      child: Divider(
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
                isSetting
                    ? SizedBox(width: 24.0)
                    : IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChannelSearchScreen(
                                    addIdInList: addIdInList);
                              },
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_to_queue,
                          color: isSetting ? Colors.grey : Colors.white,
                        ),
                        splashRadius: 20.0,
                      ),
                SizedBox(width: 24.0),
              ],
            ),
            if (idLists.length < 7)
              SubscribeCardListview(myFlex: 4, removeIdInList: removeIdInList)
            else
              SubscribeCardListview(myFlex: 10, removeIdInList: removeIdInList),
            Expanded(
              flex: 1,
              child: isSetting && idLists.length > 0
                  ? Text(
                      '카드를 옆으로 밀어서 삭제',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}


// 구독 목록을 ListView 로 관리할 위젯이다.
class SubscribeCardListview extends StatefulWidget {
  SubscribeCardListview({@required this.myFlex, @required this.removeIdInList});
  final int myFlex;
  final Function removeIdInList;

  @override
  State<SubscribeCardListview> createState() =>
      _SubscribeCardListviewState(removeIdInList: removeIdInList);
}

class _SubscribeCardListviewState extends State<SubscribeCardListview> {
  _SubscribeCardListviewState({@required this.removeIdInList});
  final Function removeIdInList;
  Widget build(BuildContext context) {
    if (idLists.length > 0) {
      return Expanded(
        flex: widget.myFlex,
        child: ListView.builder(
          itemCount: idLists.length,
          itemBuilder: (BuildContext context, int index) {
            final idList = idLists[index];
            if (isSetting) {
              return Dismissible(
                key: Key(idList),
                onDismissed: (direction) {
                  setState(() {
                    if (direction == DismissDirection.startToEnd ||
                        direction == DismissDirection.endToStart) {
                      removeIdInList(index);
                    }
                  });
                },
                child: SubscribeCard(id: idLists[index]),
              );
            } else {
              return SubscribeCard(id: idLists[index]);
            } // 채널의 id 전달
          },
        ),
      );
    } else {
      return Expanded(
        flex: widget.myFlex,
        child: Column(
          children: [
            SizedBox(height: 100.0),
            Text(
              '구독 목록이 비어있습니다.',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSetting ? Icons.delete : Icons.add_to_queue,
                  color: Colors.grey,
                ),
                Text(
                  isSetting ? ' 아이콘을 눌러 삭제 모드에서 나가세요.' : ' 아이콘을 눌러 채널을 추가하세요.',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }
}

// 구독 목록 안에 들어갈 카드 위젯이다.
class SubscribeCard extends StatefulWidget {
  SubscribeCard({@required this.id});
  final String id;

  @override
  _SubscribeCardState createState() => _SubscribeCardState(id: id);
}

class _SubscribeCardState extends State<SubscribeCard> {
  _SubscribeCardState({@required this.id});
  final String id;
  ChannelStatus _channelStatus;

  _initChannelStatus() async {
    ChannelStatus myChannel =
        await APIService.instance.fetchChannelStatus(channelId: id);
    setState(() {
      _channelStatus = myChannel;
    });
  }

  @override
  void initState() {
    super.initState();
    _initChannelStatus();
  }

  Widget build(BuildContext context) {
    if (_channelStatus != null) {
      return TextButton(
        onPressed: !isSetting
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen(id: id);
                    },
                  ),
                );
              }
            : null,
        child: ChannelCardListTile(channelStatus: _channelStatus, id: id),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }
  }
}

class ChannelCardListTile extends StatefulWidget {
  ChannelCardListTile(
      {@required ChannelStatus channelStatus, @required this.id})
      : _channelStatus = channelStatus;

  final ChannelStatus _channelStatus;
  final String id;

  @override
  _ChannelCardListTileState createState() => _ChannelCardListTileState(id: id);
}

class _ChannelCardListTileState extends State<ChannelCardListTile> {
  _ChannelCardListTileState({@required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSetting ? Colors.grey[500] : Colors.grey[300],
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.white,
          backgroundImage:
              NetworkImage(widget._channelStatus.profilePictureUrl),
        ),
        title: Text(
          widget._channelStatus.title,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            color: Color(0xff000000),
          ),
        ),
      ),
    );
  }
}
