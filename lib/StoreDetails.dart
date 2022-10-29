import 'dart:convert';
import 'package:adslay/CartScreen.dart';
import 'package:adslay/ChoosePlan.dart';
import 'package:adslay/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'API.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'UploadFiles.dart';


class StoreDetails extends StatefulWidget {

  var storeId;

  StoreDetails({
    this.storeId,
  });

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {

  String email = '';
  String mobileNumber = '';
  bool isLoading = true;
  bool isLoading1 = true;
  String deviceOS = '';
  double screenWidth = 0.0;

  int storeId = 0;
  String city = '';
  String title = '';
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

  Future<void> getData() async {

    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mobileNumber = prefs.getString('mobilenumber')!;
        email = prefs.getString('email')!;
      });
    }catch(e){
      print(e);
    }

    String url1 = APIConstant.getStoreDetails;
    print('Selected store details url: '+url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
      'StoreId': widget.storeId.toString(),
    };
    print('Selected store details body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    print('Selected store details response :' + response.body.toString());
    setState(() {
      String msg = jsonDecode(response.body)['msg'];

      if (msg == "Success" || msg == "success")
      {
        title = jsonDecode(response.body)['Title'];
        city = jsonDecode(response.body)['City'];
        state = jsonDecode(response.body)['State'];
        country = jsonDecode(response.body)['Country'];
        zipCode = jsonDecode(response.body)['ZipCode'];
        imageUrl = jsonDecode(response.body)['ImageUrl'];
        screenSize = jsonDecode(response.body)['ScreenSize'].toString();
        actualPrice = jsonDecode(response.body)['ActualPrice'];
        footTraffic = jsonDecode(response.body)['FootTraffic'];
        type = jsonDecode(response.body)['Type'];
        fileFormat = jsonDecode(response.body)['FileFormat'];

      }else{
        print("Unable to get API response.");
      }


    });

    setState(() {
      isLoading = false;
    });


  }


  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                    isLoading1
                        ? Row(
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
                    )
                        : Row(
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
                  padding: const EdgeInsets.all(10.0),
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
                          //     image: NetworkImage(imageUrl),
                          //   ),
                          // ),

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
                                        fit: BoxFit.fill,
                                        height: 220,
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
                          //       imageUrl: "https://image.tmdb.org/t/p/w300_and_h450_bestv2//iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg",
                          //       placeholder: (context, url) => const Center(
                          //           child: CircularProgressIndicator()),
                          //       errorWidget: (context, url, error) =>
                          //       const Icon(Icons.error),
                          //       fit: BoxFit.cover,
                          //       width: double.infinity,
                          //       // height: 150,
                          //     )
                          // ),s
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
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                  child: Text(
                    " "+title+','+city+','+state+','+country,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
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
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Card(
                        elevation: 2,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              //height: MediaQuery.of(context).size.width * 0.40,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 5, 8),
                                child: Text(
                                  "ADDITIONAL INFO",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                              width: 150,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0
                                    , 5, 8),
                                child: Divider(height: 1,color: Color(0xff3962cb),thickness: 1,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 8, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  SizedBox(
                                    width: 100,
                                    child: const Text(
                                      "Type",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Color(0xff3962cb),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ":",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xff3962cb),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 10, 8),
                                      child: Text(
                                        ""+type,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 8, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: const Text(
                                      "Ad Screen",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Color(0xff3962cb),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ":",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xff3962cb),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 10, 8),
                                      child: Text(
                                        ""+screenSize,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 8, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: const Text(
                                      "File Format",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Color(0xff3962cb),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ":",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xff3962cb),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 10, 8),
                                      child: Text(
                                        ""+fileFormat,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 8, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,

                                    child: Text(
                                      "Foot Traffic",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Color(0xff3962cb),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xff3962cb),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 10, 8),
                                      child: Text(
                                        ""+footTraffic,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 8, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: const Text(
                                      "Cost",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Color(0xff3962cb),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ":",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Color(0xff3962cb),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 10, 8),
                                      child: Text(
                                        "\$"+actualPrice.toString(),
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
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
                ):Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ChoosePlan(storeId: widget.storeId))).then((value) => {
                        setState(() {
                        isLoading1 = true;
                        }),

                        });
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: 180,
                        height: 45,
                        decoration:  BoxDecoration(
                            gradient:  LinearGradient(
                              colors: [
                                ConstantColors.appTheme,
                                ConstantColors.appTheme,
                              ],
                            )
                        ),
                        //padding: const EdgeInsets.all(10.0),
                        child: const Center(
                          child: Text(
                            "BOOK NOW",
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
                ),
                const SizedBox(height: 10,),
                const SizedBox(height: 40,),
              ]),
        ),
      ),
    );
  }
}
