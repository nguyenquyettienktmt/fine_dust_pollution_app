import 'package:app/themes/colors.dart';
import 'package:flutter/material.dart';

class PendingAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
        ModalBarrier(
          dismissible: false,
          color: black.withOpacity(0.3),
        ),
      ],
    );
  }
}
