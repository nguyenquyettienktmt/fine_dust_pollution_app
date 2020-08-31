import 'package:equatable/equatable.dart';
abstract class InforSate extends Equatable {
  @override
  List<Object> get props => [];
}
class InitialInforSate  extends InforSate {

  @override
  String toString() {
    return 'InitialMainState{}';
  }
}

