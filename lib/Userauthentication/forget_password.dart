import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forget_Password extends StatefulWidget {
  const Forget_Password({super.key});

  @override
  State<Forget_Password> createState() => _Forget_PasswordState();
}

class _Forget_PasswordState extends State<Forget_Password> {
  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>(); //key for form
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context,"login");
          },
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blue.shade100,
        margin: EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/forgot_password.png',
                  width: 200, height: 200),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 20),
              Text(
                'Forgot password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Please Enter Your Email',
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
                      width: 17,
                    ),
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              counterText: ""),
                          validator: (value) {
                            SizedBox(height: 10);
                            if (value!.isEmpty) {
                              return "Please Enter E-mail";
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[-\w]{2,4}')
                                .hasMatch(value)) {
                              return "Please Enter Valid E-mail";
                            }
                          },
                        ),
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
                  onPressed: () {
                    resetPassword();
                  },
                  child: Text(
                    "Send Mail",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  resetPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              'E-mail has been sent to your registered mail id',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blue,
              content: Text(
                'No User Found for that Email',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    } else {}
  }
}




  //     body: Stack(
  //       children: [
  //         Container(
  //           child: Form(
  //             key: formKey,
  //             child: Align(
  //               alignment: Alignment.topCenter,
  //               child: Column(children: [
  //                 Text(
  //                   "Hello this is forget page",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontSize: 30),
  //                 ),
  //                 Padding(padding: EdgeInsets.only(left: 30, top: 30)),
  //                 TextFormField(
  //                   controller: emailController,
  //                   decoration: InputDecoration(
  //                     hintText: "Enter E-Mail",
  //                     labelText: "E-mail",
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                   validator: (value) {
  //                     if (value!.isEmpty) {
  //                       return "Please Enter E-mail";
  //                     } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[-\w]{2,4}')
  //                         .hasMatch(value)) {
  //                       return "Please Enter Valid E-mail";
  //                     }
  //                   },
  //                 ),
  //                 SizedBox(
  //                   width: 20,
  //                   height: 20,
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: (() {
  //                     setState(() {
  //                       email = emailController.text;
  //                     });
  //                     resetPassword();
  //                   }),
  //                   child: (Text(
  //                     "Send Email",
  //                     textAlign: TextAlign.center,
  //                   )),
  //                 ),
  //               ]),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );