import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/Admin/AdminDashboard.dart';
import 'package:path/path.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';


class AddProduct extends StatefulWidget {
   AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {


  Random random =new Random();
  bool isLoading=false;
  
 final productCodeController = TextEditingController();
 final productNameController = TextEditingController();
 final productDescController = TextEditingController();
 final productPriceController = TextEditingController();
 final productQuantityController = TextEditingController();
 final productCategoryController = TextEditingController();

 String imgUrl ="";

 List<String> productCategory =["String","WoodWind","Percussion","Keyboard","Brass"];
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

    
    
addProductFirebase() async{

//generate random number for product id
   Map<String, dynamic> product_data={
    "product_id": productCodeController.text.trim(),
    "product_name": productNameController.text.trim().toLowerCase(),
    "product_desc": productDescController.text.trim() ,
    "product_img":imgUrl.trim(),
    "product_category":selectedItem,
    "price":productPriceController.text.trim(),
    "quantity": productQuantityController.text.trim()};

   DocumentReference documentReference = await FirebaseFirestore.instance.collection("products").doc("${productCodeController.text.trim()}");
   documentReference.set(product_data);

}

DropdownMenuItem<String> buildMenuItem(String productCategory) => DropdownMenuItem(
              value: productCategory,
              child: Text(productCategory, style: TextStyle(fontSize: 15,)
              ),
            );
  @override
   Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("ADD PRODUCT"),
        ),
        body:SingleChildScrollView(

        child:Container(
          padding:const EdgeInsets.only(left:35, top: 10,right: 35),
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
                controller: productCodeController,
                decoration: InputDecoration(
                  hintText: "Enter Product Code",
                  labelText: "Product Code",
                  hintStyle: const TextStyle(color: Colors.white),
                  // prefixIcon: const Icon(Icons.),
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(10) )
                ),
                validator: (value){
                  if(value!.isEmpty) {
                    return "Field must be filled";
                  } 
                  else if(!RegExp(r'[A-Za-z_]').hasMatch(value)) {
                    return "Only alphabets,underscore and digit allowed.";
                  }

                }
               
              ),
              const SizedBox(    // for margin between 2 textbox
                height: 10,
              ),
              TextFormField(
                controller: productNameController,
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
                 controller: productDescController,
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
                controller: productPriceController,
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
                
                controller: productQuantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
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
                    value: selectedItem,
                    items: productCategory.map(buildMenuItem).toList(),
                    onChanged:(val){
                      setState(() {
                        selectedItem = val as String;
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
                            setState(() {
                              isLoading=true;

                            });


                            Future.delayed(Duration(seconds: 5),(){

                              setState(() {
                                isLoading=false;
                              
                                  addProductFirebase();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => AdminDashboard()));
                                  Fluttertoast.showToast(msg: "Product Added Successfully");

                            });
                            });
                            
                         }
                        }, 
                        child: isLoading ?CircularProgressIndicator(color: Colors.white)
                        :Text("ADD TO DATABASE")),
                    )
                  
                  // const Text("REGISTER", style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold)),
                  // CircleAvatar(
                  
                  //   radius: 25,
                  //   backgroundColor: const Color(0xff4c505b),
                  //   child:IconButton(
                  //     color:Colors.white ,
                  //     onPressed: () async{
                  //        if(formKey.currentState!.validate())
                  //        {
                  //          Map<String,String> user_data ={"firstname": fnameController.text, "lastname": lnameController.text ,"email":emailController.text,"password":passController.text ,"mobile": mobileController.text};

                  //          print(user_data);

                  //          Navigator.pushNamed(context, "home_page");
                      
                  //        }
                  //     },
                  //     icon: const Icon(Icons.arrow_forward),
                  //   )
                  // )
                ],
              ),
             
            ],
          
          ),
          )
        )
        
        )
      
    );
  }
}