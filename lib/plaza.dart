import 'package:flutter/material.dart';

void main() {
  runApp(Plaza());
}

class Post {
  final String title;
  final String content;

  Post(this.title, this.content);
}

class Plaza extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BoardPage(),
    );
  }
}

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<Post> posts = [];

  void _goToWritePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WritePage()),
    );

    if (result != null && result is Post) {
      setState(() {
        posts.add(result);
      });
    }
  }

  void _goToPostDetail(Post post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailPage(post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          Post post = posts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
            onTap: () => _goToPostDetail(post), // 글을 눌렀을 때 해당 글로 이동
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToWritePage,
        child: Icon(Icons.add),
      ),
    );
  }
}

class WritePage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: '내용',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String title = _titleController.text;
                String content = _contentController.text;

                if (title.isNotEmpty && content.isNotEmpty) {
                  Navigator.pop(context, Post(title, content));
                }
              },
              child: Text('글 등록'),
            ),
          ],
        ),
      ),
    );
  }
}

class PostDetailPage extends StatelessWidget {
  final Post post;

  PostDetailPage(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 상세 보기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              post.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}
