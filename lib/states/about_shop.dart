// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eljeshoppingmall/models/user_model.dart';
import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;
  const AboutShop({Key? key, required this.userModel}) : super(key: key);

  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            showShopName(),
            showImage(),
            SizedBox(height: 20),
            showPhone(),
            showAddress(context),
            SizedBox(height: 16),
            showMap(context)
          ],
        ),
      ),
    );
  }

  Container showMap(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.6,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(userModel!.lat),
                  double.parse(userModel!.lng),
                ),
                zoom: 16,
              ),
              // ignore: prefer_collection_literals
              markers: <Marker>[
                Marker(
                    markerId: const MarkerId('id'),
                    position: LatLng(
                      double.parse(userModel!.lat),
                      double.parse(userModel!.lng),
                    ),
                    infoWindow: InfoWindow(
                      title: 'ທີ່ຢູ່ຂອງຮ້ານ',
                      snippet:
                          'lat = ${userModel!.lat}, lng = ${userModel!.lng}',
                    )),
              ].toSet(),
            ),
          );
  }

  Row showPhone() {
    return Row(
      children: [
        ShowTitle(
          title: 'ເບີໂທ: ',
          textStyle: MyConstant().h2Style(),
        ),
        Text(
          userModel!.phone,
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }

  Container showImage() {
    return Container(
      width: 250,
      height: 250,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: CachedNetworkImage(
        imageUrl: '${MyConstant.domain}${userModel!.avatar}',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget showAddress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [
          ShowTitle(
            title: 'ທີ່ຢູ່: ',
            textStyle: MyConstant().h2Style(),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Text(
                userModel!.address,
                style: TextStyle(fontSize: 16),
              )),
        ],
      ),
    );
  }

  Row showShopName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'ຊື່ຮ້ານ: ',
          textStyle: MyConstant().h2Style(),
        ),
        ShowTitle(
          title: userModel!.name,
          textStyle: MyConstant().h1Style(),
        ),
      ],
    );
  }
}
