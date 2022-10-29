import 'dart:async';
import 'package:adslay/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'MainScreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;
  bool _requireConsent = true;
  var fltrNotification;
  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }
  @override
  void initState() {
    super.initState();
    _loadWidget();
  }
  Future<void> navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? MobileNo = prefs.getString('mobilenumber');
    prefs.setString('from', 'splash');

    try {
      if(MobileNo==null){
        Timer(Duration(seconds: 1),
                ()=>
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) => const LoginScreen()
                    )
                )
        );
      }else{
        Timer(const Duration(seconds: 1),
                ()=>
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) =>  BottomNavigationMenu()//HomeScreen()
                    )
                )
        );
      }
    } catch (error) {
      Timer(
          const Duration(seconds: 1),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height ,
                child: Image.asset("assets/images/splashBg.png",fit: BoxFit.fill,),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Center(child: Image.asset("assets/images/logo.jpg",fit: BoxFit.fill,height: MediaQuery.of(context).size.height * 0.18,width: MediaQuery.of(context).size.width * 0.80)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0,top: 35),
                    child: Image.asset("assets/images/splash_intro.png",fit: BoxFit.fitHeight,height: MediaQuery.of(context).size.height * 0.30,width: MediaQuery.of(context).size.width * 0.45),
                  ),
                ],
              ),
            ]
        )
    );
  }

}
