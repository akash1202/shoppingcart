import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingcart/screens/authenticate/login_page.dart';
import 'package:shoppingcart/services/auth.dart';
import 'package:shoppingcart/tools/progressdialog.dart';
import 'package:shoppingcart/tools/textInputDecoration.dart';

class Signup extends StatefulWidget {
  static String tag='signup-page';
  final  Function toggleView;


  Signup({this.toggleView});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey=GlobalKey<FormState>();
  final _scaffoldkey=GlobalKey<ScaffoldState>();
  String error='';
  bool loading =false;
  String userNameText='';
  String emailText='';
  String passwordText='';
  BuildContext context;


  TextEditingController emailController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();
  TextEditingController rePasswordController=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context=context;

    final logo=Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius:70.0,
        child:Image.asset('assets/images/logo3.jpg'),
      ),
    );
    final username =TextFormField(
      keyboardType:TextInputType.text,
      autofocus: false,
      decoration:InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0,10.0,20.0, 10.0),
        border:OutlineInputBorder(borderRadius:BorderRadius.circular(32.0)),
      ),
      validator: (val)=> val.isEmpty? 'enter username':null,
      onChanged: (val){
        setState(() {
          userNameText=val;
        });
      },
    );
    final email=TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    controller: emailController,
    decoration: InputDecoration(
      hintText: 'Email',
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
    ),
      validator: (val)=>val.isEmpty ? 'Enter email address!': null,
      onChanged: (val){
        setState(() {
          emailText=val;
        });
      },
  );
  final password=TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    controller: passwordController,
    obscureText: true,
    decoration: InputDecoration(
      hintText: 'Password',
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
    ),
    validator: (val)=> val.length <8 ? 'Enter atleaset 8+ character': null,
    onChanged: (val){
      setState(() {
        passwordText=val;
      });
    },
  );

    final rePassword=TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: rePasswordController,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );


  final signupButton=Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () async{
        if(_formkey.currentState.validate()){
          setState(()=>loading=true);
        }
        dynamic result = await AuthService().createUserWithEmailAndPassword(emailText, passwordText, userNameText);
        if(result==null){
          setState(() {
            loading=false;
            error="please enter a valid email";
          });
        }else{
          setState(() {
            loading=false;
            error="success!";
           showSnackbar("Registered Successfully!!");
          });
          print(result.toString());

        }
      },
      padding:EdgeInsets.all(12),
      color: Colors.green,
      child: Text('Signup',style: TextStyle(color:Colors.white,fontSize :17.0)), 
    ),
  );
  final loginLabel=FlatButton(
    child :Text('Already Registered? Login',
    style:TextStyle(color:Colors.purple,fontSize: 15),
  ),
  onPressed: (){
    Navigator.of(context).pushNamed(LoginPage.tag);
  },
  );
  return  loading ? ProgressDialog():
  WillPopScope(
        onWillPop: () =>
        showDialog<bool>(
            context: context,
            builder: (c) =>
                AlertDialog(
                  title: Text('Warning'),
                  content: Text('Do you really want to exit?'),
                  actions: <Widget>[FlatButton(
                    child: Text('Yes'),
                    onPressed: () => Navigator.pop(c, true),
                  ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () => Navigator.pop(c, false),
                    )
                  ],
                )
        ),
    child:Scaffold(
      key: _scaffoldkey,
       backgroundColor: Colors.white,
       body:Center(child:Form(
         key: _formkey,
         child: ListView(
          shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0,right: 24.0),
            children: <Widget>[
            logo,
            SizedBox(height: 50.0),
            username,
            SizedBox(height:15.0),
            email,
            SizedBox(height: 15.0),
            password,
            SizedBox(height:24.0),
            signupButton,
            loginLabel
          ],
  ),
       ))

  ));

  }


  void showSnackbar(String message){
    final snackbar= SnackBar(content: Text(message));
   _scaffoldkey.currentState.showSnackBar(snackbar);
   //error:VirtualView node must not be the root node. The context used was: Signup
  }


  /*verifyDetails() async {
    if (fullname.text == "") {
      showSnackBar("Full name cannot be empty", scaffoldKey);
      return;
    }

    if (phoneNumber.text == "") {
      showSnackBar("Phone cannot be empty", scaffoldKey);
      return;
    }

    if (emailController.text == "") {
      showSnackBar("Email cannot be empty", scaffoldKey);
      return;
    }

    if (passwordController.text == "") {
      showSnackBar("Password cannot be empty", scaffoldKey);
      return;
    }

    if (rePasswordController.text == "") {
      showSnackBar("Re-Password cannot be empty", scaffoldKey);
      return;
    }

    if (passwordController.text != rePasswordController.text) {
      showSnackBar("Passwords don't match", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    String response = await appMethod.createUserAccount(
        fullname: fullname.text,
        phone: phoneNumber.text,
        email: emailController.text.toLowerCase(),
        password: passwordController.text.toLowerCase());

    if (response == successful) {
      closeProgressDialog(context);
      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }
  }
}*/






  Future<FirebaseUser> signUpWithEmailPassword() async {
    final FirebaseAuth mAuth= FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await mAuth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
       print(firebaseUser);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(firebaseUser.email),
    ));
    return firebaseUser;
  }


  /*Future<void> verifyPhone() async{
    final PhoneCodeSent smsOTPSent=(String verId,[int forceCodeResend]){
      this.verificationId=verId;
      smsOTPDialog(context).then((value){});
    };
    try{
      await
    } catch(e){
      handle
    }

  }
*/
  void passwordReset(){
    final FirebaseAuth mAuth = FirebaseAuth.instance;
    mAuth.sendPasswordResetEmail(email: emailController.text).then((doc){
      Navigator.pop(context);
    }).catchError((onError){
      //on error dialog;
    });
  }
}