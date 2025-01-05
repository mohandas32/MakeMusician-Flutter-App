import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/Admin/AdminDashboard.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  final formKey =GlobalKey<FormState>();  //key for form
  bool _validate=false;
  var isVisible=true;
  bool isLoading=false;

  TextEditingController adminemailController = TextEditingController();
  TextEditingController adminpassController = TextEditingController();

 LoginFailSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Incorrect Credentials",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login.jpg'),
          fit: BoxFit.cover
        )
      ),

      child:Scaffold(


        backgroundColor: Colors.transparent,
        body:Stack(
      
          children: [
            Container(
              padding:EdgeInsets.only(left:50, top:150),
              child: Text("ADMIN LOGIN ", style: TextStyle(
                color: Colors.white,
                fontSize:33,
                )
                ),
            ),


          Container(
            child:Form(
              key:formKey,
            child: SizedBox(
              child: SingleChildScrollView(
                child:Container(
                padding:EdgeInsets.only(left:35, top:320, right: 35),
                child: Column(
                  children: [

                    IconButton(
                          onPressed: () => Navigator.pushNamed(context,"login"), 
                          icon: Image.asset("images/login.png", width: 40)
                          ),
                        Text("User"),

                    TextFormField(
                      controller: adminemailController,
                      decoration: InputDecoration(
                        hintText: "Enter E-mail",
                        labelText:"E-Mail",
                        prefixIcon: Icon(Icons.email),
                        border:OutlineInputBorder(
                          borderRadius:BorderRadius.circular(10) )
                      ),
                      validator:(value){
                        if(value!.isEmpty){
                          return "Please Enter E-mail";
                        }
                        else if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[-\w]{2,4}').hasMatch(value))
                        {
                          return "Please Enter Valid E-mail";
                        }
                       
                      }
                      
                    ),
                    SizedBox(    // for margin between 2 textbox
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: isVisible,
                      controller: adminpassController,
                       decoration: InputDecoration(
                        hintText: "Enter Password",
                        labelText: "Password",
                        suffix:GestureDetector(
                          onTap: (){
                            setState(() {
                              isVisible = !isVisible;
                              
                            });
                          },
                        
                        child: Icon(Icons.remove_red_eye, color: isVisible ? Colors.grey : Colors.green,
                        )
                        ),
                        prefixIcon: Icon(Icons.password),
                        border:OutlineInputBorder(
                          borderRadius:BorderRadius.circular(10) )
                      ),
                      validator:(value) {
                        if(value!.isEmpty){
                          return "Please Enter Password";
                        }
                         else if(value.length<8)
                         {
                          return "Password must be more than 8 characters";
                         }

                         else if(!RegExp(r'((^[a-zA-Z]))').hasMatch(value))
                         {
                          return "Password must starts wuth alphabets";
                         }

                         else if(!RegExp(r'((?=.*[0-9])(?=.*[!@#$%^&*_]))').hasMatch(value))
                         {
                          return "Must contain one special character and one digit";
                         }
                      },
                    ),
                    //
                    SizedBox(    // for margin between 2 textbox
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                      children: [
                        
                      Text("Admin page",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    
                    Padding(
                      padding: EdgeInsets.only(left: 10)
                      ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xff4c505b),
                          child:IconButton(
                            color:Colors.white ,
                            onPressed: () {
                                
                               if(formKey.currentState!.validate() && (adminemailController.text.trim()=="mohan@makemusician.com" && adminpassController.text.trim()=="admin@123")){

                                setState(() {
                                  isLoading=true;
                                });

                                Future.delayed(Duration(seconds: 5),(){
                                      setState(() {
                                          isLoading=false;

                                      const snackBar = SnackBar(content: Text(" Welcome To Admin Page..."),);
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                      //redirecting to home page
                                    Navigator.pushAndRemoveUntil((context),
                                  MaterialPageRoute(builder: (context) => AdminDashboard()), (Route) =>false);

                                });
                                });
                                 }

                                 else{

                                  LoginFailSnackbar();
                                 }
                          
                            },
                            icon: isLoading? CircularProgressIndicator(color: Colors.white,)
                                   :Icon(Icons.arrow_forward),
                          )
                          
                        )
                      ],
                    ),

                    

                      ],
                      
                    )
                ),
              )
            )
            
              ),
          ),
          
          ],
        )
      )
  
    );
  }
}