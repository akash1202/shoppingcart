import 'package:shoppingcart/models/order.dart';

class Orders{
  int _userId;
  List<Order> _orders;

  Orders(this._userId, this._orders);

  List<Order> get orders => _orders;

  set orders(List<Order> value) {
    _orders = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }


}