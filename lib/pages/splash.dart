
import 'package:app/themes/colors.dart';
import 'package:flutter/material.dart';

import 'main/main_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startApp();
  }

  _startApp() {
    Future.delayed(
      Duration(seconds: 3),
      () async {
//        var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
//        if (token != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MainPage()));
          return;
//        }
//        Navigator.pushReplacementNamed(context, '/wrapper');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/Image/thm.jpg'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Bản đồ thực trạng ô nhiễm bụi mịn'.toUpperCase(),
                  style: TextStyle(fontSize: 16, color: primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
