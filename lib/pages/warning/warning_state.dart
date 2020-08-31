import 'package:equatable/equatable.dart';
abstract class WarningSate extends Equatable {
  @override
  List<Object> get props => [];
}
class InitialWarningSate extends WarningSate {

  @override
  String toString() {
    return 'InitialMainState{}';
  }
}

