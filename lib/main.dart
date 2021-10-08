// ignore_for_file: prefer_const_constructors

import 'package:eljeshoppingmall/states/add_product.dart';
import 'package:eljeshoppingmall/states/authen.dart';
import 'package:eljeshoppingmall/states/buyer_service.dart';
import 'package:eljeshoppingmall/states/create_account.dart';
import 'package:eljeshoppingmall/states/rider_service.dart';
import 'package:eljeshoppingmall/states/saler_service.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (context) => Authen(),
  '/createAccount': (context) => CreateAccount(),
  '/buyerService': (context) => BuyerService(),
  '/salerService': (context) => SalerService(),
  '/riderService': (context) => RiderService(),
  '/addProduct': (context)=> AddProduct(),
};

String? initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('type ==> $type');
  if (type?.isEmpty ?? true) {
    initialRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'buyer':
        initialRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'seller':
        initialRoute = MyConstant.routeSalerService;
        runApp(MyApp());
        break;
      case 'rider':
      initialRoute = MyConstant.routeRiderService;
      runApp(MyApp());
      break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor = MaterialColor(0xff575900, MyConstant.mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(
        primarySwatch: materialColor,
      )
    );
  }
}
