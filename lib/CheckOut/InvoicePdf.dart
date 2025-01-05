import 'dart:io';
import 'package:clippy_flutter/arc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/test_firebase.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class pdfFile extends StatefulWidget {
   String oid="";
   String addr="";
   String pmode="";
   pdfFile(this.oid, this.addr,this.pmode);

  @override
  State<pdfFile> createState() => _pdfFileState();
}

class _pdfFileState extends State<pdfFile> {
  final doc = pw.Document();
  File? file;
  List OrderFetchData =[];
  List UserData=[];

  double totalamount=0.0;

  fetchUserName() async{

    final user = FirebaseAuth.instance;
    var firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await firestoreinstance.collection("user_info").where("uid",isEqualTo: user.currentUser!.uid).get();

      if(qn.docs.isNotEmpty){
        for(int i=0; i<qn.docs.length;i++){

          UserData.add(
            {
              "firstname":qn.docs[i]["firstname"],
              "lastname":qn.docs[i]["lastname"],
            });
        }
      }
      setState(() {
        
      });
      print(UserData);
  }

  fetchOrderDetail() async{

    final user = FirebaseAuth.instance;
    var firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await firestoreinstance.collection("user_cart").where("uid",isEqualTo: user.currentUser!.uid).get();

    if(qn.docs.isNotEmpty) {
        for(int i=0; i<qn.docs.length; i++){
        OrderFetchData.add(
            {
              "product_name":qn.docs[i]["product_name"],
              "price":qn.docs[i]["price"],
              "quantity":qn.docs[i]["quantity"]
            });

            totalamount += int.parse(qn.docs[i]["price"]) * int.parse(qn.docs[i]["quantity"]);
      }
      
    }
    setState(() {
        
      });

  }

   DeleteCartItems() async
  {
    final user = FirebaseAuth.instance;
    
    var collection = FirebaseFirestore.instance.collection('user_cart');
    var snapshot = await collection.where('uid', isEqualTo: user.currentUser!.uid).get();
    for (var doc in snapshot.docs) {
    await doc.reference.delete();
}
  }

    @override
  void initState() {
    fetchOrderDetail();
    fetchUserName();
    super.initState();
    
  }

//Start Design of Billing

  Future<void> GeneratePdf() async {
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.topCenter,
              margin:
                  pw.EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    height: 30,
                  ),
                  pw.SizedBox(
                    child: pw.Row(
                      children: [
                        pw.Text(
                          "Make Musician",
                          style: pw.TextStyle(fontSize: 22, height: 2),
                        ),
                      ],
                    ),
                  ),
                  pw.Divider(
                    thickness: 3,
                    indent: 10,
                    endIndent: 10,
                    height: 20,
                  ),
                  pw.SizedBox(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          "INVOICE",
                          style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 100.0),
                      ),
                
                    ],
                  ),

                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Time: ",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Text(
                        "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                    pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Order id:  ${widget.oid}",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.only(left: 100.0),
                      ),
                
                    ],
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Invoice Id: ",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),

                      pw.SizedBox(height: 5),

                      pw.Text(
                        "MK${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().second}",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Customer Name: ",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.SizedBox(height: 5),

                      pw.Text(
                        "${UserData[0]["firstname"]} ${UserData[0]["lastname"]}",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Address: ",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.SizedBox(height: 5),

                      pw.Text(
                        "${widget.addr}",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 6,
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        "Payment Mode: ",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                      pw.SizedBox(height: 5),

                      pw.Text(
                        "${widget.pmode}",
                        style: pw.TextStyle(fontSize: 15, height: 1),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 30,
                  ),
                  pw.Divider(
                    thickness: 3, // thickness of the line
                    indent: 10, // empty space to the leading edge of divider.
                    endIndent:
                        10, // empty space to the trailing edge of the divider.
                    // color:
                    // Colors.grey, // The color to use when painting the line.
                    height: 20, // The divider's height extent.
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Table(
                      defaultColumnWidth: pw.FixedColumnWidth(125.0),
                      border: pw.TableBorder.all(
                          style: pw.BorderStyle.solid, width: 2),
                      children: [
                        pw.TableRow(children: [
                          pw.Column(children: [
                            pw.Text('Product Name',
                                style: pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold)) //Column-1
                          ]),
                          pw.Column(children: [
                            pw.Text('Quantity',
                                style: pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold)) //Column-2
                          ]),
                          pw.Column(children: [
                            pw.Text('Unit Price',
                                style: pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold)) //Column-3
                          ]),
                          pw.Column(children: [
                            pw.Text('Total  Amount',
                                style: pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold)) //Column-3
                          ]),
                        ]),
                        for(int i=0;i<OrderFetchData.length;i++)
                        pw.TableRow(children: [
                          pw.Column(children: [pw.Text("${OrderFetchData[i]["product_name"]}")]),
                          pw.Column(children: [pw.Text("${OrderFetchData[i]["quantity"]}")]),
                          pw.Column(children: [pw.Text("${OrderFetchData[i]["price"]} Rs.")]),
                          pw.Column(children: [pw.Text("${int.parse(OrderFetchData[i]["price"])*int.parse(OrderFetchData[i]["quantity"])} Rs.")]),
                          
                        ]),
                        
                      ]),

                  pw.SizedBox(height: 20,),
                      pw.Column(
                        children: [
                            pw.Row(
                              children: [
                                pw.Text("Total :  ", style: pw.TextStyle(fontSize:18, fontWeight: pw.FontWeight.bold),),

                                pw.SizedBox(height: 10,),
                                pw.Text("${totalamount} Rs.", style: pw.TextStyle(fontSize:18))

                            ],),

                            
                        ],
                      ),
                  pw.SizedBox(height: 50),
                  pw.Row(children: [
                    pw.Text(
                      "************************Thank you for Shopping************************",
                      style: pw.TextStyle(fontSize: 20),
                    )
                  ]),
                ],
              )

              
      );

      
        }));

    final output = await getExternalStorageDirectory(); //Get The Path
    String PathToWrite = output!.path + '/Invoice-${DateTime.now().day}${DateTime.now().month}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}.pdf'; //Path Name
    File outputFile = File(PathToWrite);
    outputFile.writeAsBytesSync(await doc.save()); //Save the pdf file

   // print(PathToWrite);
    Fluttertoast.showToast(msg: "Invoice is Saved"); //view on console
    //print("save");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(
            
            children: [

              Image.asset("images/thankyou.gif"),
              SizedBox(height: 10,),

              Text("FOR SHOPPING WITH\nMAKE MUSICIAN APP", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold),),

              Divider(height: 2,),
              SizedBox(height: 25,),

              Text("YOUR ORDER WILL BE DELIVERED WITHIH 5 DAYS.", style: TextStyle(fontSize:16, fontWeight: FontWeight.bold, color:Colors.green),),

              SizedBox(height: 25,),

              ElevatedButton(
                  onPressed: () {
                    DeleteCartItems();
                    GeneratePdf();
                    
                    Navigator.pushNamedAndRemoveUntil(context,  "firebase", (route) => false);
                  },
                  child: Text("DOWNLOAD PDF")),
            ],
          )),
    );
  }
}
