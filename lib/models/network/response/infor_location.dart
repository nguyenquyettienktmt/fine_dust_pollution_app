
class InformationLocationResponse{
  String address;
  String name;
  String lat;
  String long;
  String type;

  InformationLocationResponse({this.address,this.name,this.lat,this.long,this.type});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['address'] = this.address;
    map['name'] = this.name;
    map['lat'] = this.lat;
    map['long'] = this.long;
    map['type'] = this.type;
    return map;
  }

  InformationLocationResponse.fromMap(Map<String, dynamic> map) {
    this.address = map['address'];
    this.name = map['name'];
    this.lat = map['lat'];
    this.long = map['long'];
    this.type = map['type'];
  }


}