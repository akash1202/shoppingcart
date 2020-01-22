import 'package:shared_preferences/shared_preferences.dart';

class User{
 final String uid;
 User({this.uid});
}

class UserData{
  final String uid;
  final String name;
  UserData(this.uid, this.name);

}