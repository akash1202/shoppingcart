import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/cart_page.dart';
import 'package:shoppingcart/screens/authenticate/login_page.dart';
import 'package:shoppingcart/models/item.dart';
import 'package:shoppingcart/screens/home/settings_form.dart';
import 'package:shoppingcart/screens/wrapper.dart';
import 'package:shoppingcart/tools/loading.dart';
import 'cart_bloc.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/home/home_page.dart';

void main() => runApp(MyApp2());

class MyApp2 extends StatelessWidget {


  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
  };

  CartBloc appCart;

  @override
  Widget build(BuildContext context) {

    var user= Provider.of<User>(context);
    //appCart=Provider.of<CartBloc>(context);
    return ChangeNotifierProvider<CartBloc> (
        create: (context){
          this.appCart= CartBloc.fromSnapshot(user.uid);
          return appCart;
        },
        child: MaterialApp(
          title: 'Shopping Cart Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage('My Gift Shop',this.appCart),
          // home: LoginPage(),
          routes: routes,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  CartBloc bloc;
  MyHomePage(this.title,this.bloc);

  @override
  _MyHomePageState createState() => _MyHomePageState(this.bloc);
}


class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences _preferences;
  static const String USERNAME="username";
  static const String USEREMAIL="useremail";
  static const String USERPHOTO="userphoto";
  static const String USERID="userid";
  static const String IS_LOGGED_IN="isloggedin";
  static const String CARTITEMSLIST="cartitemslist";
  static const String CARTTOTALITEMS="carttotalitems";
  static const String CARTTOTAL="carttotal";
  int cartTotal =6;
  List<Item> items=[];
  CartBloc bloc;

  _MyHomePageState(this.bloc);

  @override
  void initState() {
    SharedPreferences.getInstance().then((preferences){
      setState(()=>
      this._preferences = preferences);
      //super.initState();
      //_loadCartTotal();
     // _loadCart();
    });
  }

  void _showOrderPanel(Item item,dynamic bloc) {
    showModalBottomSheet(context: context, builder: (context){
      print(bloc.cart.toString());
      return Container(
          padding: EdgeInsets.symmetric(vertical:20.0 ,horizontal: 60.0),
          child: SettingsForm(item,bloc.cart));
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<CartBloc>(context);
    int totalCount = 0;
    if (bloc.cart.length > 0) {
      //totalCount = bloc.cart.values.reduce((a, b) => a + b);
      for(int i=0;i<bloc.cart.length;i++){
        totalCount+=bloc.cart[bloc.stockItems[i].itemId];
      }

      Logger().d("cart items :"+bloc.cart.toString());
      //totalCount = bloc.cart.items.values.reduce((a, b) => (a.count + b.count)) as int;
    }
    return WillPopScope(
      onWillPop: () =>showDialog<bool>(
        context: context,
        builder:(c)=> AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit?'),
          actions: <Widget>[FlatButton(
          child: Text('Yes'),
            onPressed: ()=> Navigator.pop(c,true),
          ),
          FlatButton(
            child: Text('No'),
            onPressed: ()=> Navigator.pop(c,false),
          )],
        )
    ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Container(
                    height: 150.0,
                    width: 30.0,
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(),
                          ),
                        );
                      },
                      child: new Stack(
                        children: <Widget>[
                          new IconButton(
                            icon: new Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: null,
                          ),
                          new Positioned(
                              child: new Stack(
                                children: <Widget>[
                                  new Icon(Icons.brightness_1,
                                      size: 20.0, color: Colors.red[700]),
                                  new Positioned(
                                      top: 3.0,
                                      right: 7,
                                      child: new Center(
                                        child: new Text(
                                          '$totalCount',
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                ],
                              )),
                        ],
                      ),
                    )),
              )
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('items').orderBy('id',descending: false).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData)
              return  Loading();
            else{
              List<Item> temp= new List<Item>();
              snapshot.data.documents.map((doc){
                Item item=Item.all(doc['id'],doc['name'],doc['description'],doc['image'],doc['price'],doc['count']);
                if(!bloc.stockItems.contains(item)){
                  temp.add(item);
                  bloc.stockItems=temp;
                }
              });
              return GridView.count(
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: getStockItems(snapshot,bloc));
            }
            },
          )


          /*GridView.count(
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            children: List.generate(6, (index) {
              return GestureDetector(
                  onTap: () async{
                      _showOrderPanel(bloc.stockItems.elementAt(index));
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                        children: <Widget>[ *//*Container(
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
                        ),*//*
                        CachedNetworkImage(
                          height: 95,
                          width:100,
                          alignment: Alignment.topCenter,
                          imageUrl: bloc.stockItems.elementAt(index).image,
                          fit: BoxFit.fitWidth,
                        )
                        ,
                          ListTile(
                            onTap: () async{
                              //Item item=new Item(index+1,"abc",50,5);
                             // _showEditPanel(item);

                              },
                            title: Text('${bloc.stockItems.elementAt(index).name}'),
                            subtitle: Text('\$'+'${bloc.stockItems.elementAt(index).price}'),
                            trailing: IconButton(
                              icon: Icon(Icons.add),
                              iconSize: 25.0,
                              onPressed: () {
                                bloc.addToCart(index+1);
                              },
                            ),
                          )
                        ]
                    ),
                  ));
            }),
          )*/,
        ),
      ),
    );
  }


  getStockItems(AsyncSnapshot<QuerySnapshot> snapshot ,dynamic bloc){
    return snapshot.data.documents.map((doc)=>
    new GestureDetector(
        onTap: () async{
          Item item=new Item.all(doc['id'],doc['name'],doc['description'],doc['image'],doc['price'],doc['count']);
          _showOrderPanel(item,bloc);
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12)
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
                CachedNetworkImage(
                  height: 95,
                  width:100,
                  alignment: Alignment.topCenter,
                  imageUrl: doc['image'],
                  fit: BoxFit.fitWidth,
                )
                ,
                ListTile(
                  onTap: () async{
                    //Item item=new Item(index+1,"abc",50,5);
                    // _showEditPanel(item);

                  },
                  title: Text('${doc['name']}'),
                  subtitle: Text('\$'+'${doc['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 25.0,
                    onPressed: () async {
                      bloc.addToCart(doc['id'],1);
                    },
                  ),
                )
              ]
          ),
        )


    )).toList();
  }

  Future<FirebaseUser> _loadUser() async {
    setState(() {
      final FirebaseAuth firebaseAuth= FirebaseAuth.instance;
      final FirebaseUser user= firebaseAuth.currentUser() as FirebaseUser;
      _preferences.setString(USERID, user.uid);
      _preferences.setString(USERNAME, user.displayName);
      _preferences.setString(USEREMAIL, user.email);
      _preferences.setString(USERPHOTO, user.photoUrl);
    });
  }

  void _loadCart() {
    setState(() {
     // this.items.add(value); //add items from firebase database;
    });
  }

  void _loadCartTotal() {
    setState(() {
     this.cartTotal=_preferences.getInt(CARTTOTAL) ?? 0;
    });
  }

  Future<Null> _setCartPref(String itemsList) async {
    await this._preferences.setString(CARTITEMSLIST,itemsList);
    _loadCart();
  }

  Future<Null> _setCartTotalPref(int cartTotal) async {
    await this._preferences.setInt(CARTTOTAL, cartTotal);
    _loadCartTotal();
  }


}
