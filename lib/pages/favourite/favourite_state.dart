import 'package:equatable/equatable.dart';
abstract class FavouriteSate extends Equatable {
  @override
  List<Object> get props => [];
}
class InitialFavouriteSate extends FavouriteSate {

  @override
  String toString() {
    return 'InitialMainState{}';
  }
}

