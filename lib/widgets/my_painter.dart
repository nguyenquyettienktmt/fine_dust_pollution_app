
import 'package:app/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyPainter extends CustomPaint{
  final String label;
  final Color color;
  final String values;
  MyPainter(this.label,this.color,this.values);




  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint();

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(10));

    paint.color =  color;
    canvas.drawCircle(Offset(50,size.height /2 ),50,paint);

   // paint.color = Colors.green;

    //canvas.drawCircle(Offset(20,size.height /2 ), 10, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: values.toString().trim(),
        style: TextStyle(fontSize: 18,color: black,fontWeight: FontWeight.bold)
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr
    );

    textPainter.layout(minWidth: 0,maxWidth: size.width-50);
    textPainter.paint(canvas, Offset(25,size.height/2 - textPainter.size.height /2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}