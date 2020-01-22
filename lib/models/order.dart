import 'item.dart';
class Order{
  String _orderid="1523";
  int _ordertotal=0;
  String _orderTime="";
  int _orderStatus=0;
  Map<int,int> _items={};

  String get orderid => _orderid;

  set orderid(String value) {
    _orderid = value;
  }

  Order( this._orderid, this._ordertotal, this._items);

  int get ordertotal => _ordertotal;

  set ordertotal(int value) {
    _ordertotal = value;
  }

  int get orderStatus => _orderStatus;

  set orderStatus(int value) {
    _orderStatus = value;
  }

  Map<int, int> get items => _items;

  set items(Map<int, int> value) {
    _items = value;
  }

}