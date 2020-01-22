import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.74,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width*0.7,
            child: Image.asset('assets/images/google_logo.png',fit:BoxFit.contain),
          ),
          SizedBox(height:20),
          Text('This is Coffees beans pack',
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
          ),
          SizedBox(height:10),
          Row( children: <Widget>[
            Icon(Icons.star,color: Color(0xFFFfebf50)),
            Icon(Icons.star,color: Color(0xFFFfebf50)),
            Icon(Icons.star,color: Color(0xFFFfebf50)),
            Icon(Icons.star,color: Color(0xFFFfebf50)),
            Icon(Icons.star,color: Color(0xFFFfee9c3)),
            SizedBox(width: 10),
            Text("45 Reviews",style:TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFF757575)))
            ],),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text:TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: '\$4.56  ',
                    style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold)),
                    TextSpan(text: '\$5.78',
                    style: TextStyle(color: Color(0xFFF707070),fontSize: 21,decoration: TextDecoration.lineThrough))
                    ]
                )
              ),
              Container(
                width: 130,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(14))),
                child: Text('20% OFF',style: TextStyle(color: Color(0xFFFc56c09),fontSize: 17,fontWeight: FontWeight.bold),),
              )
            ],)
        ],
      ),
    );
  }
}