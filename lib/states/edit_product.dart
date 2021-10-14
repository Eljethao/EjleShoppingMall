// ignore_for_file: sized_box_for_whitespace

import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:eljeshoppingmall/models/product_model.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/utility/my_dialog.dart';
import 'package:eljeshoppingmall/widgets/show_progress.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  const EditProduct({Key? key, required this.productModel}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  List<String> pathImages = [];
  List<File?> files = [];
  bool statusImage = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productModel = widget.productModel;
    //print('### image from mySql ==>> ${productModel!.images}');
    convertStringToArray();
    nameController.text = productModel!.name;
    priceController.text = productModel!.price;
    detailController.text = productModel!.detail;
  }

  void convertStringToArray() {
    String string = productModel!.images;
    //print('### string before cut ===>$string');
    string = string.substring(1, string.length - 1);
    //print('### string after cut ==>> $string');
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImages.add(item.trim());
      files.add(null);
    }
    print('## pathImages ==>> $pathImages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => processEdit(),
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Product',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle('General'),
                    buildName(constraints),
                    buildPrice(constraints),
                    buildDetail(constraints),
                    buildTitle('Image Product'),
                    buildImage(constraints, 0),
                    buildImage(constraints, 1),
                    buildImage(constraints, 2),
                    buildImage(constraints, 3),
                    buildEditProduct(constraints)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildEditProduct(BoxConstraints constraints) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16,
      ),
      width: constraints.maxWidth,
      child: ElevatedButton.icon(
        onPressed: () => processEdit(),
        icon: const Icon(Icons.edit),
        label: const Text('Edit Product'),
      ),
    );
  }

  Future<void> chooseImage(int index, ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        files[index] = File(result!.path);
        statusImage = true;
      });
    } catch (e) {
      return;
    }
  }

  Container buildImage(BoxConstraints constraints, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.camera),
            icon: const Icon(Icons.add_a_photo),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: constraints.maxWidth * 0.5,
            child: files[index] == null
                ? CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}/eljeshoppingmall${pathImages[index]}',
                    placeholder: (context, url) => const ShowProgress(),
                  )
                : Image.file(files[index]!),
          ),
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.gallery),
            icon: const Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please fill name';
              } else {
                return null;
              }
            },
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please fill price';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.number,
            controller: priceController,
            decoration: const InputDecoration(
              labelText: 'Price: ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildDetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please fill detail';
              } else {
                return null;
              }
            },
            maxLines: 3,
            controller: detailController,
            decoration: const InputDecoration(
              labelText: 'Detail: ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ShowTitle(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }

  Future<void> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String name = nameController.text;
      String price = priceController.text;
      String detail = detailController.text;
      String id = productModel!.id;
      String images;
      if (statusImage) {
        //upload image and refresh array of pathImages
        int index = 0;
        for (var item in files) {
          if (item != null) {
            int i = Random().nextInt(1000000);
            String nameImage = 'productEdit$i.jpg';
            String apiUploadImage =
                '${MyConstant.domain}/eljeshoppingmall/saveProduct.php?';

            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            await Dio().post(apiUploadImage, data: formData).then((value) {
              pathImages[index] = '/product/$nameImage';
            });
          }
          index++;
        }

        images = pathImages.toString();
        Navigator.pop(context);
      } else {
        images = pathImages.toString();
        Navigator.pop(context);
      }

      print('## statusImage = $statusImage');

      print('## id = $id, name = $name, price = $price, detail = $detail');
      print('## images = $images');

      String apiEditProduct =
          '${MyConstant.domain}/eljeshoppingmall/editProductWhereId.php?isAdd=true&id=$id&name=$name&price=$price&detail=$detail&images=$images';
      await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    }
  }
}
