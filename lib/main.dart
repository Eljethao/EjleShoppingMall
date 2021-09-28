// ignore_for_file: prefer_const_constructors

import 'package:eljeshoppingmall/states/authen.dart';
import 'package:eljeshoppingmall/states/buyer_service.dart';
import 'package:eljeshoppingmall/states/create_account.dart';
import 'package:eljeshoppingmall/states/rider_service.dart';
import 'package:eljeshoppingmall/states/saler_service.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (context) => Authen(),
  '/createAccount': (context) => CreateAccount(),
  '/buyerService':(context)=> BuyerService(), 
  '/salerService':(context)=> SalerService(), 
  '/riderService':(context)=> RiderService(), 
};

String? initialRoute;

void main(){
  initialRoute = MyConstant.routeAuthen;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
