import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'API.dart';
import 'CartScreen.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'SearchScreen.dart';
import 'StoreDetails.dart';
import 'UploadFiles.dart';
import 'animated_custom_dialog.dart';
import 'guest_dialog.dart';

class ChoosePlan extends StatefulWidget {
  var storeId;

  ChoosePlan({this.storeId});

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  String email = '';
  String mobileNumber = '';
  bool isLoading = true;
  String deviceOS = '';

  // int storeId = 0;
  String title = '';
  String city = '';
  String state = '';
  String country = '';
  String zipCode = '';
  String imageUrl = '';
  String screenSize = '';
  int durationInDays = 0;
  double actualPrice = 0.0;
  double offerPrice = 0.0;
  String footTraffic = '';
  String type = '';
  String fileFormat = '';
  String? selectedCountryName;
  String? selectedCountryNameTimes;
  bool isdataloaded = true;
  int _radioValue1 = 100;


  final PackageName = TextEditingController();
  final ActualPrice = TextEditingController();
  final PackageId = TextEditingController();
  final ScreenSize = TextEditingController();
  final StoreId = TextEditingController();
  final DurationinDays = TextEditingController();
  final NoofTimes = TextEditingController();

  List<dynamic> screenSizeList = [];
  List<dynamic> noOfTimesList = [];
  List<dynamic> storePackagesList = [];
  List<dynamic> data1 = [];
  List<dynamic> cartList = [];

  var cartDetailId = '';

  Future<void> getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mobileNumber = prefs.getString('mobilenumber')!;
        email = prefs.getString('email')!;
      });
    } catch (e) {
      print(e);
    }

    String url1 = APIConstant.getPackageDetails;
    print('Get Store details in choose plan screen url: ' + url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
      'StoreId': widget.storeId.toString(),
    };
    print('Get Store details in choose plan body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );

    print('Category base StoresList response :' + response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];

      if (msg == "Success" || msg == "success") {
        // storeId = jsonDecode(response.body)['StoreId'].toString();
        title = jsonDecode(response.body)['Title'];
        city = jsonDecode(response.body)['City'];
        state = jsonDecode(response.body)['State'];
        zipCode = jsonDecode(response.body)['ZipCode'];
        imageUrl = jsonDecode(response.body)['ImageUrl'];
        screenSize = jsonDecode(response.body)['ScreenSize'];
        durationInDays = jsonDecode(response.body)['DurationinDays'];
        actualPrice = jsonDecode(response.body)['ActualPrice'];
        offerPrice = jsonDecode(response.body)['OfferPrice'];
        footTraffic = jsonDecode(response.body)['FootTraffic'];
        type = jsonDecode(response.body)['Type'];
        fileFormat = jsonDecode(response.body)['FileFormat'];

        screenSizeList = jsonDecode(response.body)['ScreenSizeList'];
        print('strr:   ' + screenSizeList.toString());
        print('strr:   ' + screenSizeList[0]['ScreenSize'].toString());
        noOfTimesList = jsonDecode(response.body)['NoofTimesList'];
        // storePackagesList = jsonDecode(response.body)['StorePackagesList'];

      } else {
        print("Unable to get API response.");
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  Future<void> loadingtime() async {
    setState(() {
      isdataloaded = true;
    });
    String url1 = APIConstant.getStorePackage;
    print('Category base StoresList url: ' + url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
      'StoreId': widget.storeId.toString(),
      'ScreenSize': selectedCountryName.toString(),
      'NoofTimes': selectedCountryNameTimes.toString(),
    };
    print('Category base StoresList body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    setState(() {
      data1 = jsonDecode(response.body)['StorePackagesList'];
      print("" + data1.toString());
      _radioValue1=100;
      PackageName.text = '';
      ActualPrice.text = '';
      isdataloaded = false;
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
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600)
    );


    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: false,
          child: Column(
            //mainAxisSize: MainAxisSize.max,
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
                            padding: const EdgeInsets.only(
                                top: 0, right: 30, left: 10),
                            child: Image.asset(
                              "assets/images/home-logo.png",
                              width: 130,
                            )),
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
                                  padding: const EdgeInsets.fromLTRB(
                                      7, 10, 5, 0),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SearchScreen()));
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
                  ],
                ),

                isLoading?Shimmer.fromColors(
                    baseColor: ConstantColors.lightGrey,
                    highlightColor: Colors.white,
                    enabled: true,
                    child: ListView(
                      shrinkWrap: true, // use it
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 1.5,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(1, (index) {
                            return InkWell(
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.width * 0.40,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          ),
                        )
                      ],
                    )
                ):Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 220,//MediaQuery.of(context).size.width * 0.50,
                          //   alignment: Alignment.center,
                          //   child: Image(
                          //     fit: BoxFit.fill,
                          //     image: NetworkImage(imageUrl,
                          //     ),
                          //   ),
                          // ),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 220,//MediaQuery.of(context).size.width * 0.60,
                                      alignment: Alignment.center,
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Image.asset("assets/images/logo.jpg"),
                                        //const Icon(Icons.refresh_outlined),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        // height: 150,
                                      )
                                  ),
                                )
                            ),
                          ),
                          // Container(
                          //     width: MediaQuery.of(context).size.width,
                          //     height: 220,//MediaQuery.of(context).size.width * 0.60,
                          //     alignment: Alignment.center,
                          //     child: CachedNetworkImage(
                          //       imageUrl: imageUrl,
                          //       placeholder: (context, url) => const Center(
                          //           child: CircularProgressIndicator()),
                          //       errorWidget: (context, url, error) =>
                          //           Image.asset("assets/images/logo.jpg"),
                          //       //const Icon(Icons.refresh_outlined),
                          //       fit: BoxFit.cover,
                          //       width: double.infinity,
                          //       // height: 150,
                          //     )
                          // ),



                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 50),
                      //   child: Center(
                      //     child: Image.asset(
                      //       "assets/images/desilogo.png",
                      //       fit: BoxFit.cover,
                      //       height: 100,
                      //       width: 100,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                isLoading?Shimmer.fromColors(
                    baseColor: ConstantColors.lightGrey,
                    highlightColor: Colors.white,
                    enabled: true,
                    child: ListView(
                      shrinkWrap: true, // use it
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 1.5,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(1, (index) {
                            return InkWell(
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.width * 0.40,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          ),
                        )
                      ],
                    )
                ):Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 5, 8),
                  child: Text(
                    "$title - $city,$state,$country",
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ),
                isLoading?Shimmer.fromColors(
                    baseColor: ConstantColors.lightGrey,
                    highlightColor: Colors.white,
                    enabled: true,
                    child: ListView(
                      shrinkWrap: true, // use it
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 1.5,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(1, (index) {
                            return InkWell(
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.width * 0.40,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          ),
                        )
                      ],
                    )
                ):SizedBox(
                  //height: 220,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                  elevation: 2.0,
                                  child: Container(
                                    //height: 230,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: const [
                                        //     Flexible(
                                        //       child: Padding(
                                        //         padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                        //         child: TextField(
                                        //           decoration: InputDecoration(
                                        //               enabledBorder: UnderlineInputBorder(
                                        //                 borderSide: BorderSide(color: Colors.grey),
                                        //               ),
                                        //               focusedBorder: UnderlineInputBorder(
                                        //                 borderSide: BorderSide(color: Colors.grey),
                                        //               ),
                                        //               filled: true,
                                        //               fillColor: Color(0xFFFFFFFF),
                                        //               hintText: 'Select Screen Size',
                                        //               suffixIcon: Icon(
                                        //                 Icons.arrow_drop_down,
                                        //                 size: 35,
                                        //               )
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              17.0, 5, 10, 0),
                                          child: Container(
                                            height: 56,
                                            padding:
                                            const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                    const Color(0xFFF2F2F2),
                                                    width: 1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    13),
                                                color: const Color(
                                                    0xFFFFFFFFF)),
                                            child: screenSizeList == null ? const SizedBox(height: 0, width: double.infinity)
                                                : DropdownButton(
                                              icon: const Icon(
                                                Icons
                                                    .arrow_drop_down_circle_outlined,
                                                size: 15,
                                              ),
                                              dropdownColor:
                                              Colors.white,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              hint: const Text(
                                                'Select Screen Size',
                                                style: TextStyle(
                                                    fontFamily:
                                                    "Lorin",
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize: 14.0,
                                                    color: Color(
                                                        0xFF141E28)),
                                              ),
                                              value: selectedCountryName !=
                                                  null
                                                  ? selectedCountryName
                                                  : null,
                                              // onChanged: (newValue) {
                                              //   setState(() {
                                              //     selectedCountryName = newValue;
                                              //   });
                                              // },
                                              items: screenSizeList
                                                  .map((item) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                    item[
                                                    'ScreenSize'],
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xFF000000)),
                                                  ),
                                                  value: item[
                                                  'ScreenSize']
                                                      .toString(),
                                                );
                                              }).toList(),
                                              onChanged:
                                                  (String? value) {
                                                setState(() {
                                                  print(
                                                      '' + value!);
                                                  selectedCountryName =
                                                      value;
                                                  isdataloaded = true;
                                                  selectedCountryNameTimes=null;

                                                });
                                              },
                                              // items: CountryList.map((valueItem) {
                                              //   return DropdownMenuItem(
                                              //     value: valueItem,
                                              //     child: Text(valueItem),
                                              //   );
                                              // }).toList(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: const [
                                        //     Flexible(
                                        //       child: Padding(
                                        //         padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                        //         child: TextField(
                                        //           decoration: InputDecoration(
                                        //               enabledBorder: UnderlineInputBorder(
                                        //                 borderSide: BorderSide(color: Colors.grey),
                                        //               ),
                                        //               focusedBorder: UnderlineInputBorder(
                                        //                 borderSide: BorderSide(color: Colors.grey),
                                        //               ),
                                        //               filled: true,
                                        //               fillColor: Color(0xFFFFFFFF),
                                        //               hintText: 'Select No Of Times',
                                        //               suffixIcon: Icon(
                                        //                 Icons.arrow_drop_down,
                                        //                 size: 35,
                                        //               )
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              17.0, 5, 10, 0),
                                          child: Container(
                                            height: 56,
                                            padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                    const Color(0xFFF2F2F2),
                                                    width: 1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    13),
                                                color:
                                                const Color(0xFFFFFFFFF)),
                                            child: noOfTimesList == null
                                                ? const SizedBox(
                                                height: 0,
                                                width:
                                                double.infinity)
                                                : DropdownButton(
                                              icon: const Icon(
                                                Icons
                                                    .arrow_drop_down_circle_outlined,
                                                size: 15,
                                              ),
                                              dropdownColor:
                                              Colors.white,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              hint: const Text(
                                                'Select No of Times',
                                                style: TextStyle(
                                                    fontFamily:
                                                    "Lorin",
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                    fontSize: 14.0,
                                                    color: Color(
                                                        0xFF141E28)),
                                              ),
                                              value: selectedCountryNameTimes !=
                                                  null
                                                  ? selectedCountryNameTimes
                                                  : null,
                                              // onChanged: (newValue) {
                                              //   setState(() {
                                              //     selectedCountryName = newValue;
                                              //   });
                                              // },
                                              items: noOfTimesList
                                                  .map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item['NoofTimes']
                                                        .toString()+' times',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xFF000000)),
                                                  ),
                                                  value: item[
                                                  'NoofTimes']
                                                      .toString(),
                                                );
                                              }).toList(),
                                              onChanged:
                                                  (String? value) {
                                                setState(() {
                                                  print(
                                                      '' + value!);
                                                  selectedCountryNameTimes =
                                                      value
                                                          .toString();

                                                  if (selectedCountryName ==
                                                      null) {
                                                  } else if (selectedCountryNameTimes ==
                                                      null) {
                                                  } else {
                                                    loadingtime();
                                                  }
                                                });
                                              },
                                              // items: CountryList.map((valueItem) {
                                              //   return DropdownMenuItem(
                                              //     value: valueItem,
                                              //     child: Text(valueItem),
                                              //   );
                                              // }).toList(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isLoading?Shimmer.fromColors(
                    baseColor: ConstantColors.lightGrey,
                    highlightColor: Colors.white,
                    enabled: true,
                    child: ListView(
                      shrinkWrap: true, // use it
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 1.5,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(1, (index) {
                            return InkWell(
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.width * 0.40,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          ),
                        )
                      ],
                    )
                ):Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isdataloaded == true)
                      const SizedBox(
                        width: 0,
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 8),
                          child: Center(
                            child: Text(
                              "CHOOSE YOUR PLAN",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                      child: SizedBox(
                        child: Stack(children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                if (isdataloaded == true)
                                  const SizedBox(
                                    width: 0,
                                  )
                                else
                                  Center(
                                    child: Container(
                                      height: 70,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data1.length,
                                        itemBuilder: (context, index1) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _radioValue1 = index1;
                                                PackageName.text = '' + data1[index1]['PackageName'];
                                                ActualPrice.text = '' +data1[index1]['ActualPrice'].toString();
                                                PackageId.text = '' +data1[index1]['PackageId'].toString();
                                                StoreId.text = '' +data1[index1]['StoreId'].toString();
                                                ScreenSize.text = '' +data1[index1]['ScreenSize'].toString();
                                                DurationinDays.text = '' +data1[index1]['DurationinDays'].toString();
                                                NoofTimes.text = '' +data1[index1]['NoofTimes'].toString();
                                              });
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 0, 0, 0),
                                                child: Card(
                                                    shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 1,
                                                            color: _radioValue1 ==
                                                                index1
                                                                ? Colors
                                                                .green
                                                                : Colors
                                                                .grey) // if you need this
                                                    ),
                                                    elevation: 2.0,
                                                    child: SizedBox(
                                                      height: 75,
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.30,
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Center(
                                                                  child:
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        5,
                                                                        0,
                                                                        0),
                                                                    child:
                                                                    Text(
                                                                      "" +
                                                                          data1[index1]['PackageName']!.toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                          13),
                                                                    ),
                                                                  )),
                                                              Center(
                                                                  child:
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .fromLTRB(
                                                                        0,
                                                                        5,
                                                                        0,
                                                                        10),
                                                                    child: Text(
                                                                        "\$" +
                                                                            data1[index1]['ActualPrice']
                                                                                .toString(),
                                                                        style:
                                                                        TextStyle(
                                                                          color: _radioValue1 == index1
                                                                              ? Colors.green
                                                                              : Colors.blue,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          fontSize:
                                                                          17,
                                                                        )),
                                                                  )),
                                                            ],
                                                          ),
                                                          Align(
                                                            alignment:
                                                            Alignment
                                                                .topRight,
                                                            child:
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.fromLTRB(
                                                                  0,
                                                                  5,
                                                                  5,
                                                                  0),
                                                              child: _radioValue1 ==
                                                                  index1
                                                                  ? Image
                                                                  .asset(
                                                                "assets/images/tickGreen.png",
                                                                height:
                                                                25,
                                                                width:
                                                                25,
                                                              )
                                                                  : const SizedBox(
                                                                  width:
                                                                  25,
                                                                  height:
                                                                  25),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
                isLoading?Shimmer.fromColors(
                    baseColor: ConstantColors.lightGrey,
                    highlightColor: Colors.white,
                    enabled: true,
                    child: ListView(
                      shrinkWrap: true, // use it
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 1.5,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(1, (index) {
                            return InkWell(
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.width * 0.40,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 10,
                                                    alignment: Alignment.center,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          ),
                        )
                      ],
                    )
                ):Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: MaterialButton(
                      onPressed: () {
    if(email=='guest@guest.com') {
    showAnimatedDialog(context, GuestDialog(), isFlip: true);
    }else {
      if (PackageName.text == '') {
        Fluttertoast.showToast(
            msg: "Please choose package",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        getData11();
      }
    }
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        height: 45,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff3962cb),
                                Color(0xff3962cb),
                              ],
                            )),
                        //padding: const EdgeInsets.all(10.0),
                        child: const Center(
                          child: Text(
                            "CONTINUE BOOKING",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Lorin"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  late ProgressDialog pr;

  Future<void> getData11() async {

    pr.show();
    String url1 = APIConstant.insCartItems;
    print('Category base StoresList url: '+url1);
    Map<String, dynamic> body = {
      'MobileNo': ''+mobileNumber,
      'StoreId': widget.storeId.toString(),
      'ScreenSize': selectedCountryName.toString(),
      'NoofTimes': selectedCountryNameTimes.toString(),
      'PackageId': PackageId.text.toString(),

    };
    print('Category base StoresList body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    pr.hide();
    print('Category base StoresList response :' + response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];

      if (msg == "Product Added to Your Cart" || msg == "success")
      {

        getCartItems();
        cartDetailId = jsonDecode(response.body)['CartDetailId'].toString();
        print("Generated cart detail id is: "+cartDetailId.toString());

      }else{

        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        print("Unable to get API response.");

      }
    });

    setState(() {
      isLoading = false;
    });


  }

  Future<void> getCartItems() async {

    String url1 = APIConstant.getCartItems;
    print("Get cart items url is: "+url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
    };
    print('Get cart items api body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    //print('Cart items response :' + response.body.toString());
    setState(() {
      cartList = jsonDecode(response.body)['CartList'];
      if (cartList.isNotEmpty){
        MainScreen.cartItemsCount = cartList.length;
      } else {
        MainScreen.cartItemsCount = 0;
      }
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadFiles(
              cartDetailId: cartDetailId.toString() ,
            )));

    setState(() {
      isLoading=false;
    });
  }



}
