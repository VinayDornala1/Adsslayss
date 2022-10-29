import 'dart:convert';
import 'package:adslay/Constant/ConstantsColors.dart';
import 'package:adslay/SignUp.dart';
import 'package:adslay/otp_Screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'API.dart';
import 'bottom_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _dropDownValue = "+91";
  String countryname = "India";
  int maxLength = 10;
  String text = "";
  late List<dynamic> CountryList;
  final phoneNumber = TextEditingController();
  late ProgressDialog pr;

  // String onesignalPlayerID;
  @override
  void initState() {
    super.initState();
    // getData();
    Future.delayed(Duration.zero, () {
      // initOneSignal();
    });
  }

  Future<String> getData() async {
    return "Success";
  }

  void getDataFromAPI() async {
    await pr.show();
    String url1 = APIConstant.login;
    print(url1);
    Map<String, dynamic> body = {
      'MobileNo': '' + mobilenumber.text.toString(),
    };
    print('Most popular api calling :' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    Map data1 = jsonDecode(response.body);
    print('login api calling response :' + data1.toString());
    String msg = data1['msg'];
    await pr.hide();
    if (msg == 'No Records Found') {
      Fluttertoast.showToast(
          msg: "Records not found please register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          OTPScreen(mobileNumber: mobilenumber.text.toString())));
    }
  }

  final mobilenumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
        message: 'Loading',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
            padding: const EdgeInsets.all(10.0),
            child: const CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600)
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Image.asset(
                      "assets/images/login_bg.png", fit: BoxFit.fill,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.60,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.30,
                          child: Center(
                              child:
                              Image.asset(
                                "assets/images/logo.jpg",
                                fit: BoxFit.fill,
                              )
                          )
                      ),
                      SizedBox(
                        width: double.infinity,
                        //height: MediaQuery.of(context).size.height * 0.50,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 30.0, bottom: 0),
                                child: Center(
                                  child: Text(
                                    'HELLO',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 10),
                                child: Text(
                                  "Please Enter your Registered mobile number to login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.3),
                                      // border: Border.all(
                                      //   width: 1,
                                      // ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 5, 5, 5),
                                          child: Text('+1', style: TextStyle(
                                              fontFamily: "montserratbold",
                                              fontSize: 18,
                                              letterSpacing: 3.0)),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            maxLength: 10,
                                            keyboardType: TextInputType.phone,
                                            controller: mobilenumber,
                                            onChanged: (String newVal) {
                                              if (newVal.length <=
                                                  maxLength) {
                                                text = newVal;
                                              } else {
                                                mobilenumber
                                                    .text = text;
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              hintText: "Enter mobile number",
                                              border: InputBorder.none,
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  //IntrinsicHeight
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 25, 0, 10),
                                child: Center(
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (mobilenumber.text == '') {
                                        Fluttertoast.showToast(
                                            msg: "Enter Mobilenumber",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      } else if (text.length < 10) {
                                        Fluttertoast.showToast(
                                            msg: "Enter valid Mobile number",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      } else {
                                        getDataFromAPI();
                                      }
                                    },
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      width: 180,
                                      decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xff3962cb),
                                              Color(0xff3962cb),
                                            ],
                                          )
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: const Text(
                                        "GET OTP",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Lorin"
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "An OTP will be sent to this number",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Text(
                                    'Or',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                      fontFamily: "montserratmedium",
                                    ),
                                  ),
                                ),
                              ),
                              //for order as guest
                              GestureDetector(
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences
                                      .getInstance();
                                  prefs.setInt('userid', 0);
                                  prefs.setString('username', 'demo');
                                  prefs.setString('email', "guest@guest.com");
                                  prefs.setString('mobilenumber', "9999999999");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavigationMenu()));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 80, right: 80, top: 0),
                                  width: double.infinity,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text('Skip Login', style: TextStyle(
                                      fontSize: 16.0,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'montserratbold',
                                      color: ConstantColors.appTheme),),
                                ),
                              ),
                            ]
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.25,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Center(
                                child: Text(
                                  "New to Adslay?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 50),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (
                                              context) => const SignUpScreen()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 15.0,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: GradientText(
                                        ' SIGN UP ',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        colors: const [
                                          Colors.lightGreen,
                                          Colors.orangeAccent,
                                          Colors.yellowAccent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          )
      ),
    );
  }
}
