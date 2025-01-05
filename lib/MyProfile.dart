import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class EditProfileUI extends StatefulWidget {
  @override
  _EditProfileUIState createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  bool isObscurePassword = true;

  String firstname = "";
  String lastname = "";
  String email = "";
  String mobile_number = "";
  String? profilePic;
  bool isValid = false; //key for form

  static bool isProfileImageUploded =false;
  
  String imgPath ="";
  String imgUrl ="";
  String profilePicUrl ="";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController mobileController =  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void getProfileData() async {

   final user = FirebaseAuth.instance.currentUser;
    var var1 = await FirebaseFirestore.instance
        .collection("user_info") //collection name
        .doc(user!.uid) //id
        .get();

    
      firstname = var1.data()?['firstname'];
      lastname = var1.data()?['lastname'];
      email = var1.data()?['email'];
      mobile_number = var1.data()?['mobilenumber'];
      profilePicUrl=var1.data()?['profileImg'];
      setState(() {
        
      
    });    
  }

  
  @override
  void initState() {
    getProfileData(); // get The Data
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('User Profile'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(children: [
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        height: 130,
                        child:Image.network(profilePicUrl,)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: firstNameController =TextEditingController(text:"$firstname"),
                    onChanged: ((value) {
                      firstname = value;
                    }),
                    decoration: InputDecoration(
                        labelText: "First Name"),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Field must be filled";
                      else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                        return "Only alphabets allowed.";
                    },
                  ),
                  TextFormField(
                    controller: lastNameController = TextEditingController(text:"$lastname"),
                    decoration: InputDecoration(
                      
                        labelText: "Last Name"),
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Field must be filled";
                      else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                        return "Only alphabets allowed.";
                    },
                  ),
                  TextFormField(
                    controller: emailController= TextEditingController(text: "$email"),
                    decoration: InputDecoration(
                  
                        labelText: "Email"),
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
                    validator: (value) {
                      if (value!.isEmpty)
                        return "Field must be filled";
                      else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[-\w]{2,4}')
                          .hasMatch(value)) return "Please Enter Valid E-mail";
                    },
                  ),
                  TextFormField(
                      controller: mobileController =TextEditingController(text: "$mobile_number"),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        
                          labelText: "Mobile Number"),
                      validator: (value) {
                        if (value!.isEmpty)
                          return "Field must be filled";
                        else if (!RegExp(r'[0-9]{10}').hasMatch(value))
                          return "Enter Valid Mobile Number";
                      }),
                ]),
              ),
            ),
            SizedBox(height: 30),
         
          ]),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                    onPressed: () {})
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )),
      ),
    );
  }

  

  saveInfo() {
    // setState(() {
    //   isSaving = true;
    // });
    // uploadImage(File(profilePic!), 'profile').whenComplete(() {
    try {
      Map<String, dynamic> data = {
        'uid':FirebaseAuth.instance.currentUser,
        'firstname': firstname,
        'lastname': lastNameController.text,
        'email': emailController.text,
        'mobilenumber': mobileController.text,
        'profilepic': imgUrl,
      };
      print(lastNameController.text);
      FirebaseFirestore.instance
          .collection('user_info')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!
            .updateDisplayName(firstNameController.text)
            .whenComplete(() {
          Navigator.pushNamedAndRemoveUntil(
              context, 'home_page', (route) => false);
          print("Updated");
          isProfileImageUploded=true;
          // setState(() {
          //   isSaving = false;
          // });
        });
      });
    } catch (e) {
      print(e.toString());
    }
    // });
  }
}
