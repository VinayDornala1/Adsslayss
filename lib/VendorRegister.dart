import 'dart:convert';

import 'package:adslay/otp_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'API.dart';
import 'Constant/ConstantsColors.dart';
import 'VendorUpload.dart';


class VendorRegister extends StatefulWidget {

  @override
  State<VendorRegister> createState() => _VendorRegisterState();
}

class _VendorRegisterState extends State<VendorRegister> {

  final fullNameController = TextEditingController();
  final storenameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();
  final addressController = TextEditingController();
  final emailValid=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool isLoading = true;
  bool isCheckoutAvailable = false;
  List<dynamic> ordersHistoryList = [];
  List<dynamic> userDetails = [];
  String email = '';
  String mobileNumber = '';
  String username = '';
  int userid = 0;
  double subTotalValue = 0.0;
  int maxLength = 14;
  String text = "";
  late ProgressDialog pr;
  Map<String, dynamic>? paymentIntentData;
  TextEditingController countryControllerId = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController categoryid = TextEditingController();
  TextEditingController categoryName = TextEditingController();
  List<dynamic> CountriesList = [];
  List<dynamic> statelists = [];
  List<dynamic> CategoriesList = [];
  String transactionId = '';



  Future<void> getData() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mobileNumber = prefs.getString('mobilenumber')!;
        email = prefs.getString('email')!;
        username = prefs.getString('username')!;
        userid = prefs.getInt('userid')!;
      });
    }catch(e){
      print(e);
    }

    String url1 ="http://app.adslay.com/API/HomeAPI/CategoriesList" ;
    print(url1);
    var response11 =
    await get(Uri.parse(url1), headers: {"Accept": "application/json"});
    setState(() {
      print(''+response11.body.toString());
      CategoriesList = jsonDecode(response11.body)['CategoriesList'];

    });
    String url ="http://app.adslay.com/API/HomeAPI/CountriesList" ;
    print(url);
    var response1 =
    await get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      print(''+response1.body.toString());
      CountriesList = jsonDecode(response1.body)['CountriesList'];
      isLoading=false;
    });
  }

  Future<void> loadstates() async {
    String url1 = 'http://app.adslay.com/API/HomeAPI/StatesList';
    print(url1);
    Map<String, dynamic> body = {
      'CountryId': ''+countryControllerId.text.toString(),
    };
    print("Profile get details api calling :" + body.toString());
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
    setState(() {
      print(''+data.toString());
      statelists =data['StatesList'];
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
    pr = ProgressDialog(context);
    pr.style(
        message: 'Loading',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
            padding: const EdgeInsets.all(10.0), child: const CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600)
    );
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        left: false,
        top: true,
        right: false,
        bottom: false,
        child: Scaffold(
            body: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: <Widget>[
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
                              padding: const EdgeInsets.only(top: 0, right: 30,left: 10),
                              child: Image.asset("assets/images/home-logo.png",width: 130,)
                          ),

                        ],
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "VENDOR REGISTRATION",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Mont-SemiBold"
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                    child: SizedBox(width: 100,child: Divider(height: 1,thickness: 1,color: ConstantColors.appTheme,),),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: TextField(
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
                          ),Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: TextField(
                              controller: storenameController,
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'Enter Your Store Name',

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
                              autocorrect: false,
                              onChanged: (String newVal) {
                                if (newVal.length <=
                                    maxLength) {
                                  text = newVal;
                                } else {
                                  mobileNumberController
                                      .text = text;
                                }
                              },
                              inputFormatters: [
                                MaskedInputFormatter('(###) ###-####')
                              ],

                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                prefixIcon:Padding(
                                  padding: EdgeInsets.only(top:13.0,left:5),
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
                                hintText: 'Enter Your Address',

                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: CategoriesList == null
                                ? const SizedBox(height: 0, width: double.infinity)
                                : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                  child: DropdownButton(
                                    icon: const Icon(
                                      Icons
                                          .arrow_drop_down_circle_outlined,
                                      size: 15,
                                    ),
                                    dropdownColor:
                                    Colors.white,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    hint: categoryName.text==''?const Text(
                                      'Select Category',
                                      style: TextStyle(
                                          fontFamily:
                                          "Lorin",
                                          fontWeight:
                                          FontWeight
                                              .w700,
                                          fontSize: 14.0,
                                          color: Color(
                                              0xFF141E28)),
                                    ):Text(
                                      ''+categoryName.text,
                                      style: const TextStyle(
                                          fontFamily:
                                          "Lorin",
                                          fontWeight:
                                          FontWeight
                                              .w700,
                                          fontSize: 14.0,
                                          color: Color(
                                              0xFF141E28)),
                                    ),
                                    value: categoryName.text != '' ? categoryName.text : null,
                                    items: CategoriesList
                                        .map((item) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          item['CategoryName'],
                                          style: const TextStyle(
                                              color: Color(
                                                  0xFF000000)),
                                        ),
                                        value: item['CategoryName']
                                            .toString(),
                                      );
                                    }).toList(), onChanged: (Object? value) {
                                    setState(() {
                                      print('' + value!.toString());
                                      categoryName.text =
                                          value.toString();
                                      for(int i=0;i<CategoriesList.length;i++){
                                        if(categoryName.text==CategoriesList[i]['CategoryName']){
                                          categoryid.text=CategoriesList[i]['CategoryId'].toString();
                                        }
                                      }
                                      loadstates();
                                    });
                                  },

                                  ),
                                ),
                                const Divider(thickness: 1,height: 1,color: Colors.grey,)
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:   [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                                  child: CountriesList == null
                                      ? const SizedBox(height: 0, width: double.infinity)
                                      : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 0, 5, 0),
                                        child: DropdownButton(
                                          icon: const Icon(
                                            Icons
                                                .arrow_drop_down_circle_outlined,
                                            size: 15,
                                          ),
                                          dropdownColor:
                                          Colors.white,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          hint: countryController.text==''?const Text(
                                            'Select Country',
                                            style: TextStyle(
                                                fontFamily:
                                                "Lorin",
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize: 14.0,
                                                color: Color(
                                                    0xFF141E28)),
                                          ):Text(
                                            ''+countryController.text,
                                            style: const TextStyle(
                                                fontFamily:
                                                "Lorin",
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize: 14.0,
                                                color: Color(
                                                    0xFF141E28)),
                                          ),
                                          value: countryController.text != '' ? countryController.text : null,
                                          items: CountriesList
                                              .map((item) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                item['CountryName'],
                                                style: const TextStyle(
                                                    color: Color(
                                                        0xFF000000)),
                                              ),
                                              value: item['CountryName']
                                                  .toString(),
                                            );
                                          }).toList(), onChanged: (Object? value) {
                                          setState(() {
                                            print('' + value!.toString());
                                            countryController.text =
                                                value.toString();
                                            for(int i=0;i<CountriesList.length;i++){
                                              if(countryController.text==CountriesList[i]['CountryName']){
                                                countryControllerId.text=CountriesList[i]['CountryId'].toString();
                                              }
                                            }
                                            loadstates();
                                          });
                                        },

                                        ),
                                      ),
                                      const Divider(thickness: 1,height: 1,color: Colors.grey,)
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 10, 15, 0),
                                  child: statelists == null ? const SizedBox(height: 0, width: double.infinity)
                                      : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: DropdownButton(
                                          icon: const Icon(
                                            Icons
                                                .arrow_drop_down_circle_outlined,
                                            size: 15,
                                          ),
                                          dropdownColor:
                                          Colors.white,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          hint: stateController.text==''?const Text(
                                            'Select State',
                                            style: TextStyle(
                                                fontFamily:
                                                "Lorin",
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize: 14.0,
                                                color: Color(
                                                    0xFF141E28)),
                                          ):Text(
                                            ''+stateController.text,
                                            style: const TextStyle(
                                                fontFamily:
                                                "Lorin",
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize: 14.0,
                                                color: Color(
                                                    0xFF141E28)),
                                          ),
                                          value: stateController.text != '' ? stateController.text : null,
                                          items: statelists
                                              .map((item) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                item['StateName'],
                                                style: const TextStyle(
                                                    color: Color(
                                                        0xFF000000)),
                                              ),
                                              value: item['StateName']
                                                  .toString(),
                                            );
                                          }).toList(), onChanged: (Object? value) {
                                          setState(() {
                                            print('' + value!.toString());
                                            stateController.text =
                                                value.toString();
                                            // for(int i=0;i<CountriesList.length;i++){
                                            //   if(countryController.text==CountriesList[i]['CountryName']){
                                            //     countryControllerId.text=CountriesList[i]['CountryId'].toString();
                                            //   }
                                            // }
                                            // loadstates();
                                          });
                                        },

                                        ),
                                      ),
                                      const Divider(thickness: 1,height: 1,color: Colors.grey,)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:   [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                                  child: TextField(
                                    controller: cityController,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintText: 'City',

                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 10, 15, 0),
                                  child: TextField(
                                    controller: zipcodeController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      counterText: "",

                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintText: 'Enter Zip Code ',
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                  } if (storenameController.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "enter store name",
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
                                  }else if (mobileNumberController.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "enter mobile number",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else if (text.length < 14 ) {
                                    Fluttertoast.showToast(
                                        msg: "Please enter valid mobile number",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else if (addressController.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "enter address",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else if (categoryName.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "Choose Category",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else if (countryController.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "Choose country",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else if (stateController.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "Choose state",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else if (cityController.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "Enter city",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else if (zipcodeController.text == '') {
                                    Fluttertoast.showToast(
                                        msg: "Enter zipcode",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }else {
                                    await pr.show();
                                    getUploadedFiles();
                                  }
                                },
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.60,
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
                      ),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }

  Future<void> getUploadedFiles() async {
    String ul='http://app.adslay.com/API/AccountAPI/CheckEmailAvailability?Email='+emailController.text.toString();
    print("Get order image list :" + ul);
    final response22 = await get(
      Uri.parse(ul),
    );
    print('' + response22.body);
    Map data1 = jsonDecode(response22.body);
    String msg = data1['msg'].toString();
    if(msg=='failed'||msg=='Failed'){
      getDataFromAPI();
    }else{
      await pr.hide();
      Fluttertoast.showToast(
          msg: "Email id Already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }

  void getDataFromAPI() async {
    String url1 = APIConstant.vendorapi;
    print(url1);
    Map<String, dynamic> body = {
      'Name': ''+fullNameController.text.toString(),
      'Email': ''+emailController.text.toString(),
      'StoreName': ''+storenameController.text.toString(),
      'MobileNo': '+1'+mobileNumberController.text.toString(),
      'City': ''+cityController.text.toString(),
      'State': ''+stateController.text.toString(),
      'Country': ''+countryController.text.toString(),
      'ZipCode': ''+zipcodeController.text.toString(),
      'CategoryId': ''+categoryid.text.toString(),
      'Address': ''+addressController.text.toString(),
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
    if(msg=='Success'){
      int StoreId=data1['StoreId'];
      print(""+StoreId.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>VendorUpload(vendroname:storenameController.text.toString(),vendorid:StoreId.toString())));
    }else{
      Fluttertoast.showToast(
          msg: "Something went wrong, Please try again.",
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
