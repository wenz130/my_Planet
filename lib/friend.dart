import 'package:flutter/material.dart';

void main() {
  runApp(FriendPage());
}

class User {
  final String id;
  final String nickname;

  User(this.id, this.nickname);
}

class FriendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FriendSearchPage(),
    );
  }
}

class FriendSearchPage extends StatefulWidget {
  @override
  _FriendSearchPageState createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  // 사용자 목록과 친구 목록
  List<User> userList = [
    User('1', 'User1'),
    User('2', 'User2'),
    User('3', 'User3'),
    User('4', 'User4'),
    User('5', 'User5'),
  ];

  List<User> friendList = [];

  // 검색 결과를 저장할 리스트
  List<User> searchResults = [];

  // 닉네임으로 사용자 검색
  void searchUsers(String query, List<User> list) {
    setState(() {
      searchResults = list
          .where((user) => user.nickname.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // 친구 추가
  void addFriend(User user) {
    setState(() {
      friendList.add(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('친구 검색 및 추가'),
          bottom: TabBar(
            tabs: [
              Tab(text: '친구'),
              Tab(text: '가입자'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  // 현재 선택된 탭에 따라 검색 결과를 설정
                  if (DefaultTabController.of(context).index == 0) {
                    searchUsers(value, friendList);
                  } else if (DefaultTabController.of(context).index == 1) {
                    searchUsers(value, userList);
                  }
                },
                decoration: InputDecoration(
                  labelText: '닉네임으로 검색',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // 친구 탭에서 검색 결과를 표시
                  ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      User user = searchResults[index];
                      return ListTile(
                        title: Text(user.nickname),
                        trailing: ElevatedButton(
                          onPressed: () {
                            addFriend(user);
                          },
                          child: Text('친구 추가'),
                        ),
                      );
                    },
                  ),
                  // 가입자 탭에서 검색 결과를 표시
                  ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      User user = searchResults[index];
                      return ListTile(
                        title: Text(user.nickname),
                        trailing: ElevatedButton(
                          onPressed: () {
                            addFriend(user);
                          },
                          child: Text('친구 추가'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
