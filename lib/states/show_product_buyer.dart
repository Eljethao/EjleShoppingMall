// ignore_for_file: prefer_const_constructors, avoid_print, sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:eljeshoppingmall/models/product_model.dart';
import 'package:eljeshoppingmall/models/sqlite_model.dart';
import 'package:eljeshoppingmall/models/user_model.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/utility/my_dialog.dart';
import 'package:eljeshoppingmall/utility/sqlite_helper.dart';
import 'package:eljeshoppingmall/widgets/show_image.dart';
import 'package:eljeshoppingmall/widgets/show_progress.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModel;
  const ShowProductBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowProductBuyerState createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModel;
  bool load = true;
  bool? haveProduct;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;
  int amountInt = 1;
  String? currentIdSeller;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readAPI();
    readCart();
  }

  Future<void> readCart() async {
    await SqLiteHelper().readSQLite().then((value) {
      if (value.length != 0) {
        List<SQLiteModel> models = [];
        for (var model in value) {
          models.add(model);
        }
        currentIdSeller = models[0].idSeller;
        print('### currentIdSeller = $currentIdSeller');
      }
    });
  }

  Future<void> readAPI() async {
    String urlAPI =
        '${MyConstant.domain}/eljeshoppingmall/getProductWhereidSeller.php?isAdd=true&idSeller=${userModel!.id}';
    await Dio().get(urlAPI).then((value) {
      print('### value = $value');

      if (value.toString() == 'null') {
        setState(() {
          haveProduct = false;
          load = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);

          String string = model.images;
          string = string.substring(1, string.length - 1);
          List<String> strings = string.split(',');
          int i = 0;
          for (var item in strings) {
            strings[i] = item.trim();
            i++;
          }
          listImages.add(strings);

          setState(() {
            haveProduct = true;
            load = false;
            productModels.add(model);
          });
        }
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(userModel!.name),
    //   ),
    //   body: 
          return load
          ? const ShowProgress()
          : haveProduct!
              ? listProduct()
              : Center(
                  child: ShowTitle(
                    title: 'ຍັງບໍມີຂໍ້ມູນສິນຄ້າ',
                    textStyle: MyConstant().h1Style(),
                  ),
                );
    //);
  }

  LayoutBuilder listProduct() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            print('You Click Index ==>> $index');
            showAlertDialog(
              productModels[index],
              listImages[index],
            );
          },
          child: Card(
            child: Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.5 - 8,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            ShowImage(pathImage: MyConstant.image1),
                        placeholder: (context, url) => const ShowProgress(),
                        imageUrl: findUrlImage(productModels[index].images)),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.5,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTitle(
                          title: productModels[index].name,
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title: '${productModels[index].price} Kip',
                          textStyle: MyConstant().h3Style(),
                        ),
                        ShowTitle(
                          title:
                              cutWord('Detail ${productModels[index].detail}'),
                          textStyle: MyConstant().h3Style(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String findUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/eljeshoppingmall/${strings[0]}';
    return result;
  }

  Future<void> showAlertDialog(
      ProductModel productModel, List<String> images) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: ListTile(
            leading: ShowImage(pathImage: MyConstant.image2),
            title: ShowTitle(
              title: productModel.name,
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: ShowTitle(
              title: 'Price: ${productModel.price} Kip',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      '${MyConstant.domain}/eljeshoppingmall${images[indexImage]}',
                  placeholder: (context, url) => const ShowProgress(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexImage = 0;
                            print('### indexImage = $indexImage');
                          });
                        },
                        icon: const Icon(Icons.filter_1),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexImage = 1;
                            print('### indexImage = $indexImage');
                          });
                        },
                        icon: const Icon(Icons.filter_2),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexImage = 2;
                            print('### indexImage = $indexImage');
                          });
                        },
                        icon: const Icon(Icons.filter_3),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexImage = 3;
                            print('### indexImage = $indexImage');
                          });
                        },
                        icon: const Icon(Icons.filter_4),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ShowTitle(
                        title: 'ລາຍລະອຽດ:', textStyle: MyConstant().h2Style()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ShowTitle(
                            title: productModel.detail,
                            textStyle: MyConstant().h3Style()),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (amountInt != 1) {
                          setState(() {
                            amountInt--;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: MyConstant.dark,
                      ),
                    ),
                    ShowTitle(
                        title: amountInt.toString(),
                        textStyle: MyConstant().h1Style()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          amountInt++;
                        });
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: MyConstant.dark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    String idSeller = userModel!.id;
                    String idProduct = productModel.id;
                    String name = productModel.name;
                    String price = productModel.price;
                    String amount = amountInt.toString();
                    int sumInt = int.parse(price) * amountInt;
                    String sum = sumInt.toString();
                    if (currentIdSeller == idSeller ||
                        currentIdSeller == null) {
                      print(
                          '### idSeller ==>> $idSeller, idProduct ==>> $idProduct, name = $name, price = $price, amount = $amount, sum = $sum');
                      SQLiteModel sqLiteModel = SQLiteModel(
                          idSeller: idSeller,
                          idProduct: idProduct,
                          name: name,
                          price: price,
                          amount: amount,
                          sum: sum);
                      await SqLiteHelper()
                          .insertValueToSQLite(sqLiteModel)
                          .then((value) {
                        Navigator.pop(context);
                        amountInt = 1;
                      });
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      MyDialog().normalDialog(context, 'ຜິດຮ້ານ!!',
                          'ກະລຸນາສັ່ງຊື້ຈາກຮ້ານກ່ອນຫນ້ານີ້ ໃຫ້ສຳເລັດກ່ອນ');
                    }
                  },
                  child: Text('Add to Cart', style: MyConstant().h2BlueStyle()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: MyConstant().h2RedStyle()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String cutWord(String string) {
    String result = string;
    if (result.length >= 100) {
      result = result.substring(0, 70);
      result = '$result...';
    }
    return result;
  }
}
