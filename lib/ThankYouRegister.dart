import 'dart:convert';
import 'package:adslay/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'API.dart';
import 'BoolProvider.dart';
import 'Constant/ConstantsColors.dart';


class ThankYouRegister extends StatefulWidget {




  @override
  State<ThankYouRegister> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouRegister> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BoolProvider _boolProvider = BoolProvider();

/*
"OrderId": 39,
    "TransactionId": "pi_3L4IxgEeBLujSW5l0GzKI6Ih",
    "OrderCreated": "28/05/2022",
    "PaidAmount": 37555.00,
    "StoreName": "",
    "PaymentStatus": "Completed"
 */

  bool isLoading = true;
  String email = '';
  String mobileNumber = '';
  String username = '';
  String transactionId = '';
  String orderCreated = '';
  String paidAmount = '';
  String storeName = '';
  String paymentStatus = '';

  List<dynamic> OrderDetailsList = [];

  Future<void> getData() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mobileNumber = prefs.getString('mobilenumber')!;
        email = prefs.getString('email')!;
        username = prefs.getString('username')!;
      });
    }catch(e){
      print(e);
    }

    setState(() {
      isLoading=false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: false,
        child: Container(
          child: Stack(

            children: <Widget>[
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigationMenu()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        "assets/images/back.png",
                        width: 45,
                        height: 65,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 0, right: 30,left: 10),
                      child: Image.asset("assets/images/home-logo.png",width: 130,)
                  ),
                  const Spacer(),

                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Image.asset(
                          'assets/images/success.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'THANK YOU \n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Mont-Light",
                              fontSize: 19,
                              color: Colors.black
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: Text(
                            'You have successfully registered as a vendor.\n\n Our team will contact you shotly.\n \n',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                              ConstantColors.appTheme,
                              fontFamily: "Mont-Regular",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin:
                          EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                          child: MaterialButton(
                            onPressed: () {
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigationMenu()));

                              Provider.of<BoolProvider>(context, listen: false).setNoBookmarks(
                                  false);
                              _scaffoldKey.currentState?.openEndDrawer();
                              _boolProvider.setBottomChange(0);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>BottomNavigationMenu()));

                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              width: 250,
                              height: 45,
                              decoration:  const BoxDecoration(
                                  gradient:  LinearGradient(
                                    colors: [
                                      Color(0xff3962cb),
                                      Color(0xff3962cb),
                                    ],
                                  )
                              ),
                              //padding: const EdgeInsets.all(10.0),
                              child: const Center(
                                child: Text(
                                  "BACK TO HOME",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Lorin"
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
