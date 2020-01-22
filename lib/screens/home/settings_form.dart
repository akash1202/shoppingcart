import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/cart_bloc.dart';
import 'package:shoppingcart/models/item.dart';
import 'package:shoppingcart/models/user.dart';
import 'package:shoppingcart/services/firestore_database.dart';
import 'package:shoppingcart/tools/loading.dart';
import 'package:shoppingcart/tools/textInputDecoration.dart';

class SettingsForm extends StatefulWidget{
  Item item;
  Map<int,int> cartStatus={};
  SettingsForm(this.item,this.cartStatus);

  @override
  _SettingsFormState createState() => _SettingsFormState(item,cartStatus);

}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey=GlobalKey<FormState>();
  Map<int,int> cartStatus={};
  final List<String> itemCounts=['0','1','2','3','4','5','6'];
  final List<int> price=[10,20,30,40,50,60,70,80,90];
  //form values
  String _currentName;
  String _currentItemCounts='0';
  String tempItemCount='0';
  int _currentPrice;
  var doc;
  User user;
  Item item;
  _SettingsFormState(this.item,this.cartStatus);
  @override
  Widget build(BuildContext context) {
    user=Provider.of<User>(context);
    var bloc=Provider.of<CartBloc>(context);
    print(user.toString()+"\n"+item.itemId.toString()+"\n"+cartStatus.toString());
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('items').document('${item.itemId}').snapshots(),
        builder:(BuildContext context,AsyncSnapshot<DocumentSnapshot> snap){
        if(!snap.hasData){
          return Loading();
        }else{
          return getItemWidget(snap,bloc);
        }

       // print("snap : "+snap.data.toString());
      //  return Item.all(snap['id'],snap['name'],snap['description'],snap['image'],snap['price'],snap['count']);
    }
      );
    /*where('id',isEqualTo:),
      builder:(context,snapshot){
        if(snapshot.hasData){
          Item retrievedItem=snapshot.data;
          return 


        }else{
          return Loading();
        }
      }
    );*/


  }
  
  
  


  /*int getOrderId(){
    DateTime datetime=DateTime.now();
    String
  }*/

  getItemWidget(AsyncSnapshot<DocumentSnapshot> snap,dynamic bloc){
   doc=snap.data;
   final double heightFactor=0.25;
      var currentItemId=doc['id'];
   return
    Form(
      key: _formkey,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                Text('Update your Order',
                    style:TextStyle(fontSize: 15.0)),
              SizedBox(height: 5.0),
              CachedNetworkImage(imageUrl: doc['image'],
                  fit: BoxFit.scaleDown,
                  height:70,
                  width: 100,
                ), TextFormField(
                  initialValue:doc['name'],
                  decoration: textInputDecoration,
                  validator: (val){
                    if(val.isEmpty || val=="0"){
                      return 'Please select Atleast one ';
                    }
                    else
                      return null;
                  },
                  onChanged: (val)=> setState(()=> _currentName=val),
                ),
              SizedBox(height:5.0),
                  RichText(
                    text:TextSpan(
                      text: doc['description'],
                      style: TextStyle(
                        color: Colors.black,
                          fontSize: 20.0),
                    children:[
                      TextSpan(
                      text:" \$ ${doc['price']}",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ))
                    ]),
                    /*
                  initialValue:doc['description'],
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a description':null,
                  onChanged: (val)=> setState(()=> _currentName=val),*/
                ),
              SizedBox(height: 5.0),
    StreamBuilder<DocumentSnapshot>(
    stream: Firestore.instance.collection('users').document('${user.uid}').snapshots(),
    builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
    if(!snapshot.hasData)
    return Loading();
    else{
      var a=snapshot.data.data;
      var ordersCollection=snapshot.data.reference.collection("orders");
      String currentOrderId;
      var orderItems={};
      if(a.containsKey('inprogressorderid') &&a['inprogressorderid']!=null) {
        currentOrderId = a['inprogressorderid'];
        ordersCollection.getDocuments().then((ordersSnapshot){
          ordersSnapshot.documents.forEach((order){
          if(order.documentID==currentOrderId){
           // print("Docs Collections: " +doc['items']);
            print("order items 1: "+order.data.toString());
            print("order items 2: "+order.data.cast().toString());
            order.data.cast().forEach((k,v){
              if(k=='items'){
                print("datatype :"+v.toString());
                orderItems=new Map<dynamic,dynamic>.from(v);
               print("datatype after :"+orderItems.toString()+"  "+doc['id'].toString());
                _currentItemCounts= orderItems[doc['id'].toString()].toString();
                print("current selecte 1: "+ orderItems[doc['id'].toString()].toString()+ " : "+_currentItemCounts);
              }
            });
          }
          });
          });

        print("current selecte 2: "+ orderItems[doc['id'].toString()].toString() +"selected:"+ _currentItemCounts);
        }
    return DropdownButtonFormField(
      value: _currentItemCounts ?? '0',
      items: itemCounts.map((itemcount){
        return DropdownMenuItem(
          value: itemcount,
          child: Text('$itemcount'),
        );
      }).toList(),
    onChanged: (val)=>setState(() {
      tempItemCount = val;
      _currentItemCounts = tempItemCount;
    }),
    );
    }}), SizedBox(height: 5.0),
              /*Slider(
                    value: (_currentItemCounts ?? 25).toDouble(),
                    activeColor: Colors.lightBlue[_currentItemCounts?? 50],
                    inactiveColor: Colors.lightBlue[_currentItemCounts?? 250],
                    min:0.0,
                    max:150.0,
                    divisions:15,
                    onChanged: (val)=>setState(()=>retrievedItem.count= val.round()),
            ),*/RaisedButton(
                    color:Colors.lightBlue[400],
             child:Text('Update',
                      style:TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if(_formkey.currentState.validate()){
                        print("Cart update( before ): "+cartStatus.toString() +" : "+tempItemCount);
                        Item item= new Item.all(doc['id'],doc['name'],doc['description'],doc['image'],doc['price'],doc['count']);
                        cartStatus.forEach((k,v){
                          if(k==item.itemId){
                            cartStatus[k]=int.parse(tempItemCount);
                            //var a=int.parse(doc['id']);
                            bloc.addToCart(k,cartStatus[k]);
                          }
                        });
                        print("Cart update ( after ): "+cartStatus.toString());
                        await FirebaseDatabaseIo.addtoCartConstructor(user.uid,bloc.stockItems)  //need to pass order items data
                            .addOrder(cartStatus);
                        Navigator.pop(context);
                      }
              }),
            ],
          ),
        ),
      ),
    );
  }
  
  
}