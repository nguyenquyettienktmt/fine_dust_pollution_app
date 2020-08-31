import 'dart:async';

import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:app/models/network/response/fetchData.dart';
import 'package:app/models/network/response/infor_location.dart';
import 'package:app/models/network/service/network_factory.dart';
import 'package:app/pages/info_detail/info_detail_page.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/my_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

import 'map_bloc.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapBloc _mapBloc;
  GoogleMapController _mapController ;
  String latComplete;
  String longComplete;
  TextEditingController _placeController = TextEditingController();
  Set<Marker> markers= Set();
  List<FetchData> fetchData = new List<FetchData>();
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  QuerySnapshot _querySearchSnapshot;
  List<Marker> allMarkers = [];
  Timer _timer;
  int _start = 0;
  bool showTimer = false;
  final focusNode = FocusNode();
  TextEditingController _searchController;
  final TextEditingController _typeAheadController = TextEditingController();

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start > 3600) {
            getInformationLocation();
            _start = 0;
          } else {
            _start = _start + 1;
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _mapBloc = new MapBloc();
    _mapBloc.init(context);
    _mapBloc.add(GetInfoLocationEvent());
    showTimer = false;
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _mapBloc,
      child: BlocListener<MapBloc,MapSate>(
        bloc: _mapBloc,
        listener: (context,state){
          if(state is GetInfoLocationState){
            _mapBloc.allMarkers.clear();
            _mapBloc.add(GetInfoLocationEvent());
            print('xxxx');
          }
        },

        child: BlocBuilder<MapBloc,MapSate>(
          bloc: _mapBloc,
          builder: (BuildContext context, MapSate sate ){
            //Utils.showToast(_mapBloc.allMarkers.length.toString());
            return _buildPages(context,sate);
          },
        ),
      ),
    );
  }


  Widget buildLimitPoint(BuildContext context){
    return Positioned(
      right: 0,
      bottom: 3,
      child: Container(
        decoration: BoxDecoration(

            border: Border.all(
                color: greenAccent,
                width: 1.5
            )
        ),
        height: 140,
        width:  100,
        child: Column(
          children: [
            SizedBox(height: 4,),
            Container(
              width: 90,
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(
                      color: black,
                      width: 0.1
                  )
              ),
              child: Center(
                child: Text(
                  'Chỉ số PM 2.5',style: TextStyle(color: black,fontWeight: FontWeight.normal,fontSize: 10),
                ),
              ),
            ),
            Container(
              width: 90,
              decoration: BoxDecoration(
                  color: lime,
                  border: Border.all(
                      color: black,
                      width: 1
                  )
              ),
              child: Center(
                child: Text(
                  '0 - 12.0',style: TextStyle(color: white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 2,),
            Container(
              width: 90,
              decoration: BoxDecoration(
                  color: yellow,
                  border: Border.all(
                      color: black,
                      width: 1
                  )
              ),
              child: Center(
                child: Text(
                  '12.1 - 35.4',style: TextStyle(color: white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 2,),
            Container(
              width: 90,
              decoration: BoxDecoration(
                  color: orange,
                  border: Border.all(
                      color: black,
                      width: 1
                  )
              ),
              child: Center(
                child: Text(
                  '35.5 - 55.4',style: TextStyle(color: white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 2,),
            Container(
              width: 90,
              decoration: BoxDecoration(
                  color: red2,
                  border: Border.all(
                      color: black,
                      width: 1
                  )
              ),
              child: Center(
                child: Text(
                  '55.5 - 150.4',style: TextStyle(color: white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 2,),
            Container(
              width: 90,
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  border: Border.all(
                      color: black,
                      width: 1
                  )
              ),
              child: Center(
                child: Text(
                  '150.5 - 250.4',style: TextStyle(color: white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 2,),
            InkWell(
              onTap: (){
//                Utils.showToast('text');
                setState(() {
                  if(showTimer == false){
                    showTimer = true;
                  }else{
                    showTimer = false;
                  }
                });
              },
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                    color: brown,
                    border: Border.all(
                        color: black,
                        width: 1
                    )
                ),
                child: Center(
                  child: Text(
                    '250.5 +',style: TextStyle(color: white,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ) ,
      ),
    );
  }

  Widget buildSearchBar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, right: 20.0, left: 20.0),
      child: InkWell(
        onTap: (){
          //getInforFetchData();
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Icon(Icons.location_on,color: Colors.orangeAccent,size: 20,),
                      SizedBox(width: 4,),
                      Text(
                        'VN',
                        style: TextStyle(fontFamily: "Sans", fontWeight: FontWeight.w600,color: Colors.orangeAccent),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: Container(
                          width: 1,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  flex: 4,
                    child: TypeAheadField<FetchData>(
                      keepSuggestionsOnLoading: true,
                      textFieldConfiguration: TextFieldConfiguration(onTap: (){
                        setState(() {
                          _placeController.text = '';
                        });
                      },
                          style: TextStyle(
                            fontSize: 14,
                            color: black,
                          ),
                          decoration: InputDecoration(
                              //errorText: _bloc.errorPlace,
                              border: UnderlineInputBorder(),
                              labelText: 'Tìm kiếm theo địa chỉ',
                              labelStyle: TextStyle(color: grey),
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: grey,
                              ),
                              contentPadding: EdgeInsets.only(bottom: 15),
                              isDense: true,
                              errorStyle: TextStyle(
                                fontSize: 10,
                                color: red,
                              )),
                          controller: _placeController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          maxLines: 1,
                         // onChanged: (text) => _bloc.add(SetLocationEvent(text)),
                         // onSubmitted: (text) => FocusScope.of(context).unfocus()
                      ),
                      onSuggestionSelected: (FetchData suggestion) {
                        _placeController.text = suggestion.name;
                        moveCamera(double.parse(suggestion.lat), double.parse(suggestion.long));
                      },
                      suggestionsCallback: (String pattern)  {
                        return  getSuggestions(pattern);
                      },
                      itemBuilder: (BuildContext context, FetchData itemData) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                MdiIcons.mapMarkerOutline,
                                color: grey,
                                size: 2,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      itemData.name,
                                      style: TextStyle(fontSize: 14, color: black),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      itemData.address.replaceAll('"', ''),
                                      style: TextStyle(fontSize: 12, color: grey),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      noItemsFoundBuilder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                          child: Text(''),
                        );
                      },
                    ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

   List<FetchData> getSuggestions(String query) {
    List<FetchData> matches = List();
    matches.addAll(fetchData);

     matches.retainWhere((s) => s.name.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Widget _buildPages(BuildContext context, MapSate sate){
    if(allMarkers.length <= 0){
     //setState(() {
       getInformationLocation();
//     });
    }
    return  SafeArea(
      top: true,
      child: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(21.024340, 105.857936), zoom: 12.0),

            onMapCreated: mapCreated,
            markers: Set.from(_mapBloc.allMarkers == null ? currentMarker : allMarkers ),
            onTap: _handleTap,),
          buildSearchBar(context),
          buildLimitPoint(context),
          Visibility(
            visible: showTimer == true,
            child: Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: orangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: red,width: 1.5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      '${_start.toString()} /s',
                      style: TextStyle(fontSize: 8,color: black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
//          Visibility(
//            visible: _start == 10 ,
//            child: PendingAction(),
//          )
        ],
      ),
    );
  }

  _handleTap(LatLng point) {
    setState(() {
      print('tiennq.dev: ' + point.toString());
      getAddress(point);
      //moveCamera(point.latitude, point.longitude);

    });
  }

  moveCamera(double lat, double lng) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng), zoom: 15.0)
    ));
    markers.clear();
    markers.add(Marker(
        markerId: MarkerId('Yours'),
        draggable: false,
        infoWindow: InfoWindow(title: 'Your',),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
    ));
  }

  getAddress(LatLng point) async{
    final coordinates = new Coordinates(point.latitude, point.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    print('tiennq.dev1111: ' + point.latitude.toString() +' --- ' +point.longitude.toString());
    _placeController.text = "";
    _placeController.text = first.addressLine.toString();
    int x = point.latitude.toString().lastIndexOf('.');
    int y = point.longitude.toString().lastIndexOf('.');
    String latFirst = point.latitude.toString().substring(0,(x));
    String latEnd = point.latitude.toString().substring(x,(x+7));
    latComplete = latFirst + latEnd;
    String longFirst = point.longitude.toString().substring(0,(y));
    String longEnd = point.longitude.toString().substring(y,(y+7));
    longComplete = longFirst + longEnd;
    print('long:' + longComplete.toString());
    print('lat:' + latComplete );
    // ignore: unnecessary_statements
    //_bloc.add(PickLocation(location: latComplete + ", " + longComplete));
  }

  Marker currentMarker = Marker(
      markerId: MarkerId('Yours'),
      position: LatLng(21.024340, 105.857936),
      infoWindow: InfoWindow(title: 'You'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
  );

  void mapCreated(mapController) {
    setState(() {
      _mapController = mapController;
    });
//    if(!Utils.isEmpty(_mainBloc.locationDelivery)){
//      moveCamera(double.parse(_mainBloc.locationDelivery.split(',')[0].toString().trim()), double.parse(_mainBloc.locationDelivery.split(',')[1].toString().trim()));
//    }
  }

  void getInforFetchData(){
    //List<FetchData> list;

    Utils.showToast(fetchData.length.toString());
    String x = '';
  }

  void getInformationLocation() async {

    allMarkers.clear();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);


    await for (List<InformationLocationResponse> tasks in _firebaseRepository.getInfoLocation()) {
      tasks.forEach((element) async {
        var userQuery = Firestore.instance.collection('location').document(element.name.toString().trim())
            .collection('dateTime').where('date',isEqualTo: formattedDate).limit(1);
        userQuery.getDocuments().then((value) async{
          if(value.documents.length >0){
            if(fetchData.length > 0){
             var content =  fetchData.where((s) => s.name.toLowerCase().contains(element.name.toLowerCase()));
             if(content.isEmpty){
               fetchData.add(
                   FetchData(
                     name: element.name,
                     address: element.address,
                     lat: element.lat,
                     long: element.long,
                     values: value.documents[0].data['values'].toString().trim(),
                   )
               );
             }
             else{
               print('object');
             }
            }else{
              fetchData.add(
                  FetchData(
                    name: element.name,
                    address: element.address,
                    lat: element.lat,
                    long: element.long,
                    values: value.documents[0].data['values'].toString().trim(),
                  )
              );
            }


            Color color;
            if(double.parse(value.documents[0].data['values'].toString().trim()) <= 12.0){
              color = lime;
            }else if(double.parse(value.documents[0].data['values'].toString().trim()) >= 12.1 && double.parse(value.documents[0].data['values'].toString().trim()) <= 35.4){
              color = yellow;
            }else if(double.parse(value.documents[0].data['values'].toString().trim()) >= 35.5 && double.parse(value.documents[0].data['values'].toString().trim()) <= 55.4){
              color = orange;
            }else if(double.parse(value.documents[0].data['values'].toString().trim()) >= 55.5 && double.parse(value.documents[0].data['values'].toString().trim()) <= 150.4){
              color = red2;
            }else if(double.parse(value.documents[0].data['values'].toString().trim()) >= 150.5 && double.parse(value.documents[0].data['values'].toString().trim()) <= 250.4){
              color = Colors.deepPurple;
            }else if(double.parse(value.documents[0].data['values'].toString().trim()) >= 250.5){
              color = brown;
            }
            final bitmap = await _myPainterToBitmap(element.name,color,value.documents[0].data['values'].toString().trim());
           setState(() {
            // allMarkers.clear();
             //Utils.showToast(allMarkers.length.toString());
//             allMarkers.remo
             allMarkers.add(Marker(
                 markerId: MarkerId(element.name),
                 draggable: false,
                 anchor: Offset(0.5,0.5),
                 infoWindow: InfoWindow(title: element.name,snippet: element.address),
                 position: LatLng(double.parse(element.lat), double.parse(element.long)),
                 icon: BitmapDescriptor.fromBytes(bitmap),
                 onTap: (){
                   //Utils.showToast(formattedDate.toString());
                   print(_querySearchSnapshot);
                   showDialog(
                     //barrierDismissible: false,
                       context: context,
                       builder: (context) => FunkyOverlay(
                         name: element.name,
                         address: element.address,
                         values:value.documents[0].data['values'].toString().trim() ,
                         type: element.type,
                       )
                   );
                 }
             ));
           });
          }
        });
      });
    }
  }
  Future<Uint8List> _myPainterToBitmap(String label,Color color,String values) async{
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    MyPainter myPainter = MyPainter(label,color,values);
    myPainter.paint(canvas, Size(100,100));

    final ui.Image image = await recorder.endRecording().toImage(100, 100);
    final ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();

  }
}

class CitiesService {
  static final List<String> cities = [
    'Hà Nội',
    'Hà Nam',
    'San Fransisco',
    'Hồ Chính Minh',
    'Los Angeles',
    'Hưng yên',
    'Bali',
    'Vĩnh phúc',
    'Paris',
    'tam đảo',
    'New York City',
    'cầu giấy',
    'Sydney',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
