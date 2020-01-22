class Item{
  int _itemId=1;
  String _name="abc";
  String _description="description";
  String _image="https://www.tutorialspoint.com/flutter/images/logo.png";
  int _price=25;
  int _count=0;

  Item(this._itemId, this._name, this._price, this._count);

  Item.all(this._itemId, this._name, this._description, this._image, this._price,
      this._count);

  int get count => _count;

  set count(int value) {
    _count = value;
  }

  int get price => _price;

  set price(int value) {
    _price = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
    _description= _name +"\'s Description";
  }

  int get itemId => _itemId;

  set itemId(int value) {
    _itemId = value;
  }


}