// ignore_for_file: avoid_print, sized_box_for_whitespace, prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eljeshoppingmall/models/sqlite_model.dart';
import 'package:eljeshoppingmall/models/user_model.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/utility/sqlite_helper.dart';
import 'package:eljeshoppingmall/widgets/show_image.dart';
import 'package:eljeshoppingmall/widgets/show_progress.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModel;
  int? total;
  String? totalStr;
  final value = new NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    processReadSQLite();
  }

  Future<void> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }

    await SqLiteHelper().readSQLite().then((value) {
      // print('### value on processReadSQLite ===>> $value');
      setState(() {
        load = false;
        sqliteModels = value;
        findDetailSeller();

        calculateTotal();
      });
    });
  }

  void calculateTotal() async {
    total = 0;
    for (var item in sqliteModels) {
      int sumInt = int.parse(item.sum.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
    setState(() {
      totalStr = value.format(total);
    });
  }

  Future<void> findDetailSeller() async {
    String idSeller = sqliteModels[0].idSeller;
    print('idSeller ==>> $idSeller');
    String apiGetUserWhereId =
        '${MyConstant.domain}/eljeshoppingmall/getUserWhereId.php?isAdd=true&id=$idSeller';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Cart'),
      ),
      body: load
          ? const ShowProgress()
          : sqliteModels.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: 150,
                        child: ShowImage(pathImage: MyConstant.empty),
                      ),
                      ShowTitle(
                          title: 'ບໍມີເຄື່ອງໃນກະຕ່າ',
                          textStyle: MyConstant().h1Style()),
                    ],
                  ),
                )
              : buildContent(),
    );
  }

  Column buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showSeller(),
        buildHead(),
        listProduct(),
        Divider(color: MyConstant.dark),
        buildTotal(),
        Divider(color: MyConstant.dark),
        buttonController(),
      ],
    );
  }

  Row buttonController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, MyConstant.routeAddWallet);
            },
            child: const Text('Order'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red.shade400),
            onPressed: () => confirmEmptyCart(),
            child: const Text('Clear Cart'),
          ),
        ),
      ],
    );
  }

  Future<void> confirmEmptyCart() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: ShowImage(pathImage: MyConstant.question),
                title: ShowTitle(
                  title: 'ທ່ານຕ້ອງການຈະລຶບ ຫຼື ບໍ?',
                  textStyle: MyConstant().h2BlueStyle(),
                ),
                subtitle: ShowTitle(
                  title: 'ທ່ານຕ້ອງຈະລຶບສິນຄ້າທີ່ສັ່ງຊື້ທັງໝົດ ຫຼື ບໍ?',
                  textStyle: MyConstant().h3Style(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await SqLiteHelper().emptySQLite().then((value) {
                      Navigator.pop(context);
                      processReadSQLite();
                    });
                  },
                  child: Text('Delete'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ));
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowTitle(
                title: 'Total: ',
                textStyle: MyConstant().h2BlueStyle(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ShowTitle(
            title: total == null ? '' : totalStr.toString(),
            textStyle: MyConstant().h1Style(),
          ),
        ),
      ],
    );
  }

  ListView listProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ShowTitle(
                title: sqliteModels[index].name,
                textStyle: MyConstant().h3Style(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: sqliteModels[index].price,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: sqliteModels[index].amount,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: sqliteModels[index].sum,
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                int idSQLite = sqliteModels[index].id!;
                print('### Click delete id ==>> $idSQLite');
                await SqLiteHelper()
                    .deleteSQLiteWhereId(idSQLite)
                    .then((value) => processReadSQLite());
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Colors.red.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(
        color: MyConstant.light,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ShowTitle(
                  title: 'Product',
                  textStyle: MyConstant().h2Style(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Price',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Qty',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Sum',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Padding showSeller() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: userModel == null ? '' : userModel!.name,
        textStyle: MyConstant().h1Style(),
      ),
    );
  }
}
