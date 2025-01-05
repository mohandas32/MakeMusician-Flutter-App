import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/CheckOut/InvoicePdf.dart';
import 'package:make_musician/test_firebase.dart';

class CashOnDelivery extends StatefulWidget {
  String addr;
  CashOnDelivery(this.addr);

  @override
  State<CashOnDelivery> createState() => _CashOnDeliveryState();
}

class _CashOnDeliveryState extends State<CashOnDelivery> {

  int? _val = 0;
  double totalAmount=0.0;
  String PaymentMode="Cash On Delivery";


  String PrintDate(){

     var datetime= DateTime.now();
     return "${datetime.day}-${datetime.month}-${datetime.year}";
  }

  String PrintTime(){

     var datetime= DateTime.now();
     return "${datetime.hour}:${datetime.minute}:${datetime.second}";
  }

  void PlaceOrder() async
  {

    final user = FirebaseAuth.instance;
    var firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await firestoreinstance.collection("user_cart").where("uid",isEqualTo: user.currentUser!.uid).get();

    List OrderData =[];
    

 

    if(qn.docs.isNotEmpty) {


      for(int i=0; i<qn.docs.length; i++){
        OrderData.add(
            {
              "product_id":qn.docs[i]["product_id"],
              "product_name":qn.docs[i]["product_name"],
              "price":qn.docs[i]["price"],
              "quantity":qn.docs[i]["quantity"]
            });

          totalAmount += int.parse(qn.docs[i]["price"])* int.parse(qn.docs[i]["quantity"]);
      }

    }
   

    setState(() {
      
    });
    
    for(int i =0 ; i< OrderData.length;i++)
  {
                
              int order_id =Random().nextInt(200);
   
               Map<String,dynamic> OrderPlaceData=
                {
                "order_id":order_id,
                "order_date":PrintDate(),
                "order_time":PrintTime(),
                "user_id":user.currentUser!.uid,
                "product_id":OrderData[i]["product_id"],
                "product_name": OrderData[i]["product_name"],
                "price": OrderData[i]["price"],
                "quantity": OrderData[i]["quantity"],
                "total_price": int.parse(OrderData[i]["quantity"]) * int.parse(OrderData[i]["price"]),
                "address":widget.addr,
                "Payment Mode":"Cash On Delivery"
                };


                DocumentReference documentReference = FirebaseFirestore.instance.collection("user_order").doc("o_$order_id");
                documentReference.set(OrderPlaceData);        
      } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100,),

              Text("SELECT CASH ON DELIVERY",
                    style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight:FontWeight.bold),
                    ),

              SizedBox(height: 60,),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _val,
                    onChanged: (value) {
                      setState(() {
                        _val=value;
                      });
                    },
                    activeColor: Colors.green,
                  ),

                  Text("Cash On Delivery",
                       style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),)
                ],),

                SizedBox(height: 50,),

                ElevatedButton(
                onPressed: (){
                  if(_val == 0){
                    Fluttertoast.showToast(msg: "Please Select Payment Option");
                  }
                  else
                    showOrderDialog();
                }, 
                child: Text("CONFORM ORDER")
                )
            ]),
        ) ,)
    );
  }

                  showOrderDialog(){
                    showDialog(
                                   context: context, 
                                   builder: (context)=> AlertDialog(
                                   title: Text("**ORDER CONFORM**", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                   content: Text("Conform Your Order By Clicking On Yes"),
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
                                              PlaceOrder();

                                                Fluttertoast.showToast(msg: "Order Placed Succesfully");

                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(builder: (context) => pdfFile("23",widget.addr,PaymentMode)));


                                                        
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
  }
}