// ignore_for_file: prefer_const_constructors

import 'package:eljeshoppingmall/bodys/my_money_buyer.dart';
import 'package:eljeshoppingmall/bodys/my_order_buyer.dart';
import 'package:eljeshoppingmall/bodys/show_all_shop_buyer.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/widgets/show_signout.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  _BuyerServiceState createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  List<Widget> widgets = [
    ShowAllShopBuyer(),
    MyMoney(),
    MyOrderBuyer(),
  ];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeShowCart),
            icon: Icon(Icons.shopping_cart_outlined),
          ),
        ],
        title: Text('Buyer',style: TextStyle(fontFamily: 'NotoSansLao',fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildHead(),
                menuShowAllShop(),
                menuMyMoney(),
                menuMyOrder(),
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowAllShop() {
    return ListTile(
      leading: Icon(
        Icons.shopping_bag_outlined,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'Show all shop',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງຮ້ານຄ້າທັງຫມົດ',
        textStyle: MyConstant().h3Style(),
      ),
      onTap: () {
        setState(() {
          Navigator.pop(context);
          indexWidget = 0;
        });
      },
    );
  }

  ListTile menuMyMoney() {
    return ListTile(
      leading: Icon(
        Icons.paid_outlined,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'My Money',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງຈຳນວນເງີນທີ່ມີ',
        textStyle: MyConstant().h3Style(),
      ),
      onTap: () {
        setState(() {
          Navigator.pop(context);
          indexWidget = 1;
        });
      },
    );
  }

  ListTile menuMyOrder() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'My Order',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງລາຍການສັ່ງຊື້',
        textStyle: MyConstant().h3Style(),
      ),
      onTap: () {
        setState(() {
          Navigator.pop(context);
          indexWidget = 2;
        });
      },
    );
  }

  UserAccountsDrawerHeader buildHead() =>
      UserAccountsDrawerHeader(accountName: null, accountEmail: null);
}
