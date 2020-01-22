import 'package:flutter/material.dart';
import 'package:shoppingcart/components/CustomButtonCart.dart';
import 'package:shoppingcart/widgets/headerWidget.dart';
import 'package:shoppingcart/widgets/productWidget.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child:Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  HeaderWidget(),
                  ProductWidget(),
                  SizedBox(height: 10),
                  CustomButtonCart(
                    iconData: Icons.add,
                    color: Color(0xFFFfebf50),
                    label: "ADD TO CART")
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}