import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/test_firebase.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {

      final List products =[];

  fetchProducts() async{

    final user = FirebaseAuth.instance;
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("user_order").where("user_id",isEqualTo: user.currentUser!.uid).get();

    
      if(qn.docs.length > 0) {

      
         for(int i=0; i<qn.docs.length; i++){
          products.add(
            {
              "order_id":qn.docs[i]["order_id"],
              "product_name":qn.docs[i]["product_name"],
              "price":qn.docs[i]["price"],
              "quantity":qn.docs[i]["quantity"],
              "total_price":qn.docs[i]["total_price"]
            });      
        }
      }
      //print(products);

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
        title: const Text("MY ORDER"),

      ),

      body:products.length ==0 ? Center( child: Text("NO ORDER PLACED...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      )
      )
      :Container (
        child: Container(
          child:Column(
            children: [
             
          SizedBox(height: 5,),
      
      
                Expanded(
                  child: GridView.builder(
                           scrollDirection: Axis.vertical,
                            itemCount: products.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 1,
                           childAspectRatio: 2.50), 
                          itemBuilder: (BuildContext context,index) {
                          return Card(
                             color: Colors.blue[50],
                                   elevation: 10,
                                     child: Column(
                                       children: [       
                                            Container(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  alignment: Alignment.center,
                                                  child:Row(
                                                    children: [
                                                       Text("PRODUCT NAME: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(products[index]["product_name"],
                                                      style: TextStyle(fontSize: 12, 
                                                        fontWeight: FontWeight.bold, 
                                                        color: Colors.blue),
                                                                     ),

                                                        Spacer(),
                                                        IconButton( 
                                                          icon: Icon(Icons.delete), color: Colors.red,
                                                          onPressed: (){
                                showDialog(
                                   context: context, 
                                   builder: (context)=> AlertDialog(
                                   title: Text("Order Cancel", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                   content: Text("Are you sure you want to cancel your order ?"),
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
                                               DocumentReference documentReference =FirebaseFirestore.instance.collection("user_order").doc("o_${products[index]["order_id"]}");
                                                 documentReference.delete();
                                        Fluttertoast.showToast(msg: "Order Deleted Succesfully...");
                                            
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
                                                          })
                                              
                                                    ],
                                                  )
                                       
                                                   ),
          
                                                  Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 1),
                                                        child: Row(
                                                           children: [
                                                         Text("PRODUCT PRICE: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         Text(products[index]["price"].toString()+" ₹",
                                                          style: TextStyle(fontSize: 12, 
                                                          fontWeight: FontWeight.bold, 
                                                           color:Colors.blue),
                                                                 ),
                                                        
                                                                 
                                                                 ]),
                                                             ),
                                               SizedBox( height: 5,),
                                               Padding(
                                                      padding: EdgeInsets.only(right:0),
                                                        child: Row(
                                                           children: [
                                                         Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         SizedBox(
                                                           child: Text(products[index]["quantity"].toString(),
                                                            style: TextStyle(fontSize: 12, 
                                                            fontWeight: FontWeight.bold, 
                                                             color: Colors.blue),
                                                                   ),
                                                         ),
                                                                 ]),
                                                             ),

                                                  SizedBox( height: 5,),
                                               Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 1),
                                                        child: Row(
                                                           children: [
                                                         Text("TOTAL PRICE: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         Text(products[index]["total_price"].toString()+ " ₹",
                                                          style: TextStyle(fontSize: 12, 
                                                          fontWeight: FontWeight.bold, 
                                                           color: Colors.blue),
                                                                 ),
                                                                 
                                                                 ]),
                                                             ),
                                  
                                  
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