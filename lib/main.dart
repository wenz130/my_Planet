import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_planet/friend.dart';
import 'package:my_planet/plaza.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My',
      home: Scaffold(
        body: GoogleMapScreen(),
      ),
    );
  }
}

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  int _currentIndex = 1;
  GoogleMapController? _mapController;
  LatLng? _currentLocation;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // 위치 권한 요청 메서드
  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // 위치 권한을 받은 후에는 위치 정보를 가져온다.
      _getCurrentLocation();
    }
  }

  // 구글 맵 컨트롤러 초기화 및 맵 스타일 설정
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.setMapStyle(_mapStyle);

    // 구글 맵이 생성된 후 위치 정보를 가져옵니다.
    _getCurrentLocation();
  }

  // 현재 위치 가져오기
  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // 탭 변경 시 호출되는 메서드
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 화면을 구성하는 위젯을 반환하는 메서드
  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return FriendPage();
      case 1:
        return _buildHomeScreen();
      case 2:
        return Plaza();
      default:
        return Container();
    }
  }

  // 홈 화면을 구성하는 위젯 반환
  Widget _buildHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('hh'),
        centerTitle: true,
      ),
      body: Container(
        // 대형 화면에서의 맵 뷰
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentLocation ?? LatLng(37.5, 127.0), // 초기 맵 중심 위치
            zoom: 4.0, // 초기 줌 레벨
          ),
          myLocationEnabled: true, // 현재 위치 활성화
          markers: _createMarkers(),
        ),
      ),
    );
  }

  // 현재 위치에 마커 생성
  Set<Marker> _createMarkers() {
    return {
      if (_currentLocation != null)
        Marker(
          markerId: MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: '현재 위치'),
        ),
    };
  }

  // 맵 스타일 설정
  final String _mapStyle = '''
  [
    {
      "featureType": "poi",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit",
      "stylers": [{"visibility": "off"}]
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '친구',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '게시판',
          ),
        ],
      ),
    );
  }
}
