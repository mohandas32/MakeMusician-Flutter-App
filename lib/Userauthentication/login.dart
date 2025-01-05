import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:make_musician/test_firebase.dart';
import 'package:pinput/pinput.dart';

// import 'package:form_field_validator/form_field_validator.dart/';
class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _text = TextEditingController();
  final formKey = GlobalKey<FormState>(); //key for form

//Editing Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false; 
  bool _validate = false;
  var isVisible = true;

  var sha;

  final _auth = FirebaseAuth.instance;

  String email = "";
  String password = "";

  bool SuccesfulLogin =false;
  final storage= FlutterSecureStorage();

  late StreamSubscription subscription;
  bool isDeviceConnected= false;
  bool isAlertSet =false;

  showConnectionDialog(){

    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("No Connection"),
            content: const Text("Please Check Your Internet Connectivity"),
            actions: [
              TextButton(
                onPressed: () async{

                  Navigator.pop(context,"cancel");
                  setState(() => isAlertSet=false);
                   isDeviceConnected = await InternetConnectionChecker().hasConnection;

                  if(!isDeviceConnected){
                    showConnectionDialog();
                    setState(() => isAlertSet =true);
                  }
                }, 
                child: const Text("OK")
              )
            ],

      ),
      );

  }

  void getConnectivity(){

      subscription =Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;

          if(!isDeviceConnected && isAlertSet == false)
          {
            showConnectionDialog();
            setState(() => isAlertSet= true);
          }
         });
  }

   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   
    getConnectivity();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/login.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
           
            Container(
              padding: EdgeInsets.only(left: 35, top: 80),
              child: Text("WELCOME TO MAKEMUSICIAN ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 33,
                  )),
            ),
            Container(
              child: Form(
                key: formKey,
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 35, top: 320, right: 35),
                      child: Column(
                        children: [

                          IconButton(
                          onPressed: () => Navigator.pushNamed(context,"adminLogin"), 
                          icon: Image.asset("images/login.png", width: 40)
                          ),
                        Text("Admin")
                        ,
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter E-mail",
                                labelText: "E-Mail",
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter E-mail";
                                }
                                else if (!RegExp( r'^[\w-\.]+@([\w-]+\.)+[-\w]{2,4}')
                                  .hasMatch(value))
                                  return "Please Enter Valid E-mail";
                                  
                              }),
                          SizedBox(
                            // for margin between 2 textbox
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordController,
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: isVisible,
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              labelText: "Password",
                              suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color:
                                        isVisible ? Colors.grey : Colors.green,
                                  )),
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Password";
                              }
                              
                            },
                          ),
                          SizedBox(
                            // for margin between 2 textbox
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              
                              Padding(padding: EdgeInsets.only(left: 10)),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                  

                                    if (formKey.currentState!.validate()) {
                                      
                                      
                                      setState(() {
                                        isLoading= true;
                                      });

                                      Future.delayed(Duration(seconds: 3),(){

                                        setState(() {
                                          isLoading=false;

                                          //converting the password in SHA-1 hah value
                                          var byte=utf8.encode(passwordController.text.trim());
                                          sha =sha1.convert(byte);

                                           Signin(email.trim(), sha.toString());
                                           //Fluttertoast.showToast(msg: "${sha.toString()}");
                                        });
                                      });

                                     
                                    }
                                  },
                                  icon: isLoading? CircularProgressIndicator(color: Colors.white,)
                                   :Icon(Icons.arrow_forward),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "forget_password");
                                },
                                child: Text(
                                  "Forget Password?",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue[400],
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text("Don't have Account?",
                                  style: TextStyle(fontSize: 18)),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "phone");
                                },
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue[400],
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Signin(String email, String password) async {
    if (formKey.currentState!.validate()) {
      // print(email + password);
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
              
                Fluttertoast.showToast(msg: "Login Successfully"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Test_Firebase())),
                snakbar(), //calling snakbar method
                Storage_method(email, password),

              })
          .catchError((e) {
        if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blue,
              content: Text(
                'No User Found for that Email',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        }
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Password Not Found for That Email',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        }
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'User Not Found',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
        
      });
    }
  }

  void snakbar() {
    //adding the snackbar
    const snackBar = SnackBar(
      content: Text("Welcome To MakeMusican App.."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Storage_method(String email, String password) async{

    UserCredential userCredential = await FirebaseAuth.instance
    .signInWithEmailAndPassword(email: email, password: password);
    await storage.write(key: "uid", value: userCredential.user!.uid);
  }


}
