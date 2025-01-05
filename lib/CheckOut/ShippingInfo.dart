import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/CheckOut/FillAddress.dart';
import 'package:make_musician/CheckOut/CreditCardOption.dart';
import 'package:make_musician/CheckOut/PaymentOption.dart';

class ShippingInfo extends StatefulWidget {

  double totalamount=0.0;
  ShippingInfo(this.totalamount);

  @override
  State<ShippingInfo> createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  TextEditingController houseNoController = new TextEditingController();
  TextEditingController buildingNameController = new TextEditingController();
  TextEditingController areaNameController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

//Constructor of Class
  _Dispatch_screenState() {
    Selected_city = _city[0];
  }

  int? _val = 0;
//List Of Cities
  final _city = [
    'Ahmedabad',
    'Baroda',
    'Surat',
    'Bharuch',
    'Gandhinagar',
    'Mehasana',
    'Bhavnagar',
    'Kalol',
    'Kadi',
    'Himmatnagar'
  ];

  String? Selected_city = "Ahmedabad"; //First Dropdown CityName
  List fetchAddressFirebase=[];

  

  fetchAddress() async{
    final user = FirebaseAuth.instance;
    var firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await firestoreinstance.collection("user_address").where("uid",isEqualTo: user.currentUser!.uid).get();

    if(qn.docs.isNotEmpty) {


      for(int i=0; i<qn.docs.length; i++){
        fetchAddressFirebase.add(
            {
              "house_no": qn.docs[i]["house_no"],
              "apartment_name":qn.docs[i]["apartment_name"],
              "area_name":qn.docs[i]["area_name"],
              "city":qn.docs[i]["city"],
              "pincode":qn.docs[i]["pincode"]
             
            });
      }

    }

    setState(() {
      
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAddress();
  }

    

  @override
  Widget build(BuildContext context) {
    return fetchAddressFirebase.length==0 
    ?Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shipping Detail"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text("No Address Available"),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, "fillAddress");
                }, 
                child: Text("ADD ADDRESS")
                )
            ],
          )),
      ),
    )
    :Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shipping Detail"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(

      padding: EdgeInsets.only(left:10,top:130),
        child: Column(
          children: [
            
            Row(
              
              children: [
                Radio(
                  value: 1, 
                  groupValue: _val, 
                  onChanged: (value) {
                        setState(() {
                          _val=value;
                        });
                      }
                      ),
                      for(int i=0; i<fetchAddressFirebase.length; i++)
                    Text(fetchAddressFirebase[i]["house_no"]+", "+fetchAddressFirebase[i]["apartment_name"]+"\n"+
                      fetchAddressFirebase[i]["area_name"]+",\n"+
                      fetchAddressFirebase[i]["city"]+"-"+fetchAddressFirebase[i]["pincode"],
                      style: TextStyle(fontSize: 16),
                      )

                      
                      
              ],
              ),

              ElevatedButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FillAddress(0.0)));
                },

                child: Text("ADD ADDRESS")
                ),

              ElevatedButton(
                onPressed: (){

                  if(_val == 0){
                    Fluttertoast.showToast(msg: "Please Select The Address");
                  }
                  else
                  {
                  
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentOption("${fetchAddressFirebase[0]["house_no"]+", "+fetchAddressFirebase[0]["apartment_name"]+"\n"+
                      fetchAddressFirebase[0]["area_name"]+","+
                      fetchAddressFirebase[0]["city"]+"-"+fetchAddressFirebase[0]["pincode"]}",widget.totalamount)));
                  }
                },
                

                child: Text("PROCEED TO PAY"))
          ],
        ),

          
      ),
      // body: Container(
      //   alignment: Alignment.topCenter,
      //   margin: EdgeInsets.only(left: 25, right: 25),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         SizedBox(
      //           height: 20,
      //         ),
      //         Image.asset(
      //           //Route Of Image
      //           "images/shipping_pic.jpeg",
      //           height: 180,
      //           width: 300,
      //         ),
      //         SizedBox(
      //           height: 40,
      //         ),
      //         SizedBox(
      //           height: 20,
      //         ),
      //         SizedBox(height: 10),
      //         Form(
      //           key: _formKey,
      //           child: Column(
      //             children: [
                    
      //               TextFormField(
      //                 controller: houseNoController,
      //                 keyboardType: TextInputType.number,
      //                 decoration: InputDecoration(
      //                   hintText: "House No",
      //                   labelText:
      //                       "House No/Flat No",
      //                   hintStyle: TextStyle(color: Colors.white),
      //                   prefixIcon: Icon(Icons.house),
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //                 validator: (value) {
      //                   if (value!.isEmpty) return "Field must be filled";
      //                   else if(!RegExp(r'\d').hasMatch(value))
      //                    return "Only alphabets allowed";
      //                 },
      //               ),
      //               SizedBox(height: 10),
      //               TextFormField(
      //                 keyboardType: TextInputType.name,
      //                 controller: buildingNameController,
      //                 decoration: InputDecoration(
      //                   hintText: "Apartment Name/Building Name",
      //                   labelText:
      //                       "Apartment Name",
      //                   hintStyle: TextStyle(color: Colors.white),
      //                   prefixIcon: Icon(Icons.house),
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //                 validator: (value) {
      //                   if (value!.isEmpty) return "Field must be filled";
      //                   else if(!RegExp(r'[A-Za-z]').hasMatch(value))
      //                    return "Only alphabets allowed";
      //                 },
      //               ),
      //               SizedBox(height: 10),
      //               TextFormField(
      //                 keyboardType: TextInputType.name,
      //                 controller: areaNameController,
      //                 decoration: InputDecoration(
      //                   hintText: "Area Name,Street",
      //                   labelText:
      //                       "Area Name/Street",
      //                   hintStyle: TextStyle(color: Colors.white),
      //                   prefixIcon: Icon(Icons.location_city),
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //                 validator: (value) {
      //                   if (value!.isEmpty) 
      //                     return "Field must be filled";
      //                   else if(!RegExp(r'[A-Za-z]').hasMatch(value))
      //                    return "Only alphabets allowed";
      //                 },
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               // DropDown Menu
      //               TextFormField(
      //                 controller: pincodeController,
      //                 keyboardType: TextInputType.number,
      //                 inputFormatters: [
      //                   LengthLimitingTextInputFormatter(6),
      //                 ],
      //                 decoration: InputDecoration(
      //                   hintText: "Pincode",
      //                   labelText: "Pincode",
      //                   hintStyle: TextStyle(color: Colors.white),
      //                   prefixIcon: Icon(Icons.pin),
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //                 validator: (value) {
      //                   if (value!.isEmpty) return "Field must be filled";

      //                   return value.length < 6
      //                       ? 'Minimum character length is 6'
      //                       : null;
      //                 },
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),

      //               DropdownButtonFormField(
      //                 value: Selected_city,
      //                 items: _city.map((e) {
      //                   return DropdownMenuItem(
      //                     child: Text(e),
      //                     value: e,
      //                   );
      //                 }).toList(),
      //                 onChanged: (value) {
      //                   setState(() {
      //                     Selected_city = value;
      //                   });
      //                 },
      //                 icon: const Icon(
      //                   Icons.arrow_drop_down,
      //                   color: Colors.blue,
      //                 ),
      //                 decoration: InputDecoration(labelText: "City Name"),
      //               ),
      //               SizedBox(
      //                 height: 30,
      //               ),
      //               SizedBox(
      //                 width: double.infinity,
      //                 child: ElevatedButton(
      //                   onPressed: () {
      //                     UsethisAdress();
      //                     //addAddress();
      //                     Fluttertoast.showToast(msg: "$fetchAddressFirebase");
      //                   },
      //                   child: Text("PROCEED TO PAY"),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  void UsethisAdress() {
    if (_formKey.currentState!.validate()) {

      String Address="${houseNoController.text.trim()},${buildingNameController.text.trim()},\n${areaNameController.text.trim()},${Selected_city}-${pincodeController.text.trim()}";

      //pass the data of form to the order page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentOption(Address,widget.totalamount)));

      
    }
  }

//add address into fireabse
  void addAddress() async
  {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    Map <String, dynamic> addressData =
                      {
                        "uid":user!.uid,
                        "house_no":houseNoController.text,
                        "apartment_name":buildingNameController.text,
                        "area_name":areaNameController.text,
                        "city":Selected_city,
                        "pincode":pincodeController.text
                      };

          try{

   DocumentReference documentReference = await FirebaseFirestore.instance.collection("user_address").doc(user.uid);
   documentReference.set(addressData);
   }
   catch(e){
    print(e);
   }
  }
}
