import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/screens/home/settings_form.dart';
import 'package:shoppingcart/services/auth.dart';
import 'package:shoppingcart/tools/loading.dart';

import 'models/item.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}


class  _CartPageState extends State<CartPage> {
  AuthService _auth = new AuthService();


  void _showOrderPanel(Item item,dynamic bloc) {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(item, bloc.cart));
    });
  }
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CartBloc>(context);
    var cart = bloc.cart;
    /* void _showEditPanel() {
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical:20.0 ,horizontal: 60.0),
          child: SettingsForm());
      });
    }*/

    return Scaffold(
      appBar: AppBar(title: Text("Cart"), actions: <Widget>[
        FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.person),
            label: Text('logout')),
        FlatButton.icon(
            onPressed: () {
              // _showEditPanel();
            },
            icon: new Icon(Icons.edit),
            label: Text('Edit'))
      ]),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('items').orderBy('id',descending: false).snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData)
            return Loading();
          else{
            return ListView(children: getStockItems(snapshot, bloc));
          }
        },

      )
    /*ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          //int giftIndex = cart.keys.toList()[index];
          int giftIndex = cart.keys.toList()[index];
          int count = cart[giftIndex];
          int itemNumber = giftIndex;
          return ListTile(
            leading: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/${giftIndex}.jpg"),
                  fit: BoxFit.fitWidth,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            title: Text('Item $itemNumber Count: $count'),
            trailing: IconButton(
              icon: new Icon(Icons.remove_circle_outline),
              color: Theme
                  .of(context)
                  .buttonColor,
              splashColor: Colors.blueGrey,
              onPressed: () {
                bloc.clearOne(giftIndex + 1);
              },
            ),
          );
        },
      ),*/
      /*RaisedButton(
    color:Colors.pink[400],
    child:Text('Place Order',
    style:TextStyle(color: Colors.white),
    ),
    onPressed: () async{

    })*/
      );
  }


  getStockItems(AsyncSnapshot<QuerySnapshot> snapshot,dynamic bloc) {
    return snapshot.data.documents.map((doc) =>
    new GestureDetector(
        onTap: () async {
          Item item = new Item.all(
              doc['id'], doc['name'], doc['description'], doc['image'],
              doc['price'], doc['count']);
          _showOrderPanel(item,bloc);
        },
        child: Container(
          height: 100,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
              children: <Widget>[ /*Container(
                          height: 95,
                          width: 100,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/${index + 1}.jpg"),
                              fit: BoxFit.fitWidth,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),*/

                ListTile(
                  leading:CachedNetworkImage(
                    height: 50,
                    width: 50,
                    alignment: Alignment.topCenter,
                    imageUrl: doc['image'],
                    fit: BoxFit.fitWidth,
                  ),
                  onTap: () async {
                    //Item item=new Item(index+1,"abc",50,5);
                    // _showEditPanel(item);

                  },
                  title: Text('${doc['name']}'),
                  subtitle: Text('\$' + '${doc['price']} X ${bloc.cart[doc["id"]]} = ${(doc["price"]* bloc.cart[doc["id"]])}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    iconSize: 30.0,
                    onPressed: () {
                      bloc.clear(doc['id'],1);
                    },
                  ),
                )
              ]
          ),
        )
    )).toList();
  }
}


