
import 'package:app/models/network/service/network_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:intl/intl.dart';

import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapSate> {

  FirebaseRepository _firebaseRepository = FirebaseRepository();
  List<Marker> allMarkers = [];
  Set<Marker> listMarkers = Set();
  BuildContext context;
  QuerySnapshot _querySearchSnapshot;

  init(BuildContext context) {
    this.context = context;
  }

  @override
  // TODO: implement initialState
  MapSate get initialState => InitialMapState();

  @override
  Stream<MapSate> mapEventToState(MapEvent event) async* {
    if(event is GetInfoLocationEvent){
      //getInformationLocation();
      yield GetInfoLocationState();
    }
  }




}