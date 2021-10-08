// ignore_for_file: prefer_const_constructors

import 'package:eljeshoppingmall/bodys/shop_manage_seller.dart';
import 'package:eljeshoppingmall/bodys/show_order_seller.dart';
import 'package:eljeshoppingmall/bodys/show_product_seller.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/widgets/show_signout.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';

class SalerService extends StatefulWidget {
  const SalerService({Key? key}) : super(key: key);

  @override
  _SalerServiceState createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  List<Widget> widgets = [
    ShowOrderSeller(),
    ShopManageSeller(),
    ShowProductSeller(),
  ];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                UserAccountsDrawerHeader(
                  accountName: null,
                  accountEmail: null,
                ),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduct(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(
        title: 'Show Order',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງລາຍລະອຽດຂອງສິນຄ້າທີ່ເຮົາຂາຍ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuShopManage() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2),
      title: ShowTitle(
        title: 'Shop Manage',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງລາຍລະອຽດຂອງໜ້າຮ້ານທີ່ໃຫ້ລູກຄ້າເຫັນ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_3),
      title: ShowTitle(
        title: 'Show Product',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'ສະແດງລາຍລະອຽດຂອງ Order ທີ່ສັ່ງ',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
