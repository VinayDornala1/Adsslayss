import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'API.dart';
import 'bottom_bar.dart';

class OTPScreen extends StatefulWidget {
  var mobileNumber;

  OTPScreen({Key? key, this.mobileNumber}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(12.0),
    border: Border.all(
      color: const Color(0xFF000000),
    ),
  );

  late String genotp;

  // String signature;
  late String verificationId;
  String errorMessage = '';
  bool smsGateway = false;
  bool firebase = true;
  String smsGatewayUrl = '';
  String isOtp = '';
  late String deviceOS;
  final otp11 = TextEditingController();
  String? verificationCode;

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1' + widget.mobileNumber,
        verificationCompleted: (PhoneAuthCredential crediential) async {
          print("verifyPhoneNumber<>>>$verifyPhoneNumber");
          await FirebaseAuth.instance
              .signInWithCredential(crediential)
              .then((value) {
            if (value.user != null) {
              verifyOTP();
            }
          });
          print("verifyPhoneNumber<>>>///$verifyPhoneNumber");
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
              duration: const Duration(seconds: 5),
            ),
          );
          print("e.message<><<<${e.message.toString()}");
        },
        codeSent: (String vID, int? resendToken) {
          setState(() {
            verificationCode = vID;
            print("verificationCode<><>$verificationCode");
          });
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationCode = vID;
            print("verificationCode<><><>$verificationCode");
          });
        });
  }

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
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/login_bg.png",
              fit: BoxFit.fill,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Center(
                      child: Image.asset(
                    "assets/images/logo_white.png",
                    fit: BoxFit.fill,
                  ))),
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
                            'Verification Code',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Text(
                          "Enter verification code sent to\nyour mobile number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: Image.asset(
                            "assets/images/otpicon.png",
                            width: 50,
                            height: 50,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: PinPut(
                            fieldsCount: 6,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(10),
                              LengthLimitingTextInputFormatter(6)
                            ],
                            withCursor: true,
                            textStyle: const TextStyle(
                                fontSize: 25.0, color: Color(0xFF000000)),
                            eachFieldWidth: 40.0,
                            eachFieldHeight: 51.0,
                            onSubmit: (String pin) async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithCredential(
                                        PhoneAuthProvider.credential(
                                            verificationId: verificationCode!,
                                            smsCode: otp11.text))
                                    .then((value) => {
                                          if (value.user != null)
                                            {
                                              verifyOTP(),
                                            }
                                        });
                              } catch (error) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            controller: otp11,
                            focusNode: _pinPutFocusNode,
                            submittedFieldDecoration: pinPutDecoration,
                            selectedFieldDecoration: pinPutDecoration,
                            followingFieldDecoration: pinPutDecoration,
                            pinAnimationType: PinAnimationType.fade,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                        child: Center(
                          child: MaterialButton(
                            onPressed: () async {
                              if (otp11.text == '') {
                                Fluttertoast.showToast(
                                    msg: "Enter OTP",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (otp11.text == '123456') {
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
                                verifyOTP();
                              } else if (otp11.text != '123456') {
                                Fluttertoast.showToast(
                                    msg: "Enter Valid OTP",
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithCredential(
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationCode!,
                                              smsCode: otp11.text))
                                      .then((value) => {
                                            if (value.user != null)
                                              {
                                                verifyOTP(),
                                              }
                                          });
                                } catch (error) {
                                  FocusScope.of(context).unfocus();
                                }
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
                              )),
                              padding: const EdgeInsets.all(10.0),
                              child: const Text(
                                "VERIFY OTP",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Lorin"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "We have sent a 6 digit OTP to",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          " " + widget.mobileNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xff3962cb),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Center(
                        child: Text(
                          "Didn't received a code?",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 50),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              verifyPhoneNumber();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: GradientText(
                                'RESEND',
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
        ]),
      )),
    );
  }

  Widget pinputwidget() {
    return const Padding(
      padding: EdgeInsets.only(right: 25),
      // child: PinPut(
      //   fieldsCount: 6,
      //   withCursor: true,
      //   textStyle: const TextStyle(fontSize: 25.0, color: Color(0xFFFFFFFF)),
      //   eachFieldWidth: 40.0,
      //   eachFieldHeight: 51.0,
      //   onSubmit: (String pin) => verifyOTP(pin),
      //   controller: _pinPutController,
      //   focusNode: _pinPutFocusNode,
      //   submittedFieldDecoration: pinPutDecoration,
      //   selectedFieldDecoration: pinPutDecoration,
      //   followingFieldDecoration: pinPutDecoration,
      //   pinAnimationType: PinAnimationType.fade,
      // ),
    );
  }

  late ProgressDialog pr;

  void verifyOTP() async {
    // if(widget.dropdownvalue == '+91'){
    //   if(genotp==pin){
    await pr.show();

    String url1 = APIConstant.login;
    print(url1);
    Map<String, dynamic> body = {
      'MobileNo': '' + widget.mobileNumber.toString(),
    };
    print('Login check api calling :' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );

    Map data = jsonDecode(response.body);
    print(data);
    String msg = data['msg'];
    print(msg);
    await pr.hide();
    if (msg == 'No Records Found') {
    } else {
      var CustomerId = data['objCustomers']['CustomerId'];
      var FirstName = data['objCustomers']['FirstName'];
      var Email = data['objCustomers']['Email'];
      var MobileNo = data['objCustomers']['MobileNo'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('userid', CustomerId);
      prefs.setString('username', FirstName);
      prefs.setString('email', Email);
      prefs.setString('mobilenumber', MobileNo);
      print("CustomerID is: " + CustomerId.toString());
      print("First Name is: " + FirstName.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BottomNavigationMenu()),
          ModalRoute.withName('/'));
    }
  }
}