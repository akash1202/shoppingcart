import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/models/item.dart';
import 'package:shoppingcart/models/order.dart';
import'package:intl/intl.dart';
import 'package:shoppingcart/models/user.dart';

class FirebaseDatabaseIo {

  FirebaseUser user;

  String inProgressOrderId;
  String placedOrderId;
  final String uid;
  String itemId;
  List<Item> stockedItems;
  final CollectionReference userCollection=Firestore.instance.collection('users');
   CollectionReference orderCollection;
  final CollectionReference itemsCollection=Firestore.instance.collection('items');

  FirebaseDatabaseIo({this.uid});


  FirebaseDatabaseIo.addtoCartConstructor(this.uid, this.stockedItems);

  //items list from snapshot
  List<Item> itemsListfromDataSnapShot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      Item.all(doc.documentID ?? 0,doc['name'] ?? 'N/A',doc['description'],doc['image'],doc['price'] ?? 0,doc['count'] ?? 0);
    }).toList();
  }




//user data from snapshots
  UserData _userDatafromSnapshot(DocumentSnapshot snapshot){
    return UserData(uid, snapshot.data['name']);
  }
//order list from snapshot
  List<Order> ordersListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Order(doc.data['orderid'] ?? '',
          doc.data['ordertotal'] ?? 0,
          doc.data['items']?? null);
    }).toList();
  }


  Future<void> updateUserdata(String uid,String name,String inprogressorderid,String lastorderid) async{
  return await userCollection.document(uid).setData({
  'name':name,
  'inprogressorderid':inprogressorderid,
  'lastcompletedorderid':lastorderid
  });
  }

//to add order first time
Future<String> addOrder(Map<int,int> items) async{
    int orderStatus=0;
    DateTime now=DateTime.now();
    Map<String,int> uploaditems={};
    items.forEach((k,v){
      uploaditems['$k']=v;
    });

    String formattedDate=DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String newOrderId=DateFormat("yyyyMMddHHmmss").format(now);
    String currentOrderId;
    String lastCompletedOrderId;

var  doc=await userCollection.document(uid).get();
      String inProgressOrderId =doc['inprogressorderid'];
      if(inProgressOrderId!=null){
        currentOrderId=inProgressOrderId;
      }
      else{
        currentOrderId=newOrderId;
      }
    await userCollection.document(uid).get().then((doc) async{
      await userCollection.document(uid).setData({
        //'lastcompletedorderid': doc['inprogressorderid'],
        'inprogressorderid':currentOrderId,
      },merge:true);
    });
    await userCollection.document(uid).collection('orders').document(currentOrderId).setData({
      'lastupdate':formattedDate,
      'orderstatus': orderStatus,
      'ordertotal':getTotal(items),
      'items':uploaditems,
    },merge: true).catchError((e){
      print(e);
    });
    return currentOrderId;
  }



//to update order whenever user make changes in order
Future<void> updateOrder(String orderid,Map<int,int> items) async{
    int orderStatus=0;
    DateTime updateTime=DateTime.now();


    String formattedDate=DateFormat("yyyy-MM-dd HH:mm:ss").format(updateTime);
  await orderCollection.document(orderid).setData({
    'lastupdate':formattedDate,
    'orderstatus': orderStatus,
    'ordertotal':getTotal(items),
    'items':items,
  }).catchError((e){
    print(e);
  });
  }

  Stream<UserData> getInProgressOrderId(){
    return orderCollection.document(uid).snapshots().map(_userDatafromSnapshot);
  }

  // to get Total of ordered Items
  int getTotal(Map<int,int> items){
    var sum=0;
    items.forEach((k,v)=>sum+=(v*getItemById(k).price));
    return sum;
  }

  Item getItemById(int id){
    for(int i=0;i<stockedItems.length;i++){
      if(stockedItems.elementAt(i).itemId==id)
        return stockedItems.elementAt(i);
    }
    return null;
  }


  Future<Item> getItemSnapShotById(int itemid) async{
    var doc= await itemsCollection.document(itemId.toString()).get();
         return Item.all(
            doc['id'], doc['name'], doc['description'], doc['image'],
            doc['price'], doc['count']);
  }

//get items in stock doc stream
  Stream<List<Item>> get items{
    return itemsCollection.snapshots().map(itemsListfromDataSnapShot);
  }




//get order doc stream
Stream<List<Order>> get orders{
    return orderCollection.snapshots().map(ordersListFromSnapshot);
}
//get user doc stream
Stream<UserData> get userData{
    return orderCollection.document(uid).snapshots().map(_userDatafromSnapshot);
  }


/*StreamBuilder<QuerySnapshot> (stream: db.collection("orders").snapshots(),
  builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)){
    if(!snapshot.hasData) return new Text("There is no expense");
    return Expanded(child: new ListView(children: generateOrderList(snapshot),),)
  }*/
}
