
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/models/item.dart';
import 'package:shoppingcart/screens/home/item_tile.dart';

class ItemList extends StatefulWidget{
  @override
  _ItemListState createState() => _ItemListState();

}

class _ItemListState extends State<ItemList>{
  @override
  Widget build(BuildContext context) {
    final items= Provider.of<List<Item>>(context) ?? [];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context,index){
        return ItemTile(item: items[ index]);
      },
    );
  }
}