// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:eljeshoppingmall/models/user_model.dart';
import 'package:eljeshoppingmall/states/about_shop.dart';
import 'package:eljeshoppingmall/states/show_product_buyer.dart';
import 'package:eljeshoppingmall/widgets/show_progress.dart';
import 'package:flutter/material.dart';

class ShowMiddleShop extends StatefulWidget {
  final UserModel userModel;
  const ShowMiddleShop({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowMiddleShopState createState() => _ShowMiddleShopState();
}

class _ShowMiddleShopState extends State<ShowMiddleShop> {
  UserModel? userModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(
      AboutShop(userModel: userModel!),
    );
    listWidgets.add(
      ShowProductBuyer(userModel: userModel!),
    );
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.info_rounded),
      label: 'ລາຍລະອຽດຮ້ານ',
    );
  }

  BottomNavigationBarItem showProductNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.ballot_rounded), label: 'ລາຍການສິນຄ້າ',);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name),
      ),
      body: listWidgets.length == 0 ? ShowProgress() : listWidgets[indexPage],
      bottomNavigationBar: showBottomNav(),
    );
  }

  BottomNavigationBar showBottomNav() => BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutShopNav(),
          showProductNav(),
        ],
      );
}
