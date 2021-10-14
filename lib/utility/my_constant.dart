import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyConstant {
  //General
  static String appName = 'Shopping Mall';
  static String domain = 'http://c392-115-84-119-87.ngrok.io';

  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSalerService = '/salerService';
  static String routeRiderService = '/riderService';
  static String routeAddProduct = '/addProduct';

  //Image
  static String image1 = 'images/Image1.png';
  static String image2 = 'images/Image2.png';
  static String image3 = 'images/Image3.png';
  static String image4 = 'images/Image4.png';
  static String image5 = 'images/Image5.png';
  static String account = 'images/account.png';

  //Color
  static Color primary =const Color(0xff87861d);
  static Color dark =const Color(0xff575900);
  static Color light = const Color(0xffb9b64e);
  static Map<int,Color> mapMaterialColor = {
    50:const Color.fromRGBO(255, 87, 89, 0.1),
    100:const Color.fromRGBO(255, 87, 89, 0.2),
    200:const Color.fromRGBO(255, 87, 89, 0.3),
    300:const Color.fromRGBO(255, 87, 89, 0.4),
    400:const Color.fromRGBO(255, 87, 89, 0.5),
    500:const Color.fromRGBO(255, 87, 89, 0.6),
    600:const Color.fromRGBO(255, 87, 89, 0.7),
    700:const Color.fromRGBO(255, 87, 89, 0.8),
    800:const Color.fromRGBO(255, 87, 89, 0.9),
    900:const Color.fromRGBO(255, 87, 89, 1.0),

  };

  //Style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );

  TextStyle h2WhiteStyle() => const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );

  TextStyle h3WhiteStyle() => const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
      primary: MyConstant.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ));
}
