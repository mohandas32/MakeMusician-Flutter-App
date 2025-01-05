import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Products/ProductDetail2.dart';

class KeyboardCategory extends StatefulWidget {
  const KeyboardCategory({super.key});

  @override
  State<KeyboardCategory> createState() => _KeyboardCategoryState();
}

class _KeyboardCategoryState extends State<KeyboardCategory> {

   final List products =[];

  fetchCategoryData() async{

    var firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await firestoreinstance.collection("products").where("product_category",isEqualTo: "Keyboard").get();

 

    if(qn.docs.isNotEmpty) {


      for(int i=0; i<qn.docs.length; i++){
        products.add(
            {
            "pid":qn.docs[i]["product_id"],
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
    fetchCategoryData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(products);

    return Scaffold(
      appBar: AppBar(
        title: const Text("KEYBOARD INSTRUMENTS"),

      ),

      body: products.length ==0 ? Center(
        child: Text("NO PRODUCT AVAILABLE"))
        :Container (
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          child:Column(
            children: [
              
                 Expanded(
                          child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: products.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.83), 
                                    itemBuilder: (BuildContext context,index) {
                                      return GestureDetector(
                                        onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (_) =>ProductDetail2(products[index]))),
                                        child: Card(
                                          color: Colors.blue[50],
                                          elevation: 10,
                                          child: Column(
                                              children: [
                                                  Container(
                                                        margin: EdgeInsets.all(10),
                                                        child: Image.network(products[index]["product_img"].toString(), height: 100, width: 100,),
                                                  ),
                                                  
                                                  // Container(
                                                  //               child:Text(products[index]["pid"],
                                                  //                     style: TextStyle(fontSize: 18, 
                                                  //  fontWeight: FontWeight.bold, 
                                                  //  color: Colors.blue),
                                                  //               )
                                      
                                                  //           ),

                                                            Container(
                                                                padding: EdgeInsets.only(bottom: 10),
                                                                alignment: Alignment.center,
                                                                child:Text(products[index]["product_name"],
                                                                      style: TextStyle(fontSize: 18, 
                                                   fontWeight: FontWeight.bold, 
                                                   color: Colors.blue),
                                                                )
                                      
                                                            ),
                                                            Container(
                                                              child:Text(products[index]["price"].toString()+" ₹",
                                                                  style: TextStyle(fontSize: 15, 
                                                   fontWeight: FontWeight.bold, 
                                                   color: Colors.black),
                                                                ),
                                                              )
                                              ]),
                                        ),
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