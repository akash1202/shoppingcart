import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/models/item.dart';
import 'package:shoppingcart/models/item.dart';
import 'package:shoppingcart/models/orders.dart';
import 'package:shoppingcart/screens/wrapper.dart';
import 'package:shoppingcart/services/firestore_database.dart';

import 'models/item.dart';
import 'models/order.dart';
class CartBloc with ChangeNotifier {


//  final DocumentReference firestoreDocReference;
  //Map<int, int> _cart = {}

  int get totalCartItems {
    counter=0;
    for(int i=0;i<_cart.length;i++){
      if(_cart[i]>0){
        counter++;
      }
    }
    return counter;
  }

  String currentOrderId;
  String userId;
  int counter;
  List<Item> _stockItems= new List<Item>();
  List<Item> stockItems2= new List<Item>();
  Map<int,Item> map1=new Map<int,Item>();
  Map<int,Item> map2=new Map<int,Item>();
  Map<int,int> _cart=new Map<int,int>();
  Map<int,int> get cart => _cart;

  List<Item> get stockItems => _stockItems;

  set stockItems(List<Item> value) {
    _stockItems.addAll(value);
  }


  CartBloc(){
  }



  CartBloc.fromSnapshot(String uid){
    print(" Cart bloc 1");
   /* _stockItems.add(new Item(1,"apple card",25,0));
    _stockItems.add(new Item(2,"amazon card",45,0));
    _stockItems.add(new Item(3,"gift",50,0));
    _stockItems.add(new Item(4,"gift card",10,0));
    _stockItems.add(new Item(5,"gift box",60,0));
    _stockItems.add(new Item(6,"gift packet",70,0));*/  //TODO: needs to initiate stockitems list
    map1[0]=new Item(0,"apple card",25,0);
    map2.addAll(map1);
   // _cart=new Order("123","12345",0,map2);
  instantiateCart(uid);
  }






  instantiateCart(String uid){
   try {
     SharedPreferences.getInstance().then((preferences) {
       userId = preferences.getString(Wrapper.USERID);
     });
     //stockItems.addAll(FirebaseDatabaseIo().getitemSnapshotById());
     _stockItems = new List<Item>();
     print("cart not instatiated "+uid+" : " + _cart.toString());
     print("stockitems instantiated before:" + _stockItems.toString());
     Firestore.instance.collection('items').snapshots().forEach((e) {
       Logger().d("cart 1 :" + e.documents.toString().toString());
       e.documents.forEach((doc) {
         Item item = Item.all(
             doc['id'], doc['name'], doc['description'], doc['image'],
             doc['price'], doc['count']);
         _stockItems.add(item);
       });
       for (int i = 0; i < stockItems.length; i++) {
         _cart[_stockItems[i].itemId] = 0;
       }
     });
     Firestore.instance.collection('users').document('$uid').snapshots().forEach((e) {
       e.data.forEach((k, v) {
         if (k == 'inprogressorderid') {
           currentOrderId = v;
           Firestore.instance.collection(('users')).document('$uid').collection(
               'orders').document(currentOrderId).snapshots().forEach(((e) {
             Logger().d("loading ..." + e.data.cast().toString());

             e.data.cast().forEach((k, v) {
               print("cart instantiated before:" + _cart.toString());
               if (k == 'items') {
                 print(v.runtimeType);
                 print(v.toString());
                 int sum=0;
                 v.forEach((k1, v1) {
                   print(k1.runtimeType);
                   print(v1.runtimeType);
                   int x1=int.parse(k1);
                   sum+=v1;
                   _cart[x1] = v1;
                   counter=sum;
                   print(" total items:");
                 });
                 print("cart instantiated after :" + _cart.toString());
               }
             });
           }));

         }
       });
     });

   }catch(e){
     Logger().d("Error :"+e.toString());
   }

         /* .then((doc){

     }); */
  }



 // CartBloc.fromMap(Map<int,int> cart,{@required this.firestoreDocReference}):
   //   assert(_cart!=null);

  //CartBloc.fromSnapshot(DocumentSnapshot snapshot):
   //   this.fromMap(snapshot.data,firestoreDocReference: snapshot.reference);


  void addToCart(index,int n) {
    if(n==1)
    _cart[index]+=1;
    _cart[index]=n;
    //decrement itemcount on firestore
    notifyListeners();
  }

  void clearFromCart(index,n) {
     if(_cart[index]-n<0) {
       _cart[index]=0;
     }else{
        _cart[index]-=n;
     }
    //increment itemcount on firestore
    notifyListeners();
  }

  T cast<T>(x) => x is T ? x: 0;

}
