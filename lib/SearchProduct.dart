import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/Products/ProductDetail2.dart';

class SearchProduct extends StatefulWidget {
  String searchItem;

  SearchProduct(this.searchItem);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  List fetchProducts=[];
  List products =[];
  List productsDummy =[];

  fetchSearchProducts() async{

    
    
    
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("products").get();


  

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

     productsDummy=products.where((element) => ((element["product_name"].contains(widget.searchItem.toLowerCase())))).toList();
     products =productsDummy;
       
     setState(() {
      

      
     });

   // print(productsDummy);
     //productsDummy.where((element) => false)
     
    
   
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchSearchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH PRODUCT")
        
        ),
      body: productsDummy.length==0 ?
      Center(
        child: Text("NO RESULT FOUND FOR\n${widget.searchItem}...",
              style: TextStyle(fontSize: 20, color: Colors.grey),),)
      :SafeArea(
            child: Container(
              child: Column(
                    children: [
                      SizedBox(height: 5,),

                      Text("Search Result for ${widget.searchItem}",
                            style: TextStyle(fontSize: 18)),   

                      SizedBox(height: 5,),

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
                            
                    ]),
            ),
          
          
        )

    );
  }
}