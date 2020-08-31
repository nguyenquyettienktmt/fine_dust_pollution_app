
import 'package:app/pages/favourite/favourite_bloc.dart';
import 'package:app/pages/favourite/favourite_page.dart';
import 'package:app/pages/information/infor_bloc.dart';
import 'package:app/pages/information/infor_page.dart';
import 'package:app/pages/map/map_bloc.dart';
import 'package:app/pages/map/map_page.dart';
import 'package:app/pages/warning/warning_bloc.dart';
import 'package:app/pages/warning/warning_page.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/const.dart';
import 'package:app/widgets/custom_tab_bar.dart';
import 'package:app/widgets/custom_tab_scaffold.dart';
import 'package:app/widgets/custom_tab_view.dart';
import 'package:app/widgets/pending_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'main_bloc.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MainBloc _mainBloc;
  MapBloc _mapBloc;
  FavouriteBloc _favouriteBloc;
  WarningBloc _warningBloc;
  InforBloc _inforBloc;
  int _lastIndexToShop = 0;
  int _currentIndex = 0;
  GlobalKey<NavigatorState> _currentTabKey;
  List<BottomNavigationBarItem> listBottomItems = List();

  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();


  @override
  void initState() {
    // TODO: implement initState
    _mainBloc = MainBloc();
    _mapBloc = MapBloc();
    _favouriteBloc = FavouriteBloc();
    _warningBloc = WarningBloc();
    _inforBloc = InforBloc();
    _currentTabKey = firstTabNavKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        bool isSuccess = await _currentTabKey.currentState.maybePop();
        if (!isSuccess && _currentIndex != Const.HOME) {
          _lastIndexToShop = Const.HOME;
          _mainBloc.add(NavigateBottomNavigation(Const.HOME));
          _currentIndex = _lastIndexToShop;
          _currentTabKey = firstTabNavKey;
        }
        //if (!isSuccess) _exitApp(context);
        return false;
      },
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<MainBloc>(
              create: (context) {
                if (_mainBloc == null) _mainBloc = MainBloc();
                return _mainBloc;
              },
            ),
            BlocProvider<MapBloc>(
              create: (context) {
                if (_mapBloc == null) _mapBloc = MapBloc();
                return _mapBloc;
              },
            ),
            BlocProvider<FavouriteBloc>(
              create: (context) {
                if (_favouriteBloc == null) _favouriteBloc = FavouriteBloc();
                return _favouriteBloc;
              },
            ),
            BlocProvider<WarningBloc>(
              create: (context) {
                if (_warningBloc == null) _warningBloc = WarningBloc();
                return _warningBloc;
              },
            ),
            BlocProvider<InforBloc>(
              create: (context) {
                if (_inforBloc == null) _inforBloc = InforBloc();
                return _inforBloc;
              },
            ),
          ],
          child:  BlocListener<MainBloc, MainState>(
            bloc: _mainBloc,
              listener: (context, state) {
//              if (state is LogoutFailure){
//
//              }
            },
            child: BlocBuilder<MainBloc, MainState>(
              bloc: _mainBloc,
              builder: (context, state) {
                if (state is MainPageState) {
                  _currentIndex = state.position;
                  if (_currentIndex == Const.SHOP) {
                    //_shoppingCartBloc.add(GetProductList());
                  }
                  if (_currentIndex == Const.PROMO) {
                   // _promoBloc.add(GetListPromotion(isRefresh: true));
                  }
                  //if(_currentIndex == Const.ORDER){
//                    _orderBloc.add(GetListOrder(
//                      DateFormat("dd/MM/yyyy").format(DateTime.now()).toString(),
//                      DateFormat("dd/MM/yyyy").format(DateTime.now()).toString(),
//                      isRefresh: true,
//                    ));
                 // }
                }
               // _mainBloc.init(context);
                return Stack(children: <Widget>[
                  /*_mainBloc.countNotiUnRead == null
                          ? Container()
                          : */CustomTabScaffold(
                      tabBar: CustomTabBar(
                        activeColor: Colors.redAccent,
                        inactiveColor: Colors.black,
                        onTap: (pos) {
                          switch (pos) {
                            case 0:
                              _currentTabKey = firstTabNavKey;
                              break;
                            case 1:
                              _currentTabKey = secondTabNavKey;
                              break;
                            case 2:
                              _lastIndexToShop = _currentIndex;
                              _currentTabKey = thirdTabNavKey;
                              break;
                            case 3:
                              _currentTabKey = fourthTabNavKey;
                              break;
                          }
                          if (_currentIndex == pos) {
                            _currentTabKey.currentState
                                .popUntil((r) => r.isFirst);
                          } else
                            _mainBloc
                                .add(NavigateBottomNavigation(pos));
                        },
                        currentIndex: _currentIndex,
                        items: listBottomBar(),
                      ),
                      tabBuilder: (BuildContext context, int index) {
                        Widget newWidget;
                        GlobalKey key;
                        switch (index) {
                          case 0:
                            key = firstTabNavKey;
                            newWidget = MapPage();
                            break;
                          case 1:
                            key = secondTabNavKey;
                            newWidget = FavouritePage();
                            break;
                          case 2:
                            key = thirdTabNavKey;
                            newWidget = WarningPage();
                            break;
                          case 3:
                            key = fourthTabNavKey;
                            newWidget = InformationPage();
                            break;
                        }
                        return CustomTabView(
                          navigatorKey: key,
                          builder: (BuildContext context) {
                            return newWidget;
                          },
//                              defaultTitle: title,
                        );
                      }),
                  Visibility(
                    visible: state is MainLoading,
                    child: PendingAction(),
                  )
                ]);
              }
            ),
          ),
        ),
      ),
    );
  }
  List<BottomNavigationBarItem> listBottomBar() {
    return [
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.mapLegend,
          color: _currentIndex == Const.HOME ? primaryColor : grey,
        ),
        title: Text(
          'Map',
          style: TextStyle(
              color: _currentIndex == Const.HOME ? primaryColor : grey,
              fontSize: 10),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.heartPulse,
          color: _currentIndex == Const.SHOP ? primaryColor : grey,
        ),
        title: Text(
          'Favourite',
          style: TextStyle(
              color: _currentIndex == Const.SHOP ? primaryColor : grey,
              fontSize: 10),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.bellOutline,
          color: _currentIndex == Const.USER ? primaryColor : grey,
        ),
        title: Text(
          'Warning',
          style: TextStyle(
              color: _currentIndex == Const.USER ? primaryColor : grey,
              fontSize: 10),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          MdiIcons.informationOutline,
          color: _currentIndex == Const.PROMO ? primaryColor : grey,
        ),
        title: Text(
          'Information',
          style: TextStyle(
              color: _currentIndex == Const.PROMO ? primaryColor : grey,
              fontSize: 10),
        ),
      ),

    ];
  }
}
