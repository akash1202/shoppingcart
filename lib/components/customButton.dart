import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final Function onTap;

  const CustomButton({Key key, this.iconData, this.color, this.onTap}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
          decoration: BoxDecoration(
            borderRadius:BorderRadius.all(Radius.circular(14)),
          color: color
          ),
          child: Icon(iconData,size: 32),
      ),
    );
  }
}