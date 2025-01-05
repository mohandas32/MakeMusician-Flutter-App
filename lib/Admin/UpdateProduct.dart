import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:make_musician/Admin/AdminDashboard.dart';

class UpdateProduct extends StatefulWidget {
  String pid="";
  UpdateProduct(this.pid);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {

 
  String productName="";
  String productDesc="";
  String productPrice="";
  String productQuantity="";
  String? productCategory;


  TextEditingController productCodeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();

 String imgUrl ="";

 List<String> productCategoryList =["String","WoodWind","Percussion","Keyboard","Brass"];
 String? selectedItem;

 final formKey =GlobalKey<FormState>();  //key for form
//  bool isValid=false;
//  bool isPassVisible=true, isConPassVisible=true;




   PickImage() async{
                      
        ImagePicker imagePicker = ImagePicker();
        XFile? file= await imagePicker.pickImage(source: ImageSource.gallery);
                      
        String uniqueName =  DateTime.now().millisecondsSinceEpoch.toString();

        Reference refernceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = refernceRoot.child('product_images');
        Reference referenceImageToUpload = referenceDirImage.child(uniqueName);

        try{
          await referenceImageToUpload.putFile(File(file!.path));
         imgUrl= await referenceImageToUpload.getDownloadURL();

            }
        catch(error){

                    }
                   
}

  fetchProductDetails() async{

    var var1 = await FirebaseFirestore.instance
        .collection("products") //collection name
        .doc(widget.pid) //id
        .get();

        productName= var1.data()?["product_name"];
        productDesc= var1.data()?["product_desc"];
        productPrice= var1.data()?["price"];
        productCategory= var1.data()?["product_category"];
        productQuantity= var1.data()?["quantity"];

    setState(() {
       
          
        });
        
}
DropdownMenuItem<String> buildMenuItem(String productCategory) => DropdownMenuItem(
              value: productCategory,
              // ignore: prefer_const_constructors
              child: Text(productCategory, style: TextStyle(fontSize: 15,)
              ),
            );

  @override
  void initState() {
    fetchProductDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
        body:Stack(
          children: [

            Container(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.only(top:80,left:110,),
              child: Text("UPDATE DETAIL",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            

       
          SizedBox(
            child: SingleChildScrollView(

            child:Container(
              padding:const EdgeInsets.only(left:35, top:150, right: 35),
              child:Form(
                  key: formKey, //key for form
              child: Column(
                children: [
                  SizedBox(
                    child: IconButton(
                      icon: Icon(Icons.image), 
                      onPressed: () => PickImage(),)
                  ),
                   TextFormField(
                    controller: productCodeController = TextEditingController(text: "${widget.pid}"),
                    decoration: InputDecoration(
                      hintText: "Enter Product Code",
                      labelText: "Product Code",
                      hintStyle: const TextStyle(color: Colors.white),
                      // prefixIcon: const Icon(Icons.),
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10) )
                    ),
                   
                  ),
                  const SizedBox(    // for margin between 2 textbox
                    height: 10,
                  ),
                  TextFormField(
                    controller: productNameController =TextEditingController(text: productName),
                    decoration: InputDecoration(
                      hintText: "Enter Product Name",
                      labelText: "Product Name",
                      hintStyle: const TextStyle(color: Colors.white),
                      // prefixIcon: const Icon(Icons.),
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10) )
                    ),
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Field must be filled";
                      } 
                      else {
                        if(!RegExp(r'[A-Za-z]').hasMatch(value)) {
                        return "Only alphabets allowed.";
                      }
                      }

                      
                    }
                  ),
                  const SizedBox(    // for margin between 2 textbox
                    height: 10,
                  ),
                  TextFormField(
                     controller: productDescController= TextEditingController(text: productDesc),
                     decoration: InputDecoration(
                      hintText: "Enter Product Description",
                      labelText: "Product Description",
                      hintStyle: const TextStyle(color: Colors.white),
                     // prefixIcon: const Icon(Icons.person),
                      border:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10) )
                    ),
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Field must be filled";
                      } 
                      else if(!RegExp(r'[A-Za-z]').hasMatch(value)) {
                        return "Only alphabets allowed.";
                      }
                    }
                  ),

                 

                  const SizedBox(    // for margin between 2 textbox
                    height: 10,
                  ),

                

                  const SizedBox(    // for margin between 2 textbox
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: productPriceController= TextEditingController(text: productPrice),
                      // for password field character is in hidden form
                    decoration: InputDecoration(
                      hintText: "Enter Product Price",
                      labelText: "Product Price",
                      hintStyle: const TextStyle(color: Colors.white),
                      //prefixIcon: const Icon(Icons.password),
                     
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))
                    ),
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Field must be filled";
                      } 
                     
                    }
                  ),

                  const SizedBox(    // for margin between 2 textbox
                    height: 10,
                  ),
                  TextFormField(
                    
                    controller: productQuantityController= TextEditingController(text: productQuantity),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter Product Quantity", 
                      labelText: "Product Quantity",
                      hintStyle: const TextStyle(color: Colors.white),
                     // prefixIcon: const Icon(Icons.mobile_friendly),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Field must be filled";
                      }
                      else if(!RegExp(r'\d').hasMatch(value)){
                        return "Enter Valid Number";
                      }
                    }
                  ),

                   Row(
                    children: [
                      Text("Select Category", style: TextStyle(fontSize: 20),),
                      Spacer(),
                      DropdownButton<String>(
                        value: productCategory,
                        items: productCategoryList.map(buildMenuItem).toList(),
                        onChanged:(val){
                          setState(() {
                            productCategory = val as String;
                          });
                        } 

                        ),
                    ],
                  ),

                  
                  const SizedBox(    // for margin between 2 textbox
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                    children: [
                     
                    //  Padding(
                    //   padding: EdgeInsets.only(left: 10)
                    //   ),

                        Center(
                          child: ElevatedButton(
                            onPressed: (){

                              if(formKey.currentState!.validate())
                              {
                                CircularProgressIndicator();
                               //updateProductFirebase();
                               printDetails();
                              //  Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(builder: (context) => AdminDashboard()));
                              // Fluttertoast.showToast(msg: "Product Added Successfully");
                             }
                            }, 
                            child: Text("UPDATE DETAILS")),
                        )
                      
                     
                    ],
                  ),
                 
                ],
              
              ),
              )
            )
            
            ),
          )
          ],
        )
      
    );
  }

  printDetails(){
    Fluttertoast.showToast(msg: "{$productNameController.text}\n{$productDescController.text}\n {$productPriceController.text}\n{$productQuantityController.text}\n{$productCategoryController.text}");
  }
}