
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/CheckOut/PaymentSuccess.dart';
import 'package:make_musician/CheckOut/InvoicePdf.dart';
import 'package:make_musician/test_firebase.dart';

class CreditCardPayment extends StatefulWidget {
  String addr;
  double totalAmount= 0.0;
  CreditCardPayment(this.addr, this.totalAmount);

  @override
  State<CreditCardPayment> createState() => CreditCardPaymentState();
}

class CreditCardPaymentState extends State<CreditCardPayment> {

  String cardNumber="";
  String expiryDate="";
  String cardHolderName="";
  String cvvCode="";
  bool showBackView = false;

  double totalAmount=0.0;

  bool isLoading=false;
 
  

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String PrintDate(){

     var datetime= DateTime.now();
     return "${datetime.day}-${datetime.month}-${datetime.year}";
  }

  String PrintTime(){

     var datetime= DateTime.now();
     return "${datetime.hour}:${datetime.minute}:${datetime.second}";
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel)
  {
    setState(()  {
        cardNumber=creditCardModel.cardNumber;
        cardHolderName =creditCardModel.cardHolderName;
        expiryDate =creditCardModel.expiryDate;
        cvvCode = creditCardModel.cvvCode;
      
        showBackView =creditCardModel.isCvvFocused;
    });
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

            setState(() {
              totalAmount += int.parse(qn.docs[i]["price"])* int.parse(qn.docs[i]["quantity"]);
            });

          
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
                "Payment Mode":"Credit Card"
                };


                DocumentReference documentReference = FirebaseFirestore.instance.collection("user_order").doc("o_$order_id");
                documentReference.set(OrderPlaceData);    

                  
                  
      } 

  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber, 
              expiryDate: expiryDate, 
              cardHolderName: cardHolderName, 
              cvvCode: cvvCode, 
              showBackView: showBackView,
              
              height: 200, 
            
              onCreditCardWidgetChange: (CreditCardBrand ) {  },
              ),
              Expanded(
                child: SingleChildScrollView(
              
                  child: Column(
                    children: [
                      CreditCardForm(
                        cvvCode: cvvCode,
                        cardNumber: cardNumber, 
                        expiryDate: expiryDate, 
                        cardHolderName: cardHolderName,
                        formKey: formKey, 
                        obscureNumber: true,
                        obscureCvv: true,
                        onCreditCardModelChange: onCreditCardModelChange, 
                        themeColor: Colors.brown,
                        ),
              
                        Text("Payable Amount: ${widget.totalAmount} ₹",
                                style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold,))
                    ],
                  ),
              
                  
                    
                  ),
              ),
                SizedBox(height: 20,),

                  ElevatedButton(
                    
                    onPressed: () {
                      if(formKey.currentState!.validate()){

                        setState(() {
                          isLoading=true;
                        });

                        Future.delayed(Duration(seconds: 6),(){

                          setState(() {
                            isLoading=false;

                            PlaceOrder();
                        
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PaymentSucess("50", widget.addr)));
                            
                          });
                        });
                        
                        
                      }
                    },
                  child: isLoading? CircularProgressIndicator(color: Colors.white,)
                  :Text("Make Payment"))

                  
          ]),
      )
    );
  }

}