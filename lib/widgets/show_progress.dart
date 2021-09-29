import 'package:flutter/material.dart';

class ShowProgress extends StatelessWidget {
  const ShowProgress({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Center(child: CircularProgressIndicator());
  }
}