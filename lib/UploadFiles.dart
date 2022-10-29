import 'dart:convert';
import 'dart:io';
import 'package:adslay/ChoosePlan.dart';
import 'package:adslay/Constant/ConstantsColors.dart';
import 'package:adslay/StoreDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:images_picker/images_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'API.dart';
import 'CartScreen.dart';
import 'package:intl/intl.dart';
import 'MainScreen.dart';
import 'SearchScreen.dart';
class UploadFiles extends StatefulWidget {
  var cartDetailId;
  UploadFiles({this.cartDetailId});
  @override
  State<UploadFiles> createState() => _UploadFilesState();
}
class _UploadFilesState extends State<UploadFiles> {
  String email = '';
  String mobileNumber = '';
  late DateTime pickedDate;
  final selecteddate = TextEditingController();
  late TimeOfDay time;
  bool isLoading = true;
  String deviceOS = '';
  String cartDetailId = '';
  String storeId = '';
  String screenSize = '';
  String noOfTimes = '';
  String packageId = '';
  String storeName = '';
  String city = '';
  String state = '';
  String country = '';
  String zipCode = '';
  String address = '';
  String packageName = '';
  String actualPrice = '';
  String imageUrl = '';
  String onlyDate = '';
  String selectdate = "Select start date";
  String type = '';
  String? selectedCountryName;
  String? selectedCountryNameTimes;
  TextEditingController vendor_image = TextEditingController();

  List<dynamic> data1 = [];
  List<dynamic> uploadedImagesList = [];

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

    String url1 = APIConstant.getSelectedStoreCartDetails;
    print('Get cart item details url: ' + url1);
    Map<String, dynamic> body = {
      'Mobile': '' + mobileNumber,
      'CartDetailId': widget.cartDetailId.toString(),
    };

    print('Get cart item details body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );

    print('Get AD space details response :' + response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];

      if (msg == "Success" || msg == "success") {
        cartDetailId = jsonDecode(response.body)['CartDetailId'].toString();
        storeId = jsonDecode(response.body)['StoreId'].toString();
        screenSize = jsonDecode(response.body)['ScreenSize'];
        noOfTimes = jsonDecode(response.body)['NoofTimes'].toString();
        packageId = jsonDecode(response.body)['PackageId'].toString();
        storeName = jsonDecode(response.body)['StoreName'];
        city = jsonDecode(response.body)['City'];
        state = jsonDecode(response.body)['State'];
        country = jsonDecode(response.body)['Country'];
        zipCode = jsonDecode(response.body)['ZipCode'];
        address = jsonDecode(response.body)['Address'];
        packageName = jsonDecode(response.body)['PackageName'];
        actualPrice = jsonDecode(response.body)['ActualPrice'].toString();
        imageUrl = jsonDecode(response.body)['ImageUrl'];
        selecteddate.text = jsonDecode(response.body)['StartDate'];
      } else {
        print("Unable to get API response.");
      }
    });
    getUploadedFiles();

    setState(() {
      isLoading = false;
    });
  }

  DateTime selectedDate = DateTime.now();
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  void _pickDate() async {
    DateTime? date = await showDatePicker(
        context: this.context,
        initialDate: selectedDate,
        //initialDate: DateTime.now(),
        //firstDate: DateTime(DateTime.now().year - 50),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(DateTime.now().year + 10));

    if (date != null && date != selectedDate) {
      setState(() {
        onlyDate = DateFormat("MM-dd-yyyy").format(date);
        DateFormat format = DateFormat("MM-dd-yyyy");
        //print(format.parse(onlyDate));
        print("onlyDate>>" + onlyDate);
        print("selectedDate<><><><>$date");
        print("selectedDate<?>><>???$selecteddate");
        pickedDate = format.parse(onlyDate);
        // onlyDate==selecteddate.text;
        print("pickedDate>><<<$pickedDate");
        selecteddate.text =
            '${pickedDate.month}/${pickedDate.day}/${pickedDate.year}';
        print("selecteeee>>>" + selecteddate.text);
      });
    }
    // if (date != null) {
    //   setState(() {
    //     pickedDate = date!;
    //     selecteddate.text='${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    getData();

    selecteddate.text;
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
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            left: true,
            top: true,
            right: true,
            bottom: false,
            child: Column(
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
                              padding: const EdgeInsets.only(
                                  top: 0, right: 30, left: 10),
                              child: Image.asset(
                                "assets/images/home-logo.png",
                                width: 130,
                              )),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CartScreen()));
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
                                    padding:
                                        const EdgeInsets.fromLTRB(7, 10, 5, 0),
                                    child: Image.asset(
                                      "assets/images/cart.png",
                                      width: 28,
                                      height: 28,
                                    ),
                                  ),
                                  MainScreen.cartItemsCount > 0
                                      ? Positioned(
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: ConstantColors.appTheme,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              //color: Colors.red,
                                              child: Center(
                                                child: Text(
                                                  "" +
                                                      MainScreen.cartItemsCount
                                                          .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontFamily:
                                                          "Mont-Regular"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 1,
                                          width: 1,
                                        )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
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
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 5, 0),
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
                  isLoading
                      ? Shimmer.fromColors(
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
                                children: List.generate(
                                  2,
                                  (index) {
                                    return InkWell(
                                      child: GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 5, 5),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Card(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.40,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Card(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 10,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Card(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 10,
                                                        alignment:
                                                            Alignment.center,
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
                          ))
                      : Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Card(
                                                      elevation: 2,
                                                      child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 210,
                                                          //MediaQuery.of(context).size.width * 0.60,
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: imageUrl,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Image.asset(
                                                                    "assets/images/logo.jpg"),
                                                            //const Icon(Icons.refresh_outlined),
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            // height: 150,
                                                          )),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 5, 8),
                                      child: Text(
                                        "$storeName - $city,$state,$country",
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 5, 5, 10),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Card(
                                          elevation: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                child: SizedBox(
                                                  height: 75,
                                                  //width: MediaQuery.of(context).size.width * 0.24,
                                                  child: Stack(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: Text(
                                                              "AD TYPE",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: Text(
                                                              '' + screenSize,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 0, 0),
                                                child: SizedBox(
                                                  height: 75,
                                                  //width: MediaQuery.of(context).size.width * 0.20,
                                                  child: Stack(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: Text(
                                                              "NO OF TIMES",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 0, 0),
                                                            child: Text(
                                                              '' +
                                                                  noOfTimes +
                                                                  ' Times',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                child: SizedBox(
                                                  height: 75,
                                                  //width: MediaQuery.of(context).size.width * 0.34,
                                                  child: Stack(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 5, 8, 0),
                                                            child: Text(
                                                              "SELECTED PLAN",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 5, 5, 0),
                                                            child: Text(
                                                              "\$" +
                                                                  actualPrice +
                                                                  "(" +
                                                                  packageName +
                                                                  ")",
                                                              // + cartList[index]["ActualPrice"].toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (selecteddate.text == '') {
                                          Fluttertoast.showToast(
                                              msg: "Please choose start date",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          _chooseFiles();
                                        }
                                      },
                                      child: SizedBox(
                                        //height: 220,
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                const SizedBox(height: 40),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Card(
                                                        child: Container(
                                                      height: 180,
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 60),
                                                          const Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Upload your files or Browse",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                          // SizedBox(height: 40),
                                                          GestureDetector(
                                                            onTap: () {
                                                              _pickDate();
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            15,
                                                                            10,
                                                                            15,
                                                                            0),
                                                                    child:
                                                                        TextField(
                                                                      onTap:
                                                                          () {
                                                                        _pickDate();
                                                                          },
                                                                      readOnly:
                                                                          true,
                                                                      controller:
                                                                          selecteddate,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        enabledBorder:
                                                                            const UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.grey),
                                                                        ),
                                                                        focusedBorder:
                                                                            const UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.grey),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            const Color(0xFFFFFFFF),
                                                                        hintText:
                                                                            selectdate,
                                                                        suffixIcon:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 10),
                                                                          child:
                                                                              const Image(
                                                                            image:
                                                                                AssetImage(
                                                                              'assets/images/calender.png',
                                                                            ),
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Center(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80), // if you need this
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: 100,
                                                      height: 100,
                                                      child: Image.asset(
                                                        "assets/images/uploadfiles.png",
                                                        fit: BoxFit.cover,
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              //top: 0,
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    if (uploadedImagesList
                                                        .isNotEmpty) {
                                                      _uploadDateserver();

                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Please upload atleast one AD file.",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }

                                                  },
                                                  textColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    height: 45,
                                                    decoration:
                                                        const BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                      colors: [
                                                        Color(0xff3962cb),
                                                        Color(0xff3962cb),
                                                      ],
                                                    )),
                                                    //padding: const EdgeInsets.all(10.0),
                                                    child: const Center(
                                                      child: Text(
                                                        "CONTINUE",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Lorin"),
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
                                    const SizedBox(height: 10),
                                    isLoading
                                        ? Shimmer.fromColors(
                                            baseColor: ConstantColors.lightGrey,
                                            highlightColor: Colors.white,
                                            enabled: true,
                                            child: ListView(
                                              shrinkWrap: true, // use it
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              children: [
                                                GridView.count(
                                                  crossAxisCount: 1,
                                                  childAspectRatio: 2,
                                                  physics:
                                                      const ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  children: List.generate(
                                                    3,
                                                    (index) {
                                                      return InkWell(
                                                        child: GestureDetector(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    5, 5, 5, 5),
                                                            child: Center(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child: Card(
                                                                        child:
                                                                            Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 0.30,
                                                                          alignment:
                                                                              Alignment.center,
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ),
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child: Card(
                                                                        child:
                                                                            Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          height:
                                                                              10,
                                                                          alignment:
                                                                              Alignment.center,
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ),
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child: Card(
                                                                        child:
                                                                            Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          height:
                                                                              10,
                                                                          alignment:
                                                                              Alignment.center,
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
                                            ))
                                        : ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount:
                                                uploadedImagesList.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                Image.network(
                                                              uploadedImagesList[
                                                                      index]
                                                                  ["ImageUrl"],
                                                              height: 100,
                                                              width: 150,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 2,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        8,
                                                                        10,
                                                                        5,
                                                                        15),
                                                                child: Text(
                                                                  "" +
                                                                      uploadedImagesList[
                                                                              index]
                                                                          [
                                                                          "FileName"],
                                                                  maxLines: 2,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                              MaterialButton(
                                                                onPressed: () {
                                                                  removeUploadedFiles(
                                                                      uploadedImagesList[
                                                                              index]
                                                                          [
                                                                          "CusAdId"]);
                                                                },
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                child:
                                                                    Container(
                                                                  width: 80,
                                                                  height: 40,
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      "Remove",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration.underline,
                                                                          color: Colors.blue,
                                                                          //ConstantColors.appTheme,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontFamily: "Lorin"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]);
                                            },
                                          ),
                                    const SizedBox(height: 50),
                                  ]);
                            },
                          ),
                        ),
                ]),
          ),
        ],
      ),
    );
  }

  String selectedFile = '';
  final String uploadUrl =
      APIConstant.base_url + 'StoresAPI/CustomerBookImages';
  late ProgressDialog pr;
  List<Media>? res111;
  _chooseFiles() async {
    res111 = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      quality: 0.8,
    );
    if (res111 != null) {
      setState(() {
        selectedFile = res111![0].path.toString();
      });
      print('' + res111![0].path.toString());
      await pr.show();
      File compressedFile = await FlutterNativeImage.compressImage(
        res111![0].path.toString(),
        quality: 5,
      );

      var res = await uploadImage(compressedFile.path, uploadUrl);
      print("File uploading to server response: " + res.toString());
      Map data1 = jsonDecode(res);
      String fileName = compressedFile.path.split('/').last;
      print(fileName);
      vendor_image.text = data1['fileName'].toString();
      print("Successfully File uploaded to server" + vendor_image.text);

      String msg = data1['msg'].toString();

      if (msg == "Success" || msg == "success") {
        _uploadFileDetailsToServer();
      } else {
        Fluttertoast.showToast(
            msg: "Unable to upload file..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print("Unable to upload file details to server");
      }
      await pr.hide();
      setState(() {
        isLoading = true;
        // getdata();
      });
    }
  }
Future<void> _uploadFileDetailsToServer() async{
    pr.show();
    String url2 = APIConstant.base_url + "StoresAPI/CustomerBookImageAPI";
    print('Upload file url: ' + url2);
    Map<String, dynamic> body = {
      'MobileNo': '' + mobileNumber,
      'CartDetailId': widget.cartDetailId.toString(),
      'ImageUrl': vendor_image.text,
      'VideoUrl': '',
      'StartDate': selecteddate.text,
    };
    print('Category base StoresList body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url2),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    pr.hide();
    print('Category base StoresList response :' + response.body.toString());
    String msg = jsonDecode(response.body)['msg'];
    if (msg == "Success" || msg == "success") {
      Fluttertoast.showToast(
          msg: "File uploaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ConstantColors.appTheme,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        isLoading = true;
        getUploadedFiles();
      });
    } else {
      Fluttertoast.showToast(
          msg: "Unable to upload file details.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      print("Unable to get uploaded Images List response.");
    }
}
  Future<void> _uploadDateserver() async {
    pr.show();
    String url1 = APIConstant.base_url + "StoresAPI/CustomerBookImageAPI";
    print('Upload file url: ' + url1);
    Map<String, dynamic> body = {
      'MobileNo': '' + mobileNumber,
      'CartDetailId': widget.cartDetailId.toString(),
      'VideoUrl': '',
      'StartDate': selecteddate.text,
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

    String msg = jsonDecode(response.body)['msg'];

    if (msg == "Success" || msg == "success") {
      // Fluttertoast.showToast(
      //     msg: "Date Updated successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: ConstantColors.appTheme,
      //     textColor: Colors.white,
      //     fontSize: 16.0);

      setState(() {
        isLoading = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CartScreen()));
      });
    } else {
      Fluttertoast.showToast(
          msg: "Unable to upload file details.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print("Unable to get uploaded Images List response.");
    }
  }
  Future<String> uploadImage(filepath, url) async {
    var request = MultipartRequest('POST', Uri.parse(url));
    request.files.add(await MultipartFile.fromPath('file', filepath));
    var res = await request.send();
    var responseString = await res.stream.bytesToString();
    print(responseString);
    return responseString;
  }

  Future<void> getUploadedFiles() async {
    String url1 = APIConstant.getUploadedImagesList;
    print('Get Uploaded Images List url: ' + url1);
    Map<String, dynamic> body = {
      'Mobile': '' + mobileNumber,
      'CartDetailId': widget.cartDetailId.toString(),
    };

    print('Get Uploaded Images List body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    print('Get Uploaded Images List response :' + response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];

      if (msg == "Success" || msg == "success") {
        uploadedImagesList = jsonDecode(response.body)['CustomerBookImageList'];
        print('Uploaded Image List :' + uploadedImagesList.toString());
      } else {
        print("Unable to get uploaded Images List response.");
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> removeUploadedFiles(CusAdId) async {
    String url1 = APIConstant.removeUploadedImagesFromList;
    print('Remove Uploaded Images From List url: ' + url1);
    Map<String, dynamic> body = {
      'Mobile': '9160747554',
      'CusAdId': CusAdId.toString(),
    };

    print('Remove Uploaded Images From List body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    print('Remove Uploaded Images From List response :' +
        response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];

      if (msg == "Success" || msg == "success") {
        Fluttertoast.showToast(
            msg: "File removed successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print("File removed successfully.");
        isLoading = true;
        getUploadedFiles();
      } else {
        Fluttertoast.showToast(
            msg: "Unable to remove file, Try after some time.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print("Unable to get uploaded Images List response.");
      }
    });

    setState(() {
      isLoading = false;
    });
  }
}
