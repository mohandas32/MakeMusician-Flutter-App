import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({super.key});

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {

  final List feedbackData=[];

  fetchFeedbackData() async{
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("user_feedback").get();

    
      if(qn.docs.length > 0) {

      
         for(int i=0; i<qn.docs.length; i++){
          feedbackData.add(
            {
              "user_id":qn.docs[i]["user_id"],
              "feedback": qn.docs[i]["feedback"],
             
            });      
        }
      }

      setState(() {
        
      });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    fetchFeedbackData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FEEDBACK DATA"),
      ),
      body:Container (
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          child:Column(
            children: [
             
          SizedBox(height: 5,),
      
      
                Expanded(
                  child: GridView.builder(
                           scrollDirection: Axis.vertical,
                            itemCount: feedbackData.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 1,
                           childAspectRatio: 3.18), 
                          itemBuilder: (BuildContext context,index) {
                          return Card(
                             color: Colors.blue[50],
                                   elevation: 10,
                                     child: Column(
                                       children: [
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  alignment: Alignment.center,
                                                  child:Row(
                                                    children: [
                                                       Text("USER_ID: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(feedbackData[index]["user_id"].toString(),
                                                      style: TextStyle(fontSize: 12, 
                                                        fontWeight: FontWeight.bold, 
                                                        color: Colors.blue),
                                                                     ),
                                                    ],
                                                  )
                                       
                                                   ),

                                            Container(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  alignment: Alignment.center,
                                                  child:Row(
                                                    children: [
                                                       Text("FEEDBACK: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(feedbackData[index]["feedback"].toString(),
                                                      style: TextStyle(fontSize: 12, 
                                                        fontWeight: FontWeight.bold, 
                                                        color: Colors.blue),
                                                                     ),
                                                    ],
                                                  )
                                       
                                                   ),
                                  
                                  
                                               ]),
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