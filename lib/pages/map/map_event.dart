import 'package:equatable/equatable.dart';
abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInfoLocationEvent extends MapEvent {
  @override
  String toString() {
    return 'GetInfoLocationEvent{}';
  }
}