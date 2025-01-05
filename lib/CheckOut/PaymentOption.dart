import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/CheckOut/CashOnDelivery.dart';
import 'package:make_musician/CheckOut/CreditCardOption.dart';

class PaymentOption extends StatefulWidget {
  String addr;
  double totalAmount=0.0;
  PaymentOption(this.addr, this.totalAmount);

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {

  //String address = widget.addr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            

            children: [
               SizedBox(height: 100),

               Text("AVAILABLE PAYMENT OPTIONS", 
                    style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              
              SizedBox(height: 100),

              ElevatedButton(
                onPressed: (){
                  String addresscash=widget.addr;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CashOnDelivery(addresscash)));
                }, 
                child: Text("CASH ON DELIVERY")
                ),

                ElevatedButton(
                onPressed: (){
                  String addresscard=widget.addr;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreditCardPayment(addresscard, widget.totalAmount)));
                }, 
                child: Text("CREDIT CARD")
                )
            ]),
        ) ,)
    );
  }
}