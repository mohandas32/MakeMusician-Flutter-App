import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewReports extends StatefulWidget {
  const ViewReports({super.key});

  @override
  State<ViewReports> createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  

 //String date ="${DateTime.now().day}"+"-"+"${DateTime.now().month}"+"-""${DateTime.now().year}";
  

  List orderData=[];
  List orderDataDateWise=[];
  double totalAmount=0;
  

  fetchOrderData(String date) async{

    final user = FirebaseAuth.instance;
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("user_order").get();

    
      if(qn.docs.length > 0) {

      
         for(int i=0; i<qn.docs.length; i++){
          orderData.add(
            {
              "order_date":qn.docs[i]["order_date"],
              "product_name":qn.docs[i]["product_name"],
              "price":qn.docs[i]["price"],
              "quantity":qn.docs[i]["quantity"],
              
            });      
        }
      }

        orderDataDateWise=orderData.where((element) => ((element["order_date"].contains(date)))).toList();
        orderData=orderDataDateWise;

        for(int i=0;i<orderData.length;i++)
        {
          totalAmount += int.parse(orderData[i]["price"]);
        }
        

      setState(() {
        
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    //fetchOrderData();
    super.initState();
  }

  DateTime dateTime=DateTime.now();
  DateTime? newDate;
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title:Text("REPORTS")
      ),

      body:Container(
        
        child:Column(
          children: [
            Column(
              children: [
                Text(
                          "SELECT DATE TO GET DETAILS :",
                          style: TextStyle(fontSize: 20, height: 2),
                        ),
               
                ElevatedButton(
                  onPressed: () async{
                      
                      newDate = await showDatePicker(
                        context: context, 
                        initialDate: dateTime, 
                        firstDate: DateTime(2022), 
                        lastDate: DateTime(2100)
                        );

                        if( newDate == null) return;
                        setState(() {
                          dateTime= newDate!;
                        });
                  }, 
                  child: Text("SELECT DATE")
                  ),

                  SizedBox(height: 10,),

                  ElevatedButton(
                    onPressed: (){ 
                      fetchOrderData("${dateTime.day}"+"-"+"${dateTime.month}"+"-"+"${dateTime.year}");
                      print("${dateTime.day}"+"-"+"${dateTime.month}"+"-"+"${dateTime.year}");
        
                    },

                    child: Text("GET"))

                

              ],
            ),

            SizedBox(height:20),

             orderData.length == 0 ? Container(
                  child: Center(
                    child: Column(
                      children: [

                        Text("No data avaliable")

                      ],
                    )
                    ),
                )
                :Container(
              //alignment: Alignment.topCenter,
              margin:
                  EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Text(
                          "Order List Of :",
                          style: TextStyle(fontSize: 22, height: 2),
                        ),
                      ],
                    ),
                  ),
                  
                 
                  Row(
                    children: [
                      Text(
                        "Date: ${dateTime.day}"+"/"+"${dateTime.month}"+"/"+"${dateTime.year}",
                        style: TextStyle(fontSize: 15, height: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 100.0),
                      ),
                
                    ],
                  ),
                  SizedBox(height: 10,),
                  
                  Table(
                      defaultColumnWidth: FixedColumnWidth(125.0),
                      border: TableBorder.all(
                          style: BorderStyle.solid, width: 2),
                      children: [
                        TableRow(children: [
                          Column(children: [
                            Text('Product Name',
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)) //Column-1
                          ]),
                          Column(children: [
                            Text('Quantity',
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)) //Column-2
                          ]),

                          Column(children: [
                            Text('Price',
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)) //Column-2
                          ]),
                         
                        ]),
                       
                       for(int i=0;i<orderDataDateWise.length;i++)
                        TableRow(children: [
                          Column(children: [Text("${orderDataDateWise[i]["product_name"]}")]),
                          Column(children: [Text("${orderDataDateWise[i]["quantity"]}")]),
                          Column(children: [Text("${orderDataDateWise[i]["price"]}")]),
                          
                        ]),
                        
                      ]),

                      SizedBox(height: 10,),
                      Text("Total Item Sold :  ${orderData.length}", style:TextStyle(fontSize:15)),
                      SizedBox(height: 5,),
                      Text("Total Amount :  ${totalAmount} Rs.", style:TextStyle(fontSize:15)),

                  
                 
                ],
              )

              
      )
          ],
        ))

    );
  }
}