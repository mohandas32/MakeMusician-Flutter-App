import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget{
var CategoriesList =["Percussion","String","Keyboard","WoodWind","Brass"];

  @override
  Widget build(BuildContext context){

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, 
      child: Row(
        children: [
         
          for(int i=1; i<=5; i++)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      IconButton(icon: Image.asset("images/icons/category$i.png", width: 40, height: 40), 
                      onPressed: () =>Navigator.pushNamed(context, CategoriesList[i-1]),
                      ),
                      Text(CategoriesList[i-1], 
                      style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue
                                      ),
                          ),
                  ],

            )
          )

      ]),
    );
  }
}