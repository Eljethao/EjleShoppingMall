// ignore_for_file: prefer_const_constructors

import 'package:eljeshoppingmall/bodys/bank.dart';
import 'package:eljeshoppingmall/bodys/credit.dart';
import 'package:eljeshoppingmall/bodys/prompay.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:flutter/material.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({Key? key}) : super(key: key);

  @override
  _AddWalletState createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  List<Widget> widgets = [Bank(), PromPay(), Credit()];
  List<IconData> icons = [
    Icons.account_balance_wallet,
    Icons.book,
    Icons.credit_card
  ];

  List<String> titles = ['Bank', 'Prompay', 'Credit'];

  int indexPosition = 0;

  List<BottomNavigationBarItem> bottomNavigationBarItems = [];

  @override
  void initState() {
    super.initState();

    int i = 0;
    for (var item in titles) {
      bottomNavigationBarItems.add(createBottomNavigationBar(icons[i], item));
      i++;
    }
  }

  BottomNavigationBarItem createBottomNavigationBar(
          IconData iconData, String string) =>
      BottomNavigationBarItem(icon: Icon(iconData), label: string);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Wallet from ${titles[indexPosition]}',
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
      ),
      body: widgets[indexPosition],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexPosition,
        selectedItemColor: MyConstant.dark,
        items: bottomNavigationBarItems,
        onTap: (value) {
          setState(() {
            indexPosition = value;
          });
        },
      ),
    );
  }
}
