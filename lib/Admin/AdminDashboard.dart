import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:make_musician/Admin/AddProduct.dart';
import 'package:make_musician/Admin/ViewProduct.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

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
    return Scaffold(
      backgroundColor:Colors.orange[50],
      appBar: AppBar(
          title: Center(child: Text("ADMIN DASHBOARD")),
          actions: [
            IconButton(
              onPressed: (){
                    showDialog(
                                   context: context, 
                                   builder: (context)=> AlertDialog(
                                   title: Text("ADMIN LOGOUT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                   content: Text("Are you sure you want to logout from admin panel ?"),
                                   actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                             Navigator.of(context).pop();
                                               },
                                             child: Container(
                                                     child: const Text("NO", style:TextStyle(fontSize: 15,
                                                                    color: Colors.green,
                                                                    fontWeight: FontWeight.bold)),
                                                    ),
                                                ),

                                      TextButton(
                                           onPressed: () {
                                              
                                        Fluttertoast.showToast(msg: "Logout Successful...");
                                            
                                     Navigator.pushNamedAndRemoveUntil(context, "adminLogin", (route) => false);
                                   
                                                        
                                            },
                                           child: Container(             
                                              child: const Text("YES",style:TextStyle(fontSize: 15,
                                                       color: Colors.red,
                                                       fontWeight: FontWeight.bold)),
                                                ),
                                             ),
                                             ],
                                            )
                                            );
              }, 
              icon: Icon(Icons.logout)
              )
          ],
      ),

      body:  Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 5.0,
            right: 5.0,
            
          ),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "addProduct");
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        " Add Product",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                   Navigator.pushNamed(context, "viewProduct");
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purple),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.view_timeline,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        " View Product",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "viewOrder");
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "View Order",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                   Navigator.pushNamed(context, "viewfeedback");
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.feedback,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "View Feedback",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "viewReports");
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.stacked_bar_chart,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "View Reports",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    
    bottomNavigationBar: BottomAppBar(
      child: Text("                 Powered by MakeMusician App")),
    );


  }
}
