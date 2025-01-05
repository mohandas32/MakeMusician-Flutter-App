import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:make_musician/test_firebase.dart';

class feedback extends StatefulWidget {
  const feedback({super.key});

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  final feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Feedback")),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset(
              //Route Of Image
              "images/feedback.png",
              height: 150,
              width: 250,
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Your Feedback & Review",
                    ),
                    maxLines: 5,
                    minLines: 5,

                    
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      child: Text("SUBMIT"),
                      onPressed: () {
                        submitFeedback();
                      },
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

//Feedback snackbar method
  FeedbackSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Feedback Submitted Succesfully",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  FeedbackFailSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Please Write Something",
          style: TextStyle(fontSize: 18.0),
        ),

      
      ),
    );
  }

//submit feedback
  submitFeedback() async{

    final user = FirebaseAuth.instance.currentUser;
    var firestoreinstance = FirebaseFirestore.instance;

     if (feedbackController.text.length == 0) {
        FeedbackFailSnackbar();
    } else {

       Map<String,dynamic> feedbackData={
            "user_id": user!.uid,
            "feedback": feedbackController.text.trim()
                           };

    DocumentReference documentReference = FirebaseFirestore.instance.collection("user_feedback").doc(user.uid);
    documentReference.set(feedbackData);
    //display message
    FeedbackSuccessSnackbar();

    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Test_Firebase()));
    }

   
  }
}
