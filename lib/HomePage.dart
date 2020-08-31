//import 'package:finedustpollution/widgets/my_painter.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'dart:ui' as ui;
//import 'dart:typed_data';
//
//class HomePage extends StatefulWidget {
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//
//  Map<MarkerId,Marker> _markers = Map();
//
//  final _initialCameraPosition = CameraPosition(
//    target: LatLng(20.995956, 105.802364),
//    zoom: 17
//  );
//
//  _onTap(LatLng position)async{
//    final markerId = MarkerId(_markers.length.toString());
//    //final marker = Marker(markerId: markerId,position: position);
//
//    final bitmap = await _myPainterToBitmap(position.toString());
//    final marker = Marker(
//        markerId: markerId,
//        anchor: Offset(0.5,0.5),
//        position: position,
//        icon: BitmapDescriptor.fromBytes(bitmap)
//    );
//
//    setState(() {
//      _markers[markerId] = marker;
//    });
//  }
//
//  Future<Uint8List> _myPainterToBitmap(String label) async{
//    ui.PictureRecorder recorder = ui.PictureRecorder();
//    final Canvas canvas = Canvas(recorder);
//    MyPainter myPainter = MyPainter(label);
//    myPainter.paint(canvas, Size(400,100));
//
//   final ui.Image image = await recorder.endRecording().toImage(400, 100);
//   final ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//   return byteData.buffer.asUint8List();
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.greenAccent,
//      body: GoogleMap(
//        initialCameraPosition: _initialCameraPosition,
//        markers: Set.of(_markers.values),
//        onTap: _onTap,
//      ),
//    );
//  }
//}
