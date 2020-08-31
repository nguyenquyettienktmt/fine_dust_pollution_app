import 'package:equatable/equatable.dart';
abstract class MapSate extends Equatable {
  @override
  List<Object> get props => [];
}
class InitialMapState extends MapSate {

  @override
  String toString() {
    return 'InitialMainState{}';
  }
}

class GetInfoLocationState extends MapSate{
  @override
  String toString() {
    // TODO: implement toString
    return 'GetInfoLocationState{}';
  }
}

