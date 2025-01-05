import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/Admin/AdminDashboard.dart';
import 'package:make_musician/Admin/UpdateProduct.dart';

import '../Products/ProductDetail2.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {

   final List products =[];

  fetchProducts() async{
    
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("products").get();

    
      if(qn.docs.length > 0) {

      
         for(int i=0; i<qn.docs.length; i++){
          products.add(
            {"product_id": qn.docs[i]["product_id"],
              "product_name":qn.docs[i]["product_name"],
             "product_desc":qn.docs[i]["product_desc"],
             "product_img":qn.docs[i]["product_img"],
             "price":qn.docs[i]["price"],
             "quantity":qn.docs[i]["quantity"]
            });      
        }
      }

      setState(() {
        
      });
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("VIEW PRDUCTS"),

      ),

      body:Container (
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          child:Column(
            children: [
             
                Expanded(
                  child: GridView.builder(
                           scrollDirection: Axis.vertical,
                            itemCount: products.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 1,
                           childAspectRatio: 0.80), 
                          itemBuilder: (BuildContext context,index) {
                          return Card(
                             color: Colors.blue[50],
                                   elevation: 10,
                                     child: Column(
                                       children: [
                                            Container(
                                                 margin: EdgeInsets.only(top:1),
                                                 child: Image.network(products[index]["product_img"].toString(), height: 150, width: 150,),
                                                   ),
                                            Container(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  alignment: Alignment.center,
                                                  child:Row(
                                                    children: [
                                                       Text("PRODUCT NAME: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(products[index]["product_name"],
                                                      style: TextStyle(fontSize: 18, 
                                                        fontWeight: FontWeight.bold, 
                                                        color: Colors.blue),
                                                                     ),
                                                    ],
                                                  )
                                       
                                                   ),
                                       
                                                            
                                                  Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 1),
                                                        child: Row(
                                                           children: [
                                                         Text("PRODUCT PRICE: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         Text(products[index]["price"].toString()+" ₹",
                                                          style: TextStyle(fontSize: 15, 
                                                          fontWeight: FontWeight.bold, 
                                                           color: Colors.blue),
                                                                 ),
                                                        
                                                                 
                                                                 ]),
                                                             ),
                                               SizedBox( height: 2,),
                                               Padding(
                                                      padding: EdgeInsets.only(right: 160),
                                                        child: Column(
                                                           children: [
                                                         Text("PRODUCT DESCRIPTION: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         SizedBox(
                                                           child: Text(products[index]["product_desc"].toString(),
                                                            style: TextStyle(fontSize: 15, 
                                                            fontWeight: FontWeight.bold, 
                                                             color: Colors.blue),
                                                                   ),
                                                         ),
                                                                 ]),
                                                             ),

                                                  SizedBox( height: 2,),
                                               Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 1),
                                                        child: Row(
                                                           children: [
                                                         Text("QUANTITY: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         Text(products[index]["quantity"].toString(),
                                                          style: TextStyle(fontSize: 15, 
                                                          fontWeight: FontWeight.bold, 
                                                           color: Colors.blue),
                                                                 ),
                                                        
                                                                 
                                                                 ]),
                                                             ),
                                  
                                   Row(
                                      children: [
                                       Text("DELETE PRODUCT: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                       IconButton(
                                        onPressed: (){
                                          showDialog(
                                   context: context, 
                                   builder: (context)=> AlertDialog(
                                   title: Text("Product Delete", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                   content: Text("Are you sure you want to delete ?"),
                                   actions: <Widget>[
                                      TextButton(
                                      onPressed: () {
                                         Navigator.of(context).pop();
                                           },
                                         child: Container(
                                                 child: const Text("NO", style:TextStyle(fontSize: 15,
                                                                fontWeight: FontWeight.bold)),
                                                ),
                                            ),

                                   TextButton(
                                       onPressed: () {
                                           DocumentReference documentReference =FirebaseFirestore.instance.collection("products").doc("${products[index]["product_id"]}");
                                     documentReference.delete();

                                        Navigator.pushNamedAndRemoveUntil(context, "adminDashboard", (route) => false);
                                                    
                                        },
                                       child: Container(             
                                          child: const Text("YES",style:TextStyle(fontSize: 15,
                                                   fontWeight: FontWeight.bold)) ,
                                            ),
                                         ),
                                         ],
                                        )
                                        );
                                             },
                                                   icon: Icon(Icons.delete,  color: Colors.red)
                                          )
                                       ]),

                                      // Row(
                                      //    children: [
                                      //     Text("EDIT DETAILS: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                      //     IconButton(
                                      //      onPressed: (){
                                      //        Navigator.of(context).pushReplacement(
                                      //  MaterialPageRoute(builder: (context) => UpdateProduct(products[index]["product_id"].toString())));
                                      //           },
                                      //                 icon: Icon(Icons.edit,  color: Colors.black)
                                      //        )
                                      //     ]),
                                          
                                               ]),
                                         );

                                      }
                                      )
                                      )
            ],
          )
        ),
      ),
 
    );
  }
}