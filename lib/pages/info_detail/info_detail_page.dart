
import 'package:app/themes/colors.dart';
import 'package:app/utils/teddy_controller_fail.dart';
import 'package:app/utils/teddy_controller_normal.dart';
import 'package:app/utils/teddy_controller_success.dart';
import 'package:app/utils/teddy_controller_test.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//class InfoDetailPage extends StatefulWidget {
class FunkyOverlay extends StatefulWidget {
  final String name;
  final String address;
  final String values;
  final String type;

  const FunkyOverlay({Key key, this.name, this.address, this.values,this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  TeddyControllerSuccess _teddyControllerSuccess ;
  TeddyControllerFail _teddyControllerFail;
  TeddyControllerNormal _teddyControllerNormal;
  TeddyControllerTest _teddyControllerTest;

  @override
  void initState() {
    super.initState();
    _teddyControllerSuccess = new TeddyControllerSuccess();
    _teddyControllerFail = new TeddyControllerFail();
    _teddyControllerNormal = new TeddyControllerNormal();
    _teddyControllerTest = new TeddyControllerTest();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutCirc);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
//    if(double.parse(widget.values.toString().trim()) <= 55.4){
//      setState(() {
//        Utils.showToast('cười lên dm');
//        _teddyControllerSuccess.play("success");
//      });
//    }
  }

  @override
  Widget build(BuildContext context) {

    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 260,
            height: 280,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 16, top: 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.flare, color: orange, size: 18,),
                          SizedBox(width: 4,),
                          Center(
                            child: Text(
                              widget.name.toString().trim(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              // textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.loyalty, size: 18,color: Colors.pink,),
                          SizedBox(width: 4,),
                          Expanded(
                            child: Text(
                              widget.type.toString()?? 'N/A',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.type.toString() != '' ? pink :grey ,
                                fontSize: 11,),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.add_location, size: 18,color: grey,),
                          SizedBox(width: 4,),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.address.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                // textAlign: TextAlign.center,
                                style: TextStyle(color: grey, fontSize: 11,),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Divider(
                              height: 2,
                              color: grey,
                            ),
                          ),
                          Text(
                            ' Chỉ số PM 2.5 ',
                            style: TextStyle(fontSize: 10, color: grey),
                          ),
                          Expanded(
                            child: Divider(
                              height: 1,
                              color: grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                                height: 150,
                                child: FlareActor(
                                  "assets/Teddy.flr",
                                  shouldClip: false,
                                  alignment: Alignment.bottomCenter,
                                  fit: BoxFit.fill,
                                  controller:
                                  double.parse(widget.values) <= 12 ?
                                  _teddyControllerSuccess :
                                  (double.parse(widget.values) >= 12.1 && double.parse(widget.values) <= 35.4) ?
                                      _teddyControllerNormal :
                                  (double.parse(widget.values) >= 35.4) ?
                                      _teddyControllerFail : _teddyControllerTest
                                ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Chỉ số: ',
                                        style: TextStyle(fontSize: 11,color: red),
                                      ),
                                     // SizedBox(width: 3,),
                                      Text(
                                        widget.values,
                                        style: TextStyle(fontSize: 11,color: red),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Divider(color: blueAccent,height: 1,),
                                  SizedBox(height: 8,),
                                  buildMDAT(context),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child:  Row(
                      children: [
                        Text(
                          'Số liệu lúc: ',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 8,fontStyle: FontStyle.italic),
                        ),
                        Text(
                          formattedDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 8,fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget buildMDAT (BuildContext context){
    return Center(
      child: Text(
        double.parse(widget.values) <= 12 ?
        'Tốt' :
        (double.parse(widget.values) >= 12.1 && double.parse(widget.values) <= 35.4) ?
        'Trung bình' :
        (double.parse(widget.values) >= 35.5 && double.parse(widget.values) <= 55.4) ?
        'Không tốt cho các nhóm người nhạy cảm' :
        (double.parse(widget.values) >=  55.5 && double.parse(widget.values) <=  150.4)?
        'Không tốt cho sức khoẻ' :
        (double.parse(widget.values) >= 150.5 && double.parse(widget.values) <= 250.4) ?
        'Rất không tốt cho sức khoẻ' :
        double.parse(widget.values) > 250.4 ?
        'Nguy hiểm' : 'Chưa xác định',
        style: TextStyle(fontSize: 11,color: red), textAlign: TextAlign.center,
      ),
    );
  }
}