import 'dart:convert';
import 'package:adslay/otp_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'API.dart';
import 'package:email_validator/email_validator.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  int maxLength = 10;
  String text = "";
  late ProgressDialog pr;
  final emailValid=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
                                    'WELCOME',
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
                                  "Please sign up to get started",
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
                                        left: 25, right: 25),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.3),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 10, 0),
                                            child: TextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp("[a-zA-Z]")),
                                              ],
                                              keyboardType: TextInputType
                                                  .streetAddress,
                                              controller: fullNameController,
                                              decoration: const InputDecoration(
                                                hintText: "Full Name",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 1,
                                            child:
                                            Image.asset(
                                              "assets/images/profile2.png",
                                              height: 22,
                                              width: 22,)
                                        )
                                      ],
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 25, right: 25),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.3),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 10, 0),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 5, 5, 5),
                                                  child: Text('+1',
                                                      style: TextStyle(
                                                          fontFamily: "montserratbold",
                                                          fontSize: 18,
                                                          letterSpacing: 3.0)),
                                                ),
                                                Expanded(
                                                  child: TextField(
                                                    maxLength: 10,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                          RegExp("[0-9]")),
                                                      LengthLimitingTextInputFormatter(
                                                          10),
                                                      // Pattern pattern=r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                    ],
                                                    keyboardType: TextInputType
                                                        .phone,
                                                    controller: mobileNumberController,
                                                    onChanged: (String newVal) {
                                                      if (newVal.length <=
                                                          maxLength) {
                                                        text = newVal;
                                                      } else {
                                                        mobileNumberController
                                                            .text = text;
                                                      }
                                                    },
                                                    decoration: const InputDecoration(
                                                      hintText: "Mobile Number",
                                                      counterText: "",
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 1,
                                            child:
                                            Image.asset(
                                              "assets/images/mobile-number.png",
                                              height: 22,
                                              width: 22,)
                                        )
                                      ],
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 25, right: 25),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.3),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 10, 0),
                                            child: TextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                    RegExp("[a-zA-Z0-@&.]")),
                                              ],
                                              keyboardType: TextInputType
                                                  .emailAddress,
                                              controller: emailController,
                                              decoration: const InputDecoration(
                                                hintText: "Email Address",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 1,
                                            child:
                                            Image.asset(
                                              "assets/images/email.png",
                                              height: 22,
                                              width: 22,)
                                        )
                                      ],
                                    )
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(80.0, 25.0, 80.0, 0),
                                child:
                                MaterialButton(
                                  onPressed: () {
                                    if (fullNameController.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Please enter full name",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    } else if (mobileNumberController.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Please enter mobile number",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    } else if (text.length < 10) {
                                      Fluttertoast.showToast(
                                          msg: "Please enter valid mobile number",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    } else if (emailController.text == '') {
                                      Fluttertoast.showToast(
                                          msg: "Please enter email-id",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    } else if (!emailValid.hasMatch(emailController.text.toString())) {
                                      Fluttertoast.showToast(
                                        msg: "Please enter valid email-id",
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
                                      "SUBMIT",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Lorin"
                                      ),
                                    ),
                                  ),
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
                                  "Already have an account?",
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
                                      Navigator.pop(context);
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
                                        '  LOGIN  ',
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

  void getDataFromAPI() async {
    await pr.show();
    String url1 = APIConstant.signup;
    print(url1);
    Map<String, dynamic> body = {
      'FirstName': '' + fullNameController.text.toString(),
      'LastName': '',
      'MobileNo': '' + mobileNumberController.text.toString(),
      'Email': '' + emailController.text.toString(),
    };
    print('Signup api calling :' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    Map data1 = jsonDecode(response.body);
    print('signup api calling response :' + data1.toString());
    String msg = data1['msg'];
    await pr.hide();
    if (msg == 'Success') {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          OTPScreen(mobileNumber: mobileNumberController.text.toString())));
    } else {
      Fluttertoast.showToast(
          msg: "Number Already Existed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


}
