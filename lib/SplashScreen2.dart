import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:make_musician/test_firebase.dart';

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash:Column(
          children: [
               Image.asset(
                //Route Of Image
                "images/splash_screen.gif",
               // height: 650,
               // width: 350,
              ),
             
          SizedBox(height: 60),
              Text("MAKE MUSICIAN APP", style: TextStyle(fontSize: 20),)
            ]
            ),
        splashIconSize: 450,
        duration: 4500,
        nextScreen: Test_Firebase(),
        
      );
  }
}