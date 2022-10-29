import 'dart:convert';

import 'package:adslay/Constant/ConstantsColors.dart';
import 'package:adslay/ImagesScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'API.dart';
import 'BillingScreen.dart';
import 'CartScreen.dart';
import 'MainScreen.dart';
import 'PhotoPhoto.dart';


class OrderDetailsScreen extends StatefulWidget {

  var cartOrderId;

  OrderDetailsScreen({this.cartOrderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  String email = '';
  String mobileNumber = '';
  bool isLoading = true;
  String deviceOS = '';

  int OrderId = 0;
  String noOfTimes = '';
  String screenSize = '';
  String packageId = '';
  String selectPlan = '';
  String startDate = '';
  String endDate = '';
  String transactionId = '';
  String orderCreated = '';
  String packageName = '';
  String paidAmount = '';
  String storeName = '';
  String imageUrl = '';
  String city = '';
  String state = '';
  String country = '';
  String zipCode = '';
  String address = '';
  String bookImageurl = '';
  String paymentStatus = '';
  List<dynamic> OrderDetailsList = [];
  List<dynamic> OrderImageList = [];

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

    String url1 = APIConstant.getCompletedOrderDetails;
    print('Get Store details in choose plan screen url: ' + url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
      'OrderDetailId': widget.cartOrderId.toString(),
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

        OrderId = jsonDecode(response.body)['OrderId'];
        noOfTimes = jsonDecode(response.body)['NoofTimes'].toString();
        screenSize = jsonDecode(response.body)['ScreenSize'];
        packageId = jsonDecode(response.body)['PackageId'].toString();
        selectPlan = jsonDecode(response.body)['SelectPlan'].toString();
        startDate = jsonDecode(response.body)['StartDate'];
        endDate = jsonDecode(response.body)['EndDate'];
        transactionId = jsonDecode(response.body)['TransactionId'];
        orderCreated = jsonDecode(response.body)['OrderCreated'];
        packageName = jsonDecode(response.body)['PackageName'];
        paidAmount = jsonDecode(response.body)['PaidAmount'].toString();
        storeName = jsonDecode(response.body)['StoreName'];
        imageUrl = jsonDecode(response.body)['ImageUrl'];
        city = jsonDecode(response.body)['City'];
        state = jsonDecode(response.body)['State'];
        country = jsonDecode(response.body)['Country'];
        zipCode = jsonDecode(response.body)['ZipCode'];
        address = jsonDecode(response.body)['Address'];
        bookImageurl = jsonDecode(response.body)['BookImageurl'];
        paymentStatus = jsonDecode(response.body)['PaymentStatus'];

      } else {
        print("Unable to get API response.");
      }
    });




    String url12 = APIConstant.getOrderImagesListApi+widget.cartOrderId.toString();
    print("Get order image list :" +url1);
    final response22 = await get(
      Uri.parse(url12),
    );
    print(''+response22.body);
    OrderImageList = jsonDecode(response22.body)['OrderImageList'];

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





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  VideoCounselling(cartOrderId: widget.cartOrderId.toString())));

        },
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
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
              "View Images",
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
                              padding: const EdgeInsets.only(top: 0, right: 30,left: 10),
                              child: Image.asset("assets/images/home-logo.png",width: 130,)
                          ),

                        ],
                      ),
                    ],
                  ),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Order Details - OR-AD"+widget.cartOrderId.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Mont-SemiBold"
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                    child: SizedBox(width: 100,child: Divider(height: 1,thickness: 1,color: ConstantColors.appTheme,),),
                  ),

                  isLoading
                      ?Expanded(
                        child: Shimmer.fromColors(
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
                              children: List.generate(10, (index) {
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
                  ),
                      )
                      :Expanded(
                    child:
                    ListView.builder(
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0.0),
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
                                                      fit: BoxFit.contain,
                                                      width: double.infinity,
                                                      // height: 150,
                                                    )
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isLoading?const SizedBox(height: 20)
                                  :Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 5, 8),
                                child: Text(
                                  "$storeName - $city,$state,$country",
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Card(
                                    elevation: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.25,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:  [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "AD TYPE",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            '' + screenSize,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.25,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:  [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "NO OF TIMES",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            ''+ noOfTimes + " Times",
                                                            textAlign: TextAlign.center,
                                                            style:const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.24,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:  [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "TOTAL",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 2, 0),
                                                          child: Text(
                                                            "\$ "+ selectPlan,// + cartList[index]["ActualPrice"].toString(),
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.25,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:  [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "START DATE",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            '' + startDate,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.25,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:  [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "END DATE",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            '' + endDate,
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.25,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                          child: Text(
                                                            "",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "",// + cartList[index]["ActualPrice"].toString(),
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600),
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 10, 5, 8),
                                child: Text(
                                  "BILLING DETAILS",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side:  BorderSide(
                                          color: ConstantColors.appTheme, width: 0.6),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    elevation: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.25,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "DATE",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            '' + orderCreated,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.35,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "TRANSACTION ID",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            '' + transactionId,
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.10,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 2, 0),
                                                          child: Text(
                                                            "",// + cartList[index]["ActualPrice"].toString(),
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                              child: SizedBox(
                                                //height: 60,
                                                width: MediaQuery.of(context).size.width * 0.80,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:  [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "STORE",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                       Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "" + storeName,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.25,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "STATUS",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            '' + paymentStatus,
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.35,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:  [
                                                        const Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "AMOUNT PAID",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            '\$ ' + paidAmount,
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              child: SizedBox(
                                                height: 60,
                                                width: MediaQuery.of(context).size.width * 0.10,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                          child: Text(
                                                            "",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w400),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 2, 0),
                                                          child: Text(
                                                            "",// + cartList[index]["ActualPrice"].toString(),
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600),
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              paymentStatus=='Pending'||paymentStatus=='pending'?Center(
                                child: Container(
                                  margin:
                                  const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigationMenu()));
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BillingScreen(total: paidAmount.toString(),orderid: OrderId,)));


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
                                          "Complete Payment",
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
                              ):const SizedBox(width: 0,height: 0,),




                        //       OrderImageList.length>0?CustomScrollView(
                        // scrollDirection: Axis.vertical,
                        // primary: false,
                        // shrinkWrap: true,
                        // slivers: <Widget>[ SliverPadding(
                        //           padding: const EdgeInsets.all(10),
                        //           sliver: SliverGrid(
                        //             gridDelegate:
                        //             const SliverGridDelegateWithFixedCrossAxisCount(
                        //               childAspectRatio: 0.75,
                        //               crossAxisSpacing: 20,
                        //               mainAxisSpacing: 20,
                        //               crossAxisCount: 2,
                        //             ),
                        //             delegate: SliverChildBuilderDelegate(
                        //                   (BuildContext context, int index) {
                        //                 return GestureDetector(
                        //                   onTap: () {
                        //                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagesScreen(cartOrderId: widget.cartOrderId.toString(),)));
                        //
                        //                   },
                        //                   child: Container(
                        //                     //  height: 200,
                        //                     width: 155,
                        //                     decoration: BoxDecoration(
                        //                       image: DecorationImage(
                        //                         image: NetworkImage(OrderImageList[index]['ImageUrl'].toString(),),
                        //                         fit: BoxFit.cover,
                        //                       ),
                        //                       borderRadius: BorderRadius.circular(10.0),
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //               childCount: OrderImageList.length,
                        //             ),
                        //           ),
                        //         ),
                        // ]):const SizedBox(width: 0,height: 0,),
                        //
                        //       OrderImageList.length>0?const SizedBox(
                        //         height: 15,
                        //       ):const SizedBox(width: 0,height: 0,),
                            ]
                        );
                      },
                    ),
                  ),

                ]),
          ),
        ],
      ),
    );
  }
}
