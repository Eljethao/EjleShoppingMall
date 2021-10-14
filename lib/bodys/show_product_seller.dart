// ignore_for_file: avoid_print, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:eljeshoppingmall/models/product_model.dart';
import 'package:eljeshoppingmall/states/edit_product.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/widgets/show_image.dart';
import 'package:eljeshoppingmall/widgets/show_progress.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  _ShowProductSellerState createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveData;
  List<ProductModel> productModels = [];

  @override
  void initState() {
    super.initState();
    loadValueFromAPI();
  }

  Future<void> loadValueFromAPI() async {
    if (productModels.length != 0) {
      productModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idSeller = preferences.getString('id')!;

    String apiGetProductWhereIdSell =
        '${MyConstant.domain}/eljeshoppingmall/getProductWhereidSeller.php?isAdd=true&idSeller=$idSeller';
    await Dio().get(apiGetProductWhereIdSell).then((value) {
      //print('value ==>> $value');

      if (value.toString() == 'null') {
        //don't have data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // have data
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('### ProductName ==> ${model.name}');

          setState(() {
            load = false;
            haveData = true;
            productModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'ຍັງບໍມີຂໍ້ມູນ',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTitle(
                        title: 'ກະລຸນາເພີ່ມຂໍ້ມູນກ່ອນ',
                        textStyle: MyConstant().h2Style(),
                      )
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct)
                .then((value) => loadValueFromAPI()),
        child: const Text('Add'),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/eljeshoppingmall${strings[0]}';
    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowTitle(
                    title: productModels[index].name,
                    textStyle: MyConstant().h2Style(),
                  ),
                  Container(
                    height: constraints.maxWidth * 0.4,
                    width: constraints.maxWidth * 0.5,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: createUrl(productModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(pathImage: MyConstant.image1),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                    title: 'price ${productModels[index].price} Kip',
                    textStyle: MyConstant().h2Style(),
                  ),
                  ShowTitle(
                    title: productModels[index].detail,
                    textStyle: MyConstant().h3Style(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduct(
                                    productModel: productModels[index]),
                              ),
                            ).then((value) => loadValueFromAPI());
                          },
                          icon: Icon(Icons.edit_outlined,
                              size: 36, color: MyConstant.dark)),
                      IconButton(
                          onPressed: () {
                            print(
                                '## You click delete button from index = $index');
                            confirmDialogDelete(productModels[index]);
                          },
                          icon: Icon(Icons.delete_outline,
                              size: 36, color: MyConstant.dark)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: createUrl(productModel.images),
            placeholder: (context, url) => ShowProgress(),
          ),
          title: ShowTitle(
            title: 'Delete ${productModel.name} ?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: productModel.detail,
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('## Confirm Delete at id ==> ${productModel.id}');
              String apiDeleteProductWhereId =
                  '${MyConstant.domain}/eljeshoppingmall/deleteProductWhereId.php?isAdd=true&id=${productModel.id}';
              await Dio().get(apiDeleteProductWhereId).then((value) {
                Navigator.pop(context);
                loadValueFromAPI();
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }
}
