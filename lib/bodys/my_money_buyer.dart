import 'package:flutter/material.dart';

class MyMoney extends StatefulWidget {
  const MyMoney({Key? key}) : super(key: key);

  @override
  _MyMoneyState createState() => _MyMoneyState();
}

class _MyMoneyState extends State<MyMoney> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('My Money'),
    );
  }
}
