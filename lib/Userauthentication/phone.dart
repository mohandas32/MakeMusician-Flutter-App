import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:make_musician/Userauthentication/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  bool isLoading = false;
  TextEditingController countrycode = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  String phone = "";


  bool isButtonClickable = true;
  @override
  void initState() {
    // TODO: implement initState
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        margin: EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/img2.png', width: 290, height: 300),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 20),
              Text(
                'Phone Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'We need to Register your phone before getting Started!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 19,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countrycode,
                        decoration: InputDecoration(border: InputBorder.none),
                        enabled: false,
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        controller: mobileTextController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone Number",
                            counterText: ""),
                        maxLength: 10,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      isButtonClickable = false;
                    });
                    if (phone == "" || phone.length < 10 || phone.length > 10) {
                      Future.delayed(Duration(milliseconds: 200), () {
                        setState(() {
                          isLoading = false;
                          isButtonClickable = true;
                        });
                        //print("Clickable");
                        
                      });

                      
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Please Enter Valid Number"),
                            );
                          });
                    } else {
                      print(phone.length);
                      print(phone);
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${countrycode.text + phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {
                          Future.delayed(Duration(), (() {
                            setState(() {
                              isLoading = false;
                              isButtonClickable = true;
                            });
                          }));
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          Future.delayed(Duration(seconds: 1), (() {
                            setState(() {
                              isLoading = false;
                              isButtonClickable = true;
                            });
                          }));
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Please Enter Valid Number"),
                                );
                              });
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          MyPhone.verify = verificationId;
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>MyOtp("phone")));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Send The Code'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
