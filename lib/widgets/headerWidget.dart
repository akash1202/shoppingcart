import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart/components/customButton.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Icon(Icons.arrow_back_ios,size: 30 ),
      _notificationItem()],
      ),
    );
  }
}


Widget _notificationItem(){
  return Container(
    child: Row(
      children: <Widget>[CustomButton(
        iconData: Icons.favorite_border,
        color: Color(0xFFFfebf50),
      ),
      SizedBox(width:15),
      Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          CustomButton(
            iconData: Icons.redeem,
            color: Color(0xFFFfebf50),
          ),_notification()
        ],
      )
      ],
    )
  );
}

Widget _notification(){
   return Positioned(
     left: -5,
     top : -5,
     child: Container(
       width:20 ,
       height: 20,
       alignment: Alignment.center,
       decoration: BoxDecoration(
         color: Colors.black,
         borderRadius: BorderRadius.all(Radius.circular(14)),
         border :Border.all(color:Colors.white,
         width: 2.7)),
     child: Text('2',
     style: TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.bold)
    )
     ),
   );
}