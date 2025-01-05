import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/CheckOut/InvoicePdf.dart';
import 'package:make_musician/test_firebase.dart';

class PaymentSucess extends StatelessWidget {
  String oid="";
  String addr="";
  PaymentSucess(this.oid, this.addr);

  
  String PaymentMode="Credit Card";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
              padding: EdgeInsets.only( 
                left:15, top: 100),
              child: Column(
                children: [

                  Image.asset("images/paymentsuccess.gif"),
                  Text("PAYMENT SUCCESSFULL", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  SizedBox(height: 100,),
                
                  SizedBox(height: 10,),
                   SizedBox(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => pdfFile(oid,addr, PaymentMode)));
                      }, 
                      child: Text("OK", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                      ),
                  )
                ],
              )

              ),

    );
  }
}