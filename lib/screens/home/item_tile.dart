

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart/models/item.dart';

class ItemTile extends StatelessWidget{
  final Item item;
  ItemTile({this.item}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.lightBlue[item.count],
            backgroundImage: AssetImage('assets/images/1.png'),
          ),
          title:Text(item.name),
          subtitle: Text('Takes Total:${item.count} '),
        ),
      ),
    );
  }

}