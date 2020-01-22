
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


String name;
String email;
String imageUrl;
final FirebaseAuth _auth= FirebaseAuth.instance;
final GoogleSignIn googleSignIn=GoogleSignIn();

Future<String> signInWithGoogle() async{
final GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();
final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;

final AuthCredential credential=GoogleAuthProvider.getCredential(
  accessToken: googleSignInAuthentication.accessToken,
  idToken: googleSignInAuthentication.idToken
);

final FirebaseUser user = await _auth.signInWithCredential(credential); //user got in result
//final FirebaseUser user=authResult.user;

assert(!user.isAnonymous);
assert(await user.getIdToken() != null);
assert(user.email!=null);
assert(user.displayName!=null);
assert(user.photoUrl!=null);
name=user.displayName;
email=user.email;
imageUrl=user.photoUrl;

final FirebaseUser currentUser = await _auth.currentUser();
assert(user.uid==currentUser.uid);


return 'signInWithGoogle succeeded: $user';

}
void signOutGoogle() async{
  await googleSignIn.signOut();
  print("User Sign out");
}