import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdfviewer/ui/home/home.ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Image.asset(
            'lib/assets/pdflogo.png',
            //fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )),
      nextScreen: const Home(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
