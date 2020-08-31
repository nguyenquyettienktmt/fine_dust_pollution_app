
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int _prePosition = 0;
  @override
  // TODO: implement initialState
  MainState get initialState => InitialMainState();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async*{
    // TODO: implement mapEventToState
    if (event is NavigateBottomNavigation) {
      int position = event.position;
      if (state is MainPageState) {
        if (_prePosition == position) return;
      }
      _prePosition = position;
      yield MainLoading();
      yield MainPageState(position);
    }
  }
}