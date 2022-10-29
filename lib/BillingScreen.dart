import 'dart:convert';
import 'package:adslay/stripe/blocs/pay/pay_bloc.dart';
import 'package:adslay/stripe/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API.dart';
import 'CartScreen.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'SearchScreen.dart';
import 'ThankYouScreen.dart';
class BillingScreen extends StatefulWidget {
  var total;
  var orderid;
  BillingScreen({this.total,this.orderid});
  @override
  State<BillingScreen> createState() => _BillingScreenState();
}
class _BillingScreenState extends State<BillingScreen> {
  bool isLoading = true;
  bool isCheckoutAvailable = false;
  List<dynamic> ordersHistoryList = [];
  List<dynamic> userDetails = [];
  String email = '';
  String mobileNumber = '';
  String username = '';
  int userid = 0;
  double subTotalValue = 0.0;
  late ProgressDialog pr;
  Map<String, dynamic>? paymentIntentData;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countryControllerId = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  List<dynamic> CountriesList = [];
  List<dynamic> statelists = [];
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
    String url1 = APIConstant.login;
    print(url1);
    Map<String, dynamic> body = {
      'MobileNo': ''+mobileNumber,
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
    //print(data);
    String msg = data['msg'];
    print(msg);
    if (msg=='No Records Found') {
    } else {
      setState(() {
        nameController.text = data['objCustomers']['FirstName'] + " " + data['objCustomers']['LastName'];
        emailController.text = data['objCustomers']['Email'];
        mobileNumberController.text = data['objCustomers']['MobileNo'];
        cityController.text = data['objCustomers']['City'];
        zipcodeController.text = data['objCustomers']['ZipCode'];
        addressController.text = data['objCustomers']['Address1'] ?? '';
        cityController.text = data['objCustomers']['City'];
        stateController.text = data['objCustomers']['State'];
        countryController.text = data['objCustomers']['Country'];
      });
    }
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
  // final stripeService = StripeService();
  @override
  Widget build(BuildContext context) {
    final payBloc = BlocProvider.of<PayBloc>(context);
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
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            SafeArea(
              left: false,
              top: true,
              right: false,
              bottom: false,
              child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
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
                                    MainScreen.cartItemsCount > 0 ?Positioned(
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration:  BoxDecoration(
                                            color: ConstantColors.appTheme,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          //color: Colors.red,
                                          child:  Center(
                                            child: Text(
                                              ""+MainScreen.cartItemsCount.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontFamily: "Mont-Regular"
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ):const SizedBox(height: 1,width: 1,)
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
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
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Image.asset(
                                  "assets/images/userprofile.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                Text(
                                  ""+username,
                                  style: const TextStyle(
                                    fontFamily: "Mont-SemiBold",
                                    fontSize: 17,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    "Unique ID: "+userid.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Mont-Regular',
                                      fontSize: 14,
                                      color: ConstantColors.appTheme,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Divider(
                            thickness: 5,
                            height: 10,
                            color: ConstantColors.lightGrey,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "BILLING ADDRESS",
                                      style: TextStyle(
                                        fontFamily: "Mont-SemiBold",
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: TextField(
                                      controller: nameController,
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
                                                  underline: SizedBox(),
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
                                                  underline: SizedBox(),
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
                                              hintText: 'Select City',

                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(5, 10, 15, 0),
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
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              hintText: 'Enter Zip Code ',
                                              counterText: "",

                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Divider(
                                      thickness: 5,
                                      height: 10,
                                      color: ConstantColors.lightGrey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Subtotal: ",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: "Mont-Regular",
                                            color: ConstantColors.appTheme,
                                          ),
                                        ),
                                        Text(
                                          "\$"+widget.total.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Mont-Regular",
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Text(
                                      "Taxes and shipping caculated at checkout",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Mont-Light",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (nameController.text == '') {
                                            Fluttertoast.showToast(
                                                msg: "enter name",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          } else if (addressController.text == '') {
                                            Fluttertoast.showToast(
                                                msg: "enter address",
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
                                            // getData11();
                                            // showLoading(context);
                                            // final amount = payBloc.state.amount;
                                            // final currency = payBloc.state.currency;
                                            // final resp = await stripeService.payWithNewCard(
                                            //     amount: amount,
                                            //     currency: currency
                                            // );
                                            // print("Payment response: "+resp.msg!);
                                            //
                                            // try{
                                            //   var json = jsonDecode(resp.msg!);
                                            //   var id = json['id'];
                                            //
                                            //   transactionId = jsonEncode(id);
                                            //   print("Payment transaction id is: "+transactionId);
                                            // }catch(e){
                                            //   transactionId = "NA";
                                            // }

                                            // Navigator.pop(context);
                                            // if ( resp.ok) {
                                            //   showAlert(context, 'Credit Card ok', 'Success Payment', transactionId, 'Completed', widget.total.toString());
                                            // } else {
                                            //   showAlert(context, 'Credit Card ok', 'Payment Failed', transactionId, 'Pending', widget.total.toString());
                                            // }
                                            int i = double.parse(widget.total).toInt();
                                            print("ii="+i.toString());
                                            pr.show();
                                            await makePayment(i.toString(), "USD");
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
                                              "PROCEED TO PAY",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> makePayment(String amount, String currencyCode)async{
    try {
      paymentIntentData = await createPaymentIntent(amount, currencyCode); //json.decode(response.body);
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
              paymentIntentData!['client_secret'],
              //How you can add Apple And Google Pay
              googlePay: false,
              applePay: false,
              testEnv: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'Faiz'))
          .then((value) {
        displayPaymentSheet();
      });
    } catch (e) {
      print("Exception OnClick " + e.toString());
    }
  }
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue){
        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());
        MainScreen.cartItemsCount = 0;
        pr.hide();
        completeBooking("Completed", paymentIntentData!['id'].toString(), widget.total.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        setState(() {
          paymentIntentData = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));
      }).onError((error, stackTrace){
        pr.hide();
        completeBooking("Pending", 'N/A', widget.total.toString());
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      pr.hide();
      completeBooking("Pending", 'N/A', widget.total.toString());
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }
  createPaymentIntent(String amount, String currency) async {
    try{
      Map<String, dynamic>body = {
        'amount': calculateMount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51KFd7HHjhOs2YctLJjPWRMLLEPI9bFcAWnhy8WGBfNnpJhY2jNMKQS62xznqdHeeGWACqBgUceKIAIwlSJGQgoOv00ELTk8nFR',
            'Content-Type': 'application/x-www-form-urlencoded'
          }
      );
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    }catch(e){
      print("Exception"+e.toString());
    }
  }
  calculateMount(String amount){
    final price = int.parse(amount)*100;
    return price.toString();
  }
  Future<void> completeBooking(String status, String transactionId, String amountPaid) async {
    pr.show();
    String url1 = APIConstant.completeBooking;//'http://app.adslay.com/API/OrderAPI/OrderInsertAPI';
    print('Upload billing details url: '+url1);
    Map<String, dynamic> body = {
      'MobileNo': ''+mobileNumber,//mobileNumber.toString(),
      'BillingAddress1': ''+addressController.text.toString(),
      'BillingAddress2': ''+zipcodeController.text.toString(),
      'BillingCity': ''+cityController.text.toString(),
      'BillingState': ''+stateController.text.toString(),
      'BillingCountry': ''+countryController.text.toString(),
    };
    print('Upload billing details body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    pr.hide();
    print('Upload billing details response :' + response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];
      if (msg == "Product Added to Your Cart" || msg == "success" ||  msg == "Success")
      {
        var orderId = jsonDecode(response.body)['OrderId'].toString();
        if(widget.orderid==0) {
          uploadPaymentDetails(status, transactionId, amountPaid, orderId);
        }else{
          uploadPaymentDetails(status, transactionId, amountPaid, widget.orderid.toString());
        }
      }else{
        print("Unable to get API response.");
      }
    });
    setState(() {
      isLoading = false;
    });
  }
  Future<void> uploadPaymentDetails(String status, String transactionId, String amountPaid, String orderId) async {
    pr.show();
    String url1 = APIConstant.uploadPaymentDetails;
    print('Upload payment details url: '+url1);
    Map<String, dynamic> body = {
      'PaymentStatus': status,
      'TransactionId': transactionId,
      'PaidAmount': amountPaid,
      'OrderId': orderId,
    };
    print('Upload payment details body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    pr.hide();
    print('Upload payment details response :' + response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];
      if ( msg == "success" ||  msg == "Success")
      {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ThankYouScreen(orderId: orderId,paymentamount:widget.total.toString())
            ),
            ModalRoute.withName("/")
        );
      }else{
        print("Unable to navigate to thank you page.");
      }
    });
    setState(() {
      isLoading = false;
    });
  }
}