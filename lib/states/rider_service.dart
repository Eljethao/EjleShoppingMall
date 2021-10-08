// ignore_for_file: prefer_const_constructors

import 'package:eljeshoppingmall/widgets/show_signout.dart';
import 'package:flutter/material.dart';

class RiderService extends StatefulWidget {
  const RiderService({Key? key}) : super(key: key);

  @override
  _RiderServiceState createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider'),
      ),
      drawer: Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}
