
import 'package:flutter_bloc/flutter_bloc.dart';

import 'infor_event.dart';
import 'infor_state.dart';

class InforBloc extends Bloc<InforEvent, InforSate> {
  @override
  // TODO: implement initialState
  InforSate get initialState => InitialInforSate();

  @override
  Stream<InforSate> mapEventToState(InforEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

}