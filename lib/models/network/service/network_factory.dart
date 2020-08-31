import 'package:app/models/network/response/infor_location.dart';
import 'package:app/models/network/response/values_2pm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseRepository{
  Stream<List<InformationLocationResponse>> getInfoLocation() {
    Stream<QuerySnapshot> stream =
    Firestore.instance.collection("location").snapshots();
//        .where("users",arrayContains: userName).snapshots();

    return stream.map(
            (qShot) => qShot.documents.map(
                (doc) {

                 return InformationLocationResponse(
                    address: doc.data['address'],
                    name: doc.data['name'],
                    lat: doc.data['lat'],
                    long: doc.data['long'],
                    type: doc.data['type'],
                  );
                }

        ).toList()
    );
  }

//  getValueLocation(String id,String date) async{
//    return await Firestore.instance.collection('location').document(id).collection('dateTime').where('date',isEqualTo: date).getDocuments();
//  }
  Stream<List<Values2PMResponse>> getValueLocation(String id,String date) {
    Stream<QuerySnapshot> stream =
    Firestore.instance.collection("location").document(id).collection('dateTime').where('date',isEqualTo: date).snapshots();
//        .where("users",arrayContains: userName).snapshots();

    return stream.map(
            (qShot) => qShot.documents.map(
                (doc) =>//{
                Values2PMResponse(
                  values: doc.data['values'],
                  date: doc.data['date'],
                )
        ).toList()
    );
  }
}