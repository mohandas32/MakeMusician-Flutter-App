import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {

    final List products =[];

  fetchOrders() async{
    
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("user_order").get();

    
      if(qn.docs.length > 0) {

      
         for(int i=0; i<qn.docs.length; i++){
          products.add(
            {
              "order_id":qn.docs[i]["order_id"],
              "order_date": qn.docs[i]["order_date"],
              "product_id": qn.docs[i]["product_id"],
              "product_name":qn.docs[i]["product_name"],
              "user_id":qn.docs[i]["user_id"],
              "price":qn.docs[i]["price"],
              "quantity":qn.docs[i]["quantity"],
              "total_price":qn.docs[i]["total_price"],
              "address": qn.docs[i]["address"],
              "payment_mode": qn.docs[i]["Payment Mode"]
            });      
        }
      }

      setState(() {
        
      });
  }

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VIEW ORDER"),

      ),

      body:Container (
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          child:Column(
            children: [
             
          SizedBox(height: 5,),
      
      
                Expanded(
                  child: GridView.builder(
                           scrollDirection: Axis.vertical,
                            itemCount: products.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 1,
                           childAspectRatio: 1.28), 
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
                                                       Text("ORDER ID: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(products[index]["order_id"].toString(),
                                                      style: TextStyle(fontSize: 12, 
                                                        fontWeight: FontWeight.bold, 
                                                        color: Colors.blue),
                                                                     ),
                                                    ],
                                                  )
                                       
                                                   ),

                                            Container(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  alignment: Alignment.center,
                                                  child:Row(
                                                    children: [
                                                       Text("ORDER DATE: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(products[index]["order_date"].toString(),
                                                      style: TextStyle(fontSize: 12, 
                                                        fontWeight: FontWeight.bold, 
                                                        color: Colors.blue),
                                                                     ),
                                                    ],
                                                  )
                                       
                                                   ),

                                            
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
                                                    ],
                                                  )
                                       
                                                   ),

                                                  Container(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  alignment: Alignment.center,
                                                  child:Row(
                                                    children: [
                                                       Text("USER ID: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(products[index]["user_id"],
                                                      style: TextStyle(fontSize: 12, 
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
                                          SizedBox( height: 5,),
                                               Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 1),
                                                        child: Row(
                                                           children: [
                                                         Text("ADDRESS: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         Text(products[index]["address"],
                                                          style: TextStyle(fontSize: 12, 
                                                          fontWeight: FontWeight.bold, 
                                                           color: Colors.blue),
                                                                 ),
                                                        
                                                                 
                                                                 ]),
                                                             ),
                                          SizedBox( height: 5,),
                                               Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 1),
                                                        child: Row(
                                                           children: [
                                                         Text("PAYMENT MODE: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                         Text(products[index]["payment_mode"].toString(),
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