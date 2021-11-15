import 'package:flutter/material.dart';

class Credit extends StatefulWidget {
  const Credit({ Key? key }) : super(key: key);

  @override
  _CreditState createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Text('This is Credit'),
    );
  }
}