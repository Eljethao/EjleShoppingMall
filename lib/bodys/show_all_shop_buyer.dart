import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:eljeshoppingmall/bodys/show_middle_shop.dart';
import 'package:eljeshoppingmall/models/user_model.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/widgets/show_image.dart';
import 'package:eljeshoppingmall/widgets/show_progress.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';

class ShowAllShopBuyer extends StatefulWidget {
  const ShowAllShopBuyer({Key? key}) : super(key: key);

  @override
  _ShowAllShopBuyerState createState() => _ShowAllShopBuyerState();
}

class _ShowAllShopBuyerState extends State<ShowAllShopBuyer> {
  bool load = true;
  List<UserModel> userModels = [];

  @override
  void initState() {
    super.initState();
    readApiAllShop();
  }

//thread for read all shop to show to user
  Future<void> readApiAllShop() async {
    String urlAPI =
        '${MyConstant.domain}/eljeshoppingmall/getUserWhereSeller.php';
    await Dio().get(urlAPI).then((value) {
      setState(() {
        load = false;
      });
      //print('value ==>> $value');
      var result = json.decode(value.data);
      // print('result ==>> $result');
      for (var item in result) {
        UserModel model = UserModel.fromMap(item);

        //print('nameShop ==>> ${model.name}');
        setState(() {
          userModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 2 / 3,
                maxCrossAxisExtent: 160,
              ),
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      print('You Click from ${userModels[index].name}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShowMiddleShop(userModel: userModels[index]),
                              //ShowProductBuyer
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      ShowImage(pathImage: MyConstant.account),
                                  placeholder: (context, url) =>
                                      const ShowProgress(),
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '${MyConstant.domain}${userModels[index].avatar}'),
                            ),
                            ShowTitle(
                              title: cutWord(userModels[index].name),
                              textStyle: MyConstant().h3Style(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              itemCount: userModels.length),
    );
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 14) {
      result = result.substring(0, 10);
      result = '$result ...';
    }
    return result;
  }
}
