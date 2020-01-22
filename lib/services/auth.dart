import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/models/user.dart';
import 'package:shoppingcart/services/firestore_database.dart';
import 'package:shoppingcart/tools/app_data.dart';

class AuthService {

  SharedPreferences _preferences;
  static const String USERNAME="username";
  static const String USEREMAIL="useremail";
  static const String USERPHOTO="userphoto";
  static const String USERID="userid";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  User _getUserFromFirebaseUser(FirebaseUser firebaseUser){
    if(firebaseUser!=null){
      saveUser(firebaseUser);
    }

    return firebaseUser!=null? User(uid: firebaseUser.uid):null;
  }

  Stream<User> get user{
    return _firebaseAuth.onAuthStateChanged
        .map(_getUserFromFirebaseUser);
  }



  //Register with Email & Password
  Future createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      //create a new document for the user with the uid
      await FirebaseDatabaseIo(uid: user.uid).updateUserdata(
          user.uid, name,"","");
      return _getUserFromFirebaseUser(user);
    }catch(error ){
      print(error.toString());
      return null;
    }


//update the username
    /*var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    return user.uid;*/
  }

  //SignIn with Email and Password Signin
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseUser user=await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
          return _getUserFromFirebaseUser(user);
    }catch(error){
    print(error.toString());
    return null;
    }
  }
  //SignIn with anonymous credentials
  Future signInAnony() async {
    try {
      FirebaseUser user = await _firebaseAuth.signInAnonymously();
      return user;
    } catch (error) {
    print(error.toString());
    return null;
    }
  }

  //SignOut
  Future signOut() async{
    try {
      return  await _firebaseAuth.signOut();
    }catch(error){
      print(error.toString());
      return null;
    }
  }

   static saveUser(FirebaseUser firebaseUser) async {
    print(firebaseUser.toString());
   try {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     preferences.setString(USERID, firebaseUser.uid);
     preferences.setString(USERNAME, firebaseUser.displayName);
     preferences.setString(USEREMAIL, firebaseUser.email);
     preferences.setString(USERPHOTO, firebaseUser.photoUrl);
   }catch(error){
     print(error.toString());
   }
  }

}
