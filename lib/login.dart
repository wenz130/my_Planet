import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text('Google 로그인'),
            ),
            ElevatedButton(
              onPressed: _signUpWithEmail,
              child: Text('이메일로 회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    // Google 로그인
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential credential = await _auth.signInWithPopup(googleProvider);
      print('Google 로그인 완료: ${credential.user.displayName}');
      // 로그인 완료 후 메인 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      print('Google 로그인 에러: $e');
    }
  }

  Future<void> _signUpWithEmail() async {
    // 이메일로 회원가입
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: 'example@example.com',
        password: 'password',
      );
      print('이메일로 회원가입 완료: ${credential.user.email}');
      // 회원가입 완료 후 닉네임 설정 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NicknameScreen(credential.user.uid)),
      );
    } catch (e) {
      print('이메일로 회원가입 에러: $e');
    }
  }
}

class NicknameScreen extends StatefulWidget {
  final String userId;

  NicknameScreen(this.userId);

  @override
  _NicknameScreenState createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('닉네임 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNickname,
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNickname() async {
    // 닉네임 저장
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).set({
        'nickname': _nicknameController.text,
      });
      print('닉네임 저장 완료: ${_nicknameController.text}');
      // 저장 완료 후 메인 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      print('닉네임 저장 에러: $e');
    }
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 화면'),
      ),
      body: Center(
        child: Text('로그인이 완료되었습니다!'),
      ),
    );
  }
}
