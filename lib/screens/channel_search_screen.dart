import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_youtube/models/channel_search_model.dart';
import 'package:my_youtube/services/api_service.dart';
import 'package:my_youtube/screens/home_screen.dart';

class ChannelSearchScreen extends StatefulWidget {
  ChannelSearchScreen({@required this.addIdInList});
  final Function addIdInList;
  @override
  _ChannelSearchScreenState createState() =>
      _ChannelSearchScreenState(addIdInList: addIdInList);
}

class _ChannelSearchScreenState extends State<ChannelSearchScreen> {
  _ChannelSearchScreenState({this.addIdInList});
  Function addIdInList;
  TextEditingController searchTextEditingController = TextEditingController();
  String inputText;
  clearSearchBox() {
    searchTextEditingController.clear();
    setState(() {
      inputText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchTextEditingController,
                autofocus: true,
                cursorColor: Colors.red,
                cursorHeight: 24.0,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: '채널 검색',
                  labelStyle: TextStyle(
                    color: Colors.grey[200],
                  ),
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      clearSearchBox();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ),
                onSubmitted: (text) {
                  clearSearchBox();
                  setState(() {
                    inputText = text;
                  });
                },
              ),
            ),
            inputText == null
                ? displayNoSearchResultScreen()
                : displayUsersFoundScreen(inputText, addIdInList, inputText),
          ],
        ),
      ),
    );
  }
}

class SearchedCard extends StatefulWidget {
  const SearchedCard(
      {@required this.text,
      @required this.addIdInList,
      @required this.inputText});
  final String text;
  final Function addIdInList;
  final String inputText;

  @override
  _SearchedCardState createState() => _SearchedCardState(
      text: text, addIdInList: addIdInList, inputText: inputText);
}

class _SearchedCardState extends State<SearchedCard> {
  _SearchedCardState(
      {@required this.text,
      @required this.addIdInList,
      @required this.inputText});
  final String text;
  final Function addIdInList;
  String inputText;
  SearchedChannelStatus _searchedChannelStatus;

  _initSearchedChannelStatus() async {
    SearchedChannelStatus mySearchedChannel =
        await APIService.instance.fetchSearchedChannelStatus(inputText: text);
    setState(() {
      _searchedChannelStatus = mySearchedChannel;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSearchedChannelStatus();
  }

  Widget build(BuildContext context) {
    if (_searchedChannelStatus != null) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen(id: _searchedChannelStatus.channelId);
                    },
                  ),
                );
              },
              child: SearchedChannelCardListTile(
                  searchedChannelStatus: _searchedChannelStatus),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                addIdInList(_searchedChannelStatus.channelId);
                inputText = null;
                Navigator.pop(context);
              },
              child: Text(
                '구독',
                style: TextStyle(fontSize: 15.0, color: Colors.red),
              ),
            ),
          ),
        ],
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

class SearchedChannelCardListTile extends StatefulWidget {
  SearchedChannelCardListTile({
    @required SearchedChannelStatus searchedChannelStatus,
  }) : _searchedChannelStatus = searchedChannelStatus;

  final SearchedChannelStatus _searchedChannelStatus;

  @override
  _SearchedChannelCardListTileState createState() =>
      _SearchedChannelCardListTileState();
}

class _SearchedChannelCardListTileState
    extends State<SearchedChannelCardListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[400],
      margin: EdgeInsets.only(left: 20.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.white,
          backgroundImage:
              NetworkImage(widget._searchedChannelStatus.profilePictureUrl),
        ),
        title: Text(
          widget._searchedChannelStatus.title,
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

displayNoSearchResultScreen() {
  return Expanded(
    child: Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          SizedBox(height: 100.0),
          Icon(Icons.add_to_queue, color: Colors.grey, size: 150),
          Text(
            '구독 채널 추가',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 40),
          ),
        ],
      ),
    ),
  );
}

displayUsersFoundScreen(
    String inputtedText, Function addIdInList, String inputText) {
  return Expanded(
    child: Container(
      color: Colors.grey[900],
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return SearchedCard(
              text: inputtedText,
              addIdInList: addIdInList,
              inputText: inputText);
        },
      ),
    ),
  );
}
