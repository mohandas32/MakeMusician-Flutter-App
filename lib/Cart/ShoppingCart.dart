import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/CheckOut/ShippingInfo.dart';
import 'package:make_musician/test_firebase.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
 bool isLoading =false;
  
  List cartData =[];
  List orderData=[];
  double totalAmount =0.0;

  String id="";
  
  void fetchuserid() async{

  final user = FirebaseAuth.instance.currentUser;
    var var1 = await FirebaseFirestore.instance
        .collection("user_info") //collection name
        .doc(user!.uid) //id
        .get();

    setState(() {
      id = var1.data()?['uid'];
      
      
    });
    print(id);
}
  
  fetchCartData() async{

    final user = FirebaseAuth.instance;
    var firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await firestoreinstance.collection("user_cart").where("uid",isEqualTo: user.currentUser!.uid).get();

 

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

          totalAmount += int.parse(qn.docs[i]["price"])* int.parse(qn.docs[i]["quantity"]);
      }

    }

    setState(() {
      
    });
  }

 

  @override
  void initState() {
    fetchCartData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text("SHOPPING CART"),

          ),

          body: cartData.length==0 
          ?Center(child:Text("SHOPPING CART IS EMPTY", style:TextStyle(fontSize:20, fontWeight: FontWeight.bold)))
          :Container (
            child: Container(
              //padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                child:Column(
                  children: [
                    Expanded(
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: cartData.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 3.0),
                            itemBuilder: (BuildContext context,index) {
                              return Card(
                                color: Colors.blue[50],
                                elevation: 4,
                                child: Row(
                                    children: [
                                      
                                      Container(
                                        margin: EdgeInsets.only(bottom:50),
                                        child: Image.network(cartData[index]["product_img"].toString(),height: 100, width: 80,),
                                      ),
                                      Container(
                                         // padding: EdgeInsets.only(top: 10),
                                          alignment: Alignment.center,
                                          child:Column(
                                            children: [
                                              
                                              Row(
                                                children: [
                                                  Text("Prodcut name: "),
                                                  Text(cartData[index]["product_name"],
                                                    style: TextStyle(fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                                ],
                                              ),


                                              Row(
                                                children: [
                                                  Text("Prodcut price: "),
                                                  Text(cartData[index]["price"]+" ₹",
                                                    style: TextStyle(fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Text("Quantity: "),
                                                  Text(cartData[index]["quantity"],
                                                    style: TextStyle(fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )


                                      ),
                                 Container(
                                    //padding: EdgeInsets.only(bottom: 70,left: 10),
                                    child: IconButton(icon: Icon(Icons.delete), color: Colors.red, 
                                    onPressed: (){

                                showDialog(
                                   context: context, 
                                   builder: (context)=> AlertDialog(
                                   title: Text("Product Delete", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                   content: Text("Are you sure you want to delete product from cart ?"),
                                   actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                             Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Test_Firebase()));
                                               },
                                             child: Container(
                                                     child: const Text("NO", style:TextStyle(fontSize: 15,
                                                                    color: Colors.green,
                                                                    fontWeight: FontWeight.bold)),
                                                    ),
                                                ),

                                       TextButton(
                                           onPressed: () {
                                               DocumentReference documentReference =FirebaseFirestore.instance.collection("user_cart").doc(cartData[index]["cart_id"]);
                                                 documentReference.delete();
                                        Fluttertoast.showToast(msg: "Product Deleted From Cart Succesfully...");
                                            
                                    
                                      Navigator.pushNamedAndRemoveUntil(context, "firebase", (route) => false);
                                                        
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
                                         
                                    

                                        }),
                                      )
                                     
                                    ]),
                              );

                            }
                        )
                    )
                  ],
                )



            ),
          ),

          bottomNavigationBar: BottomAppBar(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            height: 130,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount",
                    style:TextStyle(
                              fontSize: 22, 
                              color: Colors.blue,
                              fontWeight: FontWeight.bold, )
                        ),

                        Text("$totalAmount"+" ₹",
                              style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue
                              ),
                              )
                        ],
                ),

                Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),


                      child: SizedBox(
                        height: 50,
                        width: 400,
                            child: ElevatedButton(
                              onPressed: () {  

                                 if(cartData.length==0)
                                   {
                          
                                    Fluttertoast.showToast(msg: "YOUR CART IS EMPTY");
                                    }
                                else{
                                            setState(() {
                                          isLoading=true;
                                        });

                                      Future.delayed(Duration(seconds: 4),(){
                                        setState(() {
                                          isLoading=false;

                                           Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingInfo(totalAmount)));
                                        });
                                      });
                                    }
                              },
                              child: isLoading ? CircularProgressIndicator(color: Colors.white,)
                              :Text("CHECKOUT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                              ),
                        ),
                    // child: InkWell(
                    //   onTap: () {
                    //      if(cartData.length==0)
                    //      {
                          
                    //       Fluttertoast.showToast(msg: "YOUR CART IS EMPTY");
                    //      }
                    //      else{
                         
                    //      Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingInfo(totalAmount)));
                    //      }
                    //      },
                    //   child: Row(
                    //     children: [
                    //       Padding(padding: EdgeInsets.only(left:130)),
                    //       Text("Checkout",
                    //                 style:TextStyle(fontSize: 20,
                    //                                 fontWeight: FontWeight.bold,
                    //                                  color: Colors.black)),
                          
                    //     ],
                    //   ),
                    // )
                )

              ]),
        )
    ),




        );
  }
}