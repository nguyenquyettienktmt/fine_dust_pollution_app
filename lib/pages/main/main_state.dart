import 'package:equatable/equatable.dart';
abstract class MainState extends Equatable {
  @override
  List<Object> get props => [];
}
class InitialMainState extends MainState {

  @override
  String toString() {
    return 'InitialMainState{}';
  }
}

class MainPageState extends MainState {
  final int position;

  MainPageState(this.position);

  @override
  String toString() => 'MainPageState';
}
class MainFailure extends MainState {
  final String error;

  MainFailure(this.error);

  @override
  String toString() {
    return 'MainFail{error: $error}';
  }
}
class MainLoading extends MainState {
  @override
  String toString() => "MainLoading";
}