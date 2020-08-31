
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favourite_event.dart';
import 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteSate> {
  @override
  // TODO: implement initialState
  FavouriteSate get initialState => InitialFavouriteSate();

  @override
  Stream<FavouriteSate> mapEventToState(FavouriteEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }


}