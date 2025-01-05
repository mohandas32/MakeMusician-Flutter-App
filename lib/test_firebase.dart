
import 'dart:async';

import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:make_musician/Products/ProductDetail2.dart';
import 'package:make_musician/SearchProduct.dart';
import 'package:make_musician/Userauthentication/login.dart';
import 'package:make_musician/main.dart';
import 'Categories/CategoriesWidget.dart';

class Test_Firebase extends StatefulWidget {
  const Test_Firebase({super.key});

  @override
  State<Test_Firebase> createState() => _Test_FirebaseState();
}

class _Test_FirebaseState extends State<Test_Firebase> {

String id="";
String firstname = "";
String lastname = "";
String email = "";
String profileImgUrl="";

 final _formKey = GlobalKey<FormState>();

 TextEditingController searchController = TextEditingController();

  void getProfileData() async {

   final user = FirebaseAuth.instance.currentUser;
    var var1 = await FirebaseFirestore.instance
        .collection("user_info") //collection name
        .doc(user!.uid) //id
        .get();

    setState(() {
      firstname = var1.data()?['firstname'];
      lastname = var1.data()?['lastname'];
      email = var1.data()?['email'];
      profileImgUrl = var1.data()?['profileImg'];
    
      
    });  

   // print("$firstname\n$lastname\n$email");  
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await Storage.delete(key: "uid");
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
          
  List products =[];

  fetchProducts() async{
    
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("products").get();

         for(int i=0; i<qn.docs.length; i++){
          products.add(
            {
             "pid":qn.docs[i]["product_id"],
             "product_name":qn.docs[i]["product_name"],
             "product_desc":qn.docs[i]["product_desc"],
             "product_img":qn.docs[i]["product_img"],
             "price":qn.docs[i]["price"],
             "quantity":qn.docs[i]["quantity"]
            });

        }
     setState(() { 
     });
  }
 

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
    getProfileData();
    fetchProducts();
    fetchCartData();
    getConnectivity();
    super.initState();
  }

  List cartData =[];
  fetchCartData() async{

    final user = FirebaseAuth.instance;
    var firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await firestoreinstance.collection("user_cart").where("uid",isEqualTo: user.currentUser!.uid).get();

  setState(() {

    if(qn.docs.isNotEmpty) {


      for(int i=0; i<qn.docs.length; i++){
        cartData.add(
            {"cart_id": qn.docs[i]["cart_id"],
              "product_name":qn.docs[i]["product_name"],
              "user_id":qn.docs[i]["uid"],
              "product_img":qn.docs[i]["product_img"],
              "price":qn.docs[i]["price"],
              "quantity":qn.docs[i]["quantity"]
            });   
      }
    }      
    });
  }

  @override
  Widget build(BuildContext context) {
    // fetchProducts();
    //getProfileData();
     getConnectivity();
    return Scaffold(
      backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text("Make Musician", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.blue[100],
          elevation: 0.0,
          actions: <Widget>[

            Badge(
              badgeContent: Text("${cartData.length}"),
              child: IconButton(
              onPressed: (){
                  Navigator.pushNamed(context, "cart");
              },
              icon: Icon(Icons.shopping_cart),
              color: Colors.black,),
              badgeColor: Colors.red,
              position: BadgePosition.topStart()
            )
            
          ],
        ),

        drawer: Drawer(
          backgroundColor: Colors.blue[100],
              child: ListView(
                
                children: [
                        DrawerHeader(
                            child: UserAccountsDrawerHeader(
                            
                            accountName: Text("$firstname $lastname",
                                            style: TextStyle(fontSize: 18),
                                            ),
                            accountEmail: Text("$email",
                                            style: TextStyle(fontSize: 18),
                                            ),
                        )
                        ),

                      ListTile(
                        leading: Icon(CupertinoIcons.home),
                        title: Text("Home",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        onTap: () => Navigator.pushNamed(context, "firebase"),
                        ),

                        ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text("My Account",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        onTap: () => Navigator.pushNamed(context, "myProfile"),
                        ),

                        ListTile(
                        leading: Icon(CupertinoIcons.cart),
                        title: Text("Shopping Cart",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        onTap: () => Navigator.pushNamed(context, "cart"),
                        ),

                        ListTile(
                        leading: Icon(Icons.shopping_bag),
                        title: Text("My Order",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        onTap: () => Navigator.pushNamed(context, "myorder"),
                        ),

                        ListTile(
                        leading: Icon(Icons.feedback),
                        title: Text("Feedback",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        onTap: () => Navigator.pushNamed(context, "feedback"),
                        ),

                        ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Sign Out",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        onTap: () {
                        logout(context);
                          
                        }
                        ), 
                ],
              ), 
              ),


        body: SafeArea(
            child: Container(
              child: Column(
                    children: [
                        Container(
                    
                    padding: EdgeInsets.only(top: 15),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                    
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          height: 50,
                          width:280,
                          child: TextFormField(
                              controller: searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search Here..",
                              ),
                          )
                        ),
                        Spacer(),
                        
                        IconButton(
                          
                          onPressed: () {
                            if(!searchController.text.isEmpty)
                            {
                              
                            
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchProduct(searchController.text.trim())));
                            }
                          }, 
                          icon: Icon(Icons.search))

                    ]),
                  ),

                   Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    // ignore: prefer_const_constructors
                    child: Text("Categories",
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                                  ),

                  ),

                  //calling ContainerWidget
                  CategoriesWidget(),

                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text("All Products",
                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                                  ),
                    
                  ),
                      Expanded(
                          child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: products.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.83), 
                                    itemBuilder: (BuildContext context,index) {
                                      return GestureDetector(
                                        onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (_) =>ProductDetail2(products[index]))),
                                        child: Card(
                                          color: Colors.blue[50],
                                          elevation: 10,
                                          child: Column(
                                              children: [
                                                  Container(
                                                        margin: EdgeInsets.all(10),
                                                        child: Image.network(products[index]["product_img"].toString(), height: 100, width: 100,),
                                                  ),
                                                  
                                                  // Container(
                                                  //               child:Text(products[index]["pid"],
                                                  //                     style: TextStyle(fontSize: 18, 
                                                  //  fontWeight: FontWeight.bold, 
                                                  //  color: Colors.blue),
                                                  //               )
                                      
                                                  //           ),

                                                            Container(
                                                                padding: EdgeInsets.only(bottom: 10),
                                                                alignment: Alignment.center,
                                                                child:Text(products[index]["product_name"],
                                                                      style: TextStyle(fontSize: 18, 
                                                   fontWeight: FontWeight.bold, 
                                                   color: Colors.blue),
                                                                )
                                      
                                                            ),
                                                            Container(
                                                              child:Text(products[index]["price"].toString()+" ₹",
                                                                  style: TextStyle(fontSize: 15, 
                                                   fontWeight: FontWeight.bold, 
                                                   color: Colors.black),
                                                                ),
                                                              )
                                              ]),
                                        ),
                                      );

                                    }
                                    )
                                    
                                    
                                    )
                            
                    ]),
            ),
          
          
        )

    );
  }
}