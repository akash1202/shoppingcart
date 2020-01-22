import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButtonCart extends StatelessWidget {
  
  final IconData iconData;
  final Color color;
  final Function onTap;
  final String label;

  const CustomButtonCart({Key key, this.iconData, this.color, this.onTap, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: color,
        borderRadius: BorderRadius.all(Radius.circular(14))
        ),  
        child: Row(children: <Widget>[Container(
          height:35 ,
          width:35 ,
          decoration: BoxDecoration(
            color: Color(0xFFFfe9f3c),
              borderRadius: BorderRadius.all(Radius.circular(14))
          ),
          child: Icon(iconData,size:25),
        ),
        SizedBox(width:20),
        Text(label,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25))
        ],),
    ));
  }
}