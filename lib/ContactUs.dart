import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'CartScreen.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'SearchScreen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _HowItWorksState();
}

class _HowItWorksState extends State<ContactUs> {
  final fullNameController = TextEditingController();
  final storenameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();
  final addressController = TextEditingController();
  var formatter=MaskTextInputFormatter(
      mask:'(###) ###-####',filter: {"#":RegExp(r'[0-9]')},type: MaskAutoCompletionType.lazy
      );
  final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  int maxLength = 14;
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        left: false,
        top: true,
        right: false,
        bottom: false,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                      padding: const EdgeInsets.only(
                          top: 0, right: 30, left: 10),
                      child: Image.asset(
                        "assets/images/home-logo.png", width: 130,)
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            21.5), // if you need this
                      ),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: 43,
                            height: 43,

                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 10, 5, 0),
                            child: Image.asset(
                              "assets/images/cart.png",
                              width: 28,
                              height: 28,
                            ),
                          ),
                          MainScreen.cartItemsCount > 0 ? Positioned(
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: ConstantColors.appTheme,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                //color: Colors.red,
                                child: Center(
                                  child: Text(
                                    "" + MainScreen.cartItemsCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: "Mont-Regular"
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ) : const SizedBox(height: 1, width: 1,)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            21.5), // if you need this
                      ),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: 43,
                            height: 43,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10, 10, 5, 0),
                            child: Image.asset(
                              "assets/images/search.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Contact Us",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Mont-SemiBold"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                child: SizedBox(width: 100,
                  child: Divider(
                    height: 1, thickness: 1, color: ConstantColors.appTheme,),),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  "[a-zA-Z]"))
                            ],
                            controller: fullNameController,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'Enter Your Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: TextField(
                            controller: emailController,

                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'Enter Your Email',

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: TextField(
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
                            autocorrect: false,
                            inputFormatters: [formatter
                              // formatter=n
                              // MaskedInputFormatter('(###) ###-####',filter),
                              // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),LengthLimitingTextInputFormatter(10)
                            ],

                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 13.0, left: 5),
                                child: Text("+1 "),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'Enter Your Mobile Number',

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: TextField(
                            minLines: 5,
                            maxLines: null,
                            controller: addressController,
                            decoration: const InputDecoration(

                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'Enter Your Comments',

                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: MaterialButton(
                              onPressed: () async {
                                if (fullNameController.text == '') {
                                  Fluttertoast.showToast(
                                      msg: "enter name",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                } else if (emailController.text == '') {
                                  Fluttertoast.showToast(
                                      msg: "enter email",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                } else if (!emailValid.hasMatch(emailController.text.toString())) {
                                  Fluttertoast.showToast(
                                      msg: "enter valid email",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                } else if (mobileNumberController.text == '') {
                                  Fluttertoast.showToast(
                                      msg: "enter mobile number",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                } else if (text.length < 14) {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid Mobile number",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }else if (addressController.text == '') {
                                  Fluttertoast.showToast(
                                      msg: "enter comments",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                } else {
                                  getUploadedFiles();
                                }
                              },
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.60,
                                height: 45,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff3962cb),
                                        Color(0xff3962cb),
                                      ],
                                    )
                                ),
                                //padding: const EdgeInsets.all(10.0),
                                child: const Center(
                                  child: Text(
                                    "Register",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Lorin"
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    )
                ),
              )

            ]),
      ),
    );
  }

  Future<void> getUploadedFiles() async {
    String ul = 'http://app.adslay.com/API/HomeAPI/AddNewLead?Name=' +
        fullNameController.text.toString() + '&PhoneNo=' +
        mobileNumberController.text.toString() + '&Email=' +
        emailController.text.toString() + '&Address=' +
        addressController.text.toString();
    print("Get order image list :" + ul);
    final response22 = await get(
      Uri.parse(ul),
    );
    print('' + response22.body);
    Map data1 = jsonDecode(response22.body);
    String msg = data1['msg'].toString();
    if (msg == 'success' || msg == 'success') {
      Fluttertoast.showToast(
          msg: "Submitted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      fullNameController.text = "";
      mobileNumberController.text = "";
      emailController.text = "";
      addressController.text = "";
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong",
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
