// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:make_musician/test_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  bool isLoading =false;
  var sha;

//storing image path and url of the profile image
  String imgPath="";
  String imgUrl="";

  final _text = TextEditingController();
  final _formKey = GlobalKey<FormState>(); //key for form
  bool isValid = false;
  bool isPassVisible = true, isConPassVisible = true;

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();

   UploadImage() async{

          final XFile? pickImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);


        String uniqueName =  DateTime.now().millisecondsSinceEpoch.toString();

        Reference refernceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = refernceRoot.child('user_profile_icon');
        Reference referenceImageToUpload = referenceDirImage.child("$uniqueName");

        try{
          await referenceImageToUpload.putFile(File(pickImage!.path));
         imgUrl= await referenceImageToUpload.getDownloadURL();

            }
        catch(e){
            print(e);
                }
        setState(() {
        });
                //print("imgpath $imgPath imgurl $imgUrl");
  }

  final List userData=[];
  Map getData={};

//fetching user data
  fetchUserData() async{

    final user = FirebaseAuth.instance;
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("user_info").get();

      if(qn.docs.length > 0) {

         for(int i=0; i<qn.docs.length; i++){
          userData.add(
            qn.docs[i]["email"]);      
        }
      }
      
      setState(() {
        
      });
  }

//user already message
  UserExistSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Email Address Already Exist...",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();

  }

  @override
  Widget build(BuildContext context) {
  
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/register.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35),
              child: Text("\n\nCreate Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  )),
            ),
            
            SizedBox(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 35, top: 250, right: 35),
                  child: Form(
                    key: _formKey, //key for form
                    child: Column(
                      children: [

                        GestureDetector(
                         onTap: () async {
                        
                            UploadImage();
                            
                        // if (pickImage != null) {
                        //   setState(() {
                        //      imgPath = pickImage.path;
                        //   });
                        // }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        child: CircleAvatar(
                                radius: 30,
                                child: Image.asset(
                                  "images/icons/profile_icon.png",
                                  width: 100,
                                  height: 100,
                                ),
                                
                              )
                        
                      ),
                        ),
                    
                        TextFormField(
                            controller: firstnameController,
                            decoration: InputDecoration(
                              hintText: "Enter First Name",
                              labelText: "First Name",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                                return "Only alphabets allowed.";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: lastnameController,
                            decoration: InputDecoration(
                                hintText: "Enter Last Name",
                                labelText: "Last Name",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                                return "Only alphabets allowed.";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: emailController,
                            onChanged: (value) {
                              if (value.contains("@gmail.com")) {
                                setState(() {
                                  isValid = true;
                                });
                              } else
                                setState(() {
                                  isValid = false;
                                });
                            },
                            keyboardType: TextInputType
                                .emailAddress, // email type keyboar displayed
                            decoration: InputDecoration(
                                hintText: "Enter E-Mail",
                                labelText: "E-mail",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.email),
                                suffixIcon: isValid ? Icon(Icons.check) : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[-\w]{2,4}')
                                  .hasMatch(value))
                                return "Please Enter Valid E-mail";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: passwordController,
                            obscureText:
                                isPassVisible, // for password field character is in hidden form
                            decoration: InputDecoration(
                                hintText: "Enter Password",
                                labelText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.password),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isPassVisible = !isPassVisible;
                                    });
                                  },
                                  child: Icon(Icons.remove_red_eye_outlined,
                                      color: isPassVisible
                                          ? Colors.grey
                                          : Colors.greenAccent),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (value.length < 8){
                                return "Password must be more than 8 characters";
                              }
                              else if (!RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*_-+]).+').hasMatch(value)){
                                return "Atleast contain one lower, upper\ndigit and special character}";
                              }
                              
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: confirmPasswordController,
                            obscureText:
                                isConPassVisible, // for password field character is in hidden form
                            decoration: InputDecoration(
                                hintText: "Confirm password",
                                labelText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.password),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isConPassVisible = !isConPassVisible;
                                    });
                                  },
                                  child: Icon(Icons.remove_red_eye_outlined,
                                      color: isConPassVisible
                                          ? Colors.grey
                                          : Colors.greenAccent),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (value.length < 8)
                                return "Password must be more than 8 characters";
                            
                              else if(passwordController.text != confirmPasswordController.text)
                                return "Password and Confirm password must be same";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: mobilenumberController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: InputDecoration(
                                hintText: "Enter Mobile Number",
                                labelText: "Mobile Number",
                                counterText: "",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.mobile_friendly),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))
                                    ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(r'[0-9]{10}').hasMatch(value))
                                return "Enter Valid Mobile Number";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //  Padding(
                            //   padding: EdgeInsets.only(left: 10)
                            //   ),

                            Text("REGISTER",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {

                                      setState(() {
                                        isLoading = true;

                                      });

                                      Future.delayed(Duration(seconds: 5), (){

                                        setState(() {
                                          isLoading=false;

                                          // checking if user alreadt exist
                                          if(userData.contains("${emailController.text.trim()}")){

                                              UserExistSnackbar();
                                           }
                                           else
                                           {
                                              //encrypting the password into SHA1 hash value
                                              var byte=utf8.encode(passwordController.text.trim());
                                              sha=sha1.convert(byte);

                                              signUp(emailController.text, sha.toString());
                                           }

                                        });
                                      });
                                      
                                    }
                                  },
                                  icon: isLoading ? CircularProgressIndicator(color: Colors.white,)
                                  :Icon(Icons.arrow_forward),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 80)),
                            Text("Already have account ?",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "login");
                                },
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      
      await _auth
          .createUserWithEmailAndPassword(email: emailController.text.trim(), password: password)
          .then((value) => {postDetailsToFirestore(password)})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.messege);
      });
    }
  }

  postDetailsToFirestore(String pass) async {
    //calling a firestore

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;



//generate random number for product id
  Random random = new Random();
  int userId =random.nextInt(100);

   Map<String, dynamic> productData={
    "uid":"${user!.uid}",
    "firstname": firstnameController.text ,
    "lastname": lastnameController.text, 
    "email": emailController.text ,
    "password":pass,
    "mobilenumber":mobilenumberController.text,
    "profileImg":imgUrl};

   try{

   DocumentReference documentReference = await FirebaseFirestore.instance.collection("user_info").doc(user.uid);
   documentReference.set(productData);
   }
   catch(e){
    print(e);
   }
   print(productData);
   
    Fluttertoast.showToast(msg: "Account Created Successfully :");
    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => Test_Firebase()), (Route) => false);

  }
}
