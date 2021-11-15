import 'package:eljeshoppingmall/utility/my_constant.dart';
import 'package:eljeshoppingmall/widgets/show_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bank extends StatefulWidget {
  const Bank({Key? key}) : super(key: key);

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTitle(),
          buildBKKbank(),
          buildKbank(),
        ],
      ),
    );
  }
 
  Card buildKbank() {
    return Card(
      child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/kbank.svg'),
              ),
            ),
            title: ShowTitle(
              title: 'ທະນາຄານກະສິກອນໄທ',
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: ShowTitle(
              title: 'ຊື່ບັນຊີ ທ.ຈອນສັນ ເລກທີ່ບັນຊີ 056-2-32767-5',
              textStyle: MyConstant().h3Style(),
            ),
          ),
    );
  }

  Card buildBKKbank() {
    return Card(
      child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/bbl.svg'),
              ),
            ),
            title: ShowTitle(
              title: 'ທະນາຄານການຄ້າຕ່າງປະເທດ',
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: ShowTitle(
              title: 'ຊື່ບັນຊີ ທ.ສອນໄຊ ເລກທີ່ບັນຊີ 8885-9996-2222-1111',
              textStyle: MyConstant().h3Style(),
            ),
          ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
          title: 'ການໂອນເງີນເຂົ້າບັນຊີທະນາຄານ',
          textStyle: MyConstant().h1Style()),
    );
  }
}
