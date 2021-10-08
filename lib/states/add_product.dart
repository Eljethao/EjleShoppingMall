// ignore_for_file: sized_box_for_whitespace

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/utility/my_dialog.dart';
import 'package:eljeshoppingmall/widgets/show_image.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;

  @override
  void initState() {
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => processAddProduct(),
            icon: const Icon(Icons.cloud_upload),
          ),
        ],
        title: const Text('Add Product'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildProductName(constraints),
                    buildProductPrice(constraints),
                    buildProductDetail(
                        constraints), //const SizedBox(height: 10),
                    buildImage(constraints),
                    const SizedBox(height: 10),
                    addProductButton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container addProductButton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          processAddProduct();
        },
        child: const Text('Add Product'),
      ),
    );
  }

  Future<void> processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        //print('## choose 4 images success');
        MyDialog().showProgressDialog(context);     

        String apiSaveProduct =
            '${MyConstant.domain}/eljeshoppingmall/saveProduct.php?';

        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(1000000);
          String nameFile = 'product$i.jpg';
          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio()
              .post(apiSaveProduct, data: data)
              .then((value) {
                print('Upload Success');
                loop++;
                if (loop >= files.length) {
                  Navigator.pop(context);
                }
                
              });
        }
      } else {
        MyDialog()
            .normalDialog(context, 'Choose Image', 'Please choose all image');
      }
    }
  }

  Future<void> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> chooseSourceImageDialog(int index) async {
    print('Click from index ==>> $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.image2),
          title: ShowTitle(
            title: 'Source Image${index + 1}?',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: 'Please choose image from camera or gallery',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: const Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: const Text('Gellery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.70,
          height: constraints.maxWidth * 0.65,
          child:
              file == null ? Image.asset(MyConstant.image5) : Image.file(file!),
        ),
        Container(
          width: constraints.maxWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[0]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[1]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[2]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[3]!, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProductName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: const EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill product name';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'Product Name : ',
          labelStyle: MyConstant().h3Style(),
          prefixIcon: Icon(
            Icons.production_quantity_limits_sharp,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildProductPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: const EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill product price';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Product Price : ',
            labelStyle: MyConstant().h3Style(),
            prefixIcon: Icon(
              Icons.money_sharp,
              color: MyConstant.dark,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.light),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: const EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill product detail';
          } else {
            return null;
          }
        },
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Product Detail: ',
            hintStyle: MyConstant().h3Style(),
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Icon(
                Icons.details_outlined,
                color: MyConstant.dark,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.light),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }
}
