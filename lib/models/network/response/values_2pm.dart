
class Values2PMResponse{
  String date;
  String values;


  Values2PMResponse({this.date,this.values});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['date'] = this.date;
    map['values'] = this.values;

    return map;
  }

  Values2PMResponse.fromMap(Map<String, dynamic> map) {
    this.date = map['date'];
    this.values = map['values'];
   
  }
}