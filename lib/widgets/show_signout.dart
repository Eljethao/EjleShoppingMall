import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then(
                  (value) => Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeAuthen, (route) => false),
                );
          },
          tileColor: Colors.red.shade900,
          // ignore: prefer_const_constructors
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 36,
          ),
          title: ShowTitle(
            title: 'Sign Out',
            textStyle: MyConstant().h2WhiteStyle(),
          ),
          subtitle: ShowTitle(
            title: 'Sign out and go to Authen',
            textStyle: MyConstant().h3WhiteStyle(),
          ),
        ),
      ],
    );
  }
}