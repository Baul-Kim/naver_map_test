import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naver Map',
      home: NaverMapTest(),
    );
  }
}


class NaverMapTest extends StatefulWidget {
  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}



class _NaverMapTestState extends State<NaverMapTest> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;

  var lng = 126.92509639999945;
  var lat = 35.14829739999988;
  var location = LatLng(35.14829739999988,126.92509639999945);

  local() async {
    setState(() async{
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
//권한 상태를 확인합니다.
      if (_permissionGranted == PermissionStatus.denied) {
// 권한이 없으면 권한을 요청합니다.
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
// 권한이 없으면 위치정보를 사용할 수 없어 위치정보를 사용하려는 코드에서 에러가 나기때문에 종료합니다.
          return;
        }
      }

      _locationData = await location.getLocation();
//_locationData에는 위도, 경도, 위치의 정확도, 고도, 속도, 방향 시간등의 정보가 담겨있습니다.
    });
  }




  @override
  Widget build(BuildContext context) {
    local();
    return Scaffold(
      appBar: AppBar(title: const Text('NaverMap Test'),
      leading: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          print('z');
        },
      ),),
      body: Container(
        child: NaverMap(
          onMapCreated: onMapCreated,
          mapType: _mapType,
          locationButtonEnable: true,
          initialCameraPosition: CameraPosition(target: location),
          markers: [
            Marker(markerId: 'naver', position: location)
          ],
        ),
      ),
    );
  }


  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}

class Position {
}


