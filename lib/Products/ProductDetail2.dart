import 'dart:math';
import 'package:clippy_flutter/arc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/Cart/ShoppingCart.dart';


class ProductDetail2 extends StatefulWidget {
  var _product;
  ProductDetail2(this._product);
  

  @override
  State<ProductDetail2> createState() => _ProductDetail2State();

}

class _ProductDetail2State extends State<ProductDetail2> {
  int quantity= 1;
  String id="";
  
  bool isLoading=false;

// AudioPlayer audioPlayer = AudioPlayer();
//   playLocal()  {
    
//     var result =  audioPlayer.setSourceUrl("");
//   }

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

  
  void addToCart(){

    int cart_id =Random().nextInt(200);
    Map<String,dynamic> cartData={
                                  "cart_id":"cart_$cart_id",
                                  "uid":id,
                                  "product_id":widget._product["pid"],
                                  "product_name":widget._product["product_name"],
                                  "product_img":widget._product["product_img"],
                                  "price":widget._product["price"],
                                  "quantity":quantity.toString()
                                  };

    DocumentReference documentReference = FirebaseFirestore.instance.collection("user_cart").doc("cart_$cart_id");
    documentReference.set(cartData);

    //print(cartData);
  }
  @override
  void initState() {
    fetchuserid();
    addToCart();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
              backgroundColor: Color(0xFFEDECF2),
              appBar: AppBar(
                title: Text("Product Detail"),
                backgroundColor: Colors.blue[200],
                leading: IconButton(
                                icon: Icon(Icons.arrow_back), 
                                onPressed: () { 
                                      Navigator.pop(context);
                                 },),
                centerTitle: true,
              ),

              body: ListView(
                        children: [
                            Padding(padding: EdgeInsets.all(16),
                              child: Image.network(widget._product["product_img"], height: 300)
                            ),

                            Arc(edge: Edge.TOP,
                              arcType: ArcType.CONVEY,
                              height: 30, 
                              child: Container(
                                 width:double.infinity,
                                 color: Colors.white,
                               child: Padding(padding: EdgeInsets.only(top: 50, bottom: 20),
                                    child:Column(
                                          children: [
                                            
                                            // Text(widget._product["pid"], 
                                            //   style:TextStyle(
                                            //   fontSize: 28,
                                            //   fontWeight: FontWeight.bold)
                                            //   ),

                                           Text(widget._product["product_name"], 
                                              style:TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)
                                              ),

                                          Container(
                                              padding: EdgeInsets.only(top:10, left: 5, bottom: 5),
                                                 child:Column(
                                                   children: [
                                                        Text(widget._product["product_desc"],
                                                           style:TextStyle(fontSize: 20)
                                                            ),

                                      Text("${widget._product["price"]}"+ " ₹", 
                                              style:TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)
                                              ),
                                                          
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Container(
                                          child: Text("Select Quantity:      ", 
                                          style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold))
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                            )
                                          ]
                                    ),

                                    child: InkWell(
                                      onTap: () { setState(() {
                                        quantity--;
                                        if(quantity<1) 
                                        {
                                          quantity=1;
                                          Fluttertoast.showToast(msg: "Invalid Quantity");
                                        }
                                      });
                                      },
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        size:22,
                                    
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 40,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text("$quantity"),
                                    
                                  
                              ),
                                     Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                            )
                                          ]
                                    ),

                                    child: InkWell(
                                      onTap: (){ setState(() {
                                        quantity++;

                                        //if quantity is greater than the items in stock
                                        if(quantity > int.parse(widget._product["quantity"]))
                                        {
                                          quantity = int.parse(widget._product["quantity"]);
                                          Fluttertoast.showToast(msg: "Out of stock");
                                        }
                                      });
                                      },
                                      child: Icon(
                                        CupertinoIcons.plus,
                                        size:22,
                                    
                                      ),
                                    ),
                                  )

                              ],)
                            ],
                           ),

                        )
                         ],                             
                      )
                       )
                  ),
                                                                                
          )
                                    
            ],


         ),

         bottomNavigationBar:
         BottomAppBar(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            height: 80,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                SizedBox(
                  height: 50,
                  width: 400,
                  
                  child: ElevatedButton(
                    onPressed: (){

                      setState(() {
                        isLoading=true;
                      });

                      Future.delayed(Duration(seconds: 3),(){
                        setState(() {
                          isLoading=false;

                           addToCart();
                              Fluttertoast.showToast(msg: "Product Added to cart");
                              Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ShoppingCart()));
                        });
                      });

                     
                               
                    }, 
                    child: isLoading?CircularProgressIndicator(color: Colors.white,)
                    :Text("ADD TO CART", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                    
                    ),
                )
                // Container(
                //     alignment: Alignment.center,
                //     height: 50,
                  
                //     decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.circular(20),
                //     ),

                //     child: InkWell(
                //       onTap: () {
                //         setState(() {
                //           isLoading=true;
                //         });

                //         Future.delayed(Duration(seconds: 5),(){

                //         setState(() {
                //           isLoading=false;
                //         });

                //         });
                //               addToCart();
                //               Fluttertoast.showToast(msg: "Product Added to cart");
                //               Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => ShoppingCart()));
                               
                //       },
                //       child: Row(
                //         children: [
                //           Padding(padding: EdgeInsets.symmetric(horizontal:50)),

                //           isLoading ? CircularProgressIndicator(color: Colors.white,)
                                
                //           :Text("ADD TO CART",
                //                     style:TextStyle(fontSize: 20,
                //                                     fontWeight: FontWeight.bold,
                //                                      color: Colors.black)),
                          
                //         ],
                //       ),
                //     )
                // )

              ]),
        )
    )
      );
  }
}