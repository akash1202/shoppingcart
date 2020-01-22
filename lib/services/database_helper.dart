import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:shoppingcart/models/item.dart';
import 'package:shoppingcart/models/order.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'ordertable';
  static final orderId = 'orderid';
  static final itemId = 'id';
  static final itemName = 'name';
  static final itemDescription = 'description';
  static final itemImage = 'image';
  static final itemPrice = 'price';
  static final itemCount = 'count';

  //make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance=DatabaseHelper._privateConstructor();

  //only  have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async{
    if(_database != null ) return _database;
    // lazily instantiate  the db the first  time it is accessed
  _database =await _initDatabase();
    return _database;
  }

  //this opens the database and creates it if it doesn't exist
  _initDatabase() async{
   Directory documentDirectory =await getApplicationDocumentsDirectory();
   String path  =join(documentDirectory.path,_databaseName);
   return await openDatabase(path,onOpen:(instance){},version: _databaseVersion,onCreate:_onCreate);
  }

  //SQL code to  create  the database table
Future _onCreate(Database db,int version) async{
    await db.execute(''',CREATE TABLE $table($orderId INTEGER PRIMARY KEY,
    $itemId INTEGER,
    $itemName TEXT NOT NULL,
    $itemDescription TEXT,
    $itemImage TEXT,
    $itemPrice INTEGER NOT NULL,
    $itemCount INTEGER PRIMARY KEY,),''');
}

//Helper method
//Insert a row in the  database where each key in the Map is a column name
// and  the value is  the coulmn value. the return value is  the id of the inserted row.

Future<int> insert(Map<String,dynamic> row) async{
  Database db=await instance.database;
  return await db.insert(table,row);
}

//All of the  rows are returned as a list of maps, where each map is
// a key-value list of coulmns.

Future<List<Map<String,dynamic>>> queryAllRows() async{
    Database db= await instance.database;
    return  await db.query(table);
}

Future<int> queryRowCount()  async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table"));
}
Future<int> getOrderSameItemCountsById(int oId,int iId)  async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $itemId=$iId and $orderId=oId"));
}


Future<int> getorderAllItemsCountById(int oId)  async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $orderId=$oId"));
}

/*
Future<Order> insertOrder(Order order) async{
    Database db= await instance.database;
    for(int i=0;i<order.items.length;i++) {
          await db.execute(
        "INSERT INTO $table($orderId,$itemId,$itemName,$itemDescription,$itemImage,$itemPrice,$itemCount) values (?,?,?,?,?,?,?)",[order.orderid,
        order.items[i].itemId,
        order.items[i].name,
        order.items[i].description,
        order.items[i].image,
        order.items[i].price,
        order.items[i].count,
      ]);
    }
}
*/

Future<Order> getOrderById(String _orderId) async{
    Database db = await instance.database;
    List<Map<String,dynamic>> result= await db.query(table,columns:['$itemId','$itemName','$itemPrice','$itemCount'],where:'$orderId=?',whereArgs: ['$orderId']);
    int _orderTotal=0,counter=-1;
    Map<int,int> _items={};
    result.forEach((e){
      //_items[++counter]=new Item(e['$itemId'],e['$itemName'],e['$itemPrice'],e['$itemCount']);
      _orderTotal+=e['$itemPrice']*e['$itemCount'];
    });
    return new Order(_orderId,_orderTotal,_items);  //need to pass user id
}
Future<Item> getItemById(int iId) async{
    Database db = await instance.database;
    List<Map<String,dynamic>> result= await db.query(table,columns:['$itemId','$itemName','$itemPrice','$itemCount'],where:'$itemId=?',whereArgs: ['$iId']);
    return new Item(result.first['$itemId'],result.first['$itemName'],result.first['$itemPrice'],result.first['$itemCount']);
}

// we are assuming here that the id  column in map is set. the other
// column values will be used to update the row.
Future<int> update(Map<String,dynamic> row) async{
    Database db=await instance.database;
    int id=row[itemId];
    return await db.update(table,row,where: '$itemId =?',whereArgs: [id]);
}

//Deletes the row specified  by the id. The number of affected row is
// returned. This  should  be 1 as long  as the row exists.
Future<int> deleteOrderItemById(int iId) async{
    Database db= await instance.database;
    return await db.delete(table,where: '$itemId=?', whereArgs:[iId]);
}

}