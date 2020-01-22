import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(title: Text("Product Navigation")),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
         /* stream: products, buider: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if(snapshot.hasData) {
            List<DocumentSnapshot>
            documents = snapshot.data.documents;

            List<Order>
            items = List<Order>();

            for(var i = 0; i < documents.length; i++) {
              DocumentSnapshot document = documents[i];
              items.add(Order.fromMap(document.data));
            }
            return OrderBoxList(items: items);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },*/
        ),
      )
  );
}