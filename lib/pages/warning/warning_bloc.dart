import 'package:app/pages/warning/warning_event.dart';
import 'package:app/pages/warning/warning_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class WarningBloc extends Bloc<WarningEvent, WarningSate> {
  @override
  // TODO: implement initialState
  WarningSate get initialState => InitialWarningSate();

  @override
  Stream<WarningSate> mapEventToState(WarningEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

}