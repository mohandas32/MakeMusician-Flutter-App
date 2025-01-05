import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/Userauthentication/login.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // playSound(){

      
    //   final player = AudioCache();
     
    //   player.play('images/splashsecrren.mp3');
    // }
    return AnimatedSplashScreen(
        splash:Column(
          children: [
               InkWell(
                 child: Image.asset("images/splash_screen.gif",
                             ),
                onTap: ()=> {
                }
               ),

             
             SizedBox(height: 60),

              Text("MAKE MUSICIAN APP", style:TextStyle(fontSize: 20))
            ]
            ),
        splashIconSize: 450,
        duration: 4500,
        nextScreen: Login(),
        
      );
  
  }
}