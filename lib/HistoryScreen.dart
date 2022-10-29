import 'dart:convert';

import 'package:adslay/CartScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'API.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'OrderDetailsScreen.dart';
import 'SearchScreen.dart';

class HistoryScreen extends StatefulWidget {

  @override
  _HistoryScreen createState() => _HistoryScreen();

}

class _HistoryScreen extends State<HistoryScreen> {

  bool isLoading = true;
  bool isCheckoutAvailable = false;
  List<dynamic> ordersHistoryList = [];

  String email = '';
  String mobileNumber = '';
  double subTotalValue = 0.0;

  late ProgressDialog pr;

  Future<void> getdata() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mobileNumber = prefs.getString('mobilenumber')!;
        email = prefs.getString('email')!;
      });
    }catch(e){
      print(e);
    }
    String url1 = APIConstant.getCartHistoryItems;
    print("Get orders history items url is: "+url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
    };
    print('Get orders history items api body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    //print('Get orders history items response :' + response.body.toString());
    setState(() {
      ordersHistoryList = jsonDecode(response.body)['OrdersList'];
    });

    if (ordersHistoryList.isEmpty) {
      print("No orders history found.");
      isCheckoutAvailable = false;
    }
    else{
      for (var item in ordersHistoryList) {
        double actualPrice = item["ActualPrice"];
        subTotalValue += actualPrice;
        //print("Cart items actual prices are: "+actualPrice.toString());
      }
      isCheckoutAvailable = true;
      print("Cart items total price: "+subTotalValue.toString());
    }
    print('orderhistory:  '+ordersHistoryList.toString());
    setState(() {
      isLoading=false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
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
      body: Stack(
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
                      Stack(
                        children: <Widget>[
                          Row(
                            children: [

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
                        ],
                      ),

                      // ordersHistoryList.isEmpty
                      //     ?isLoading
                      //     ?const SizedBox(height: 10,)
                      //     :Expanded(
                      //   child: Center(
                      //       child: Column(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      //             child: Image.asset("assets/images/noordersfound.png",width: 250,height: 250,),
                      //           ),
                      //         ],
                      //       )),
                      // )
                      //     :_ordersHistoryItems(),
                      //

                      isLoading
                          ?Shimmer.fromColors(
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
                                children: List.generate(2, (index) {
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
                      )
                          :ordersHistoryList.isEmpty?Expanded(
                        child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 40),
                                  child: Image.asset("assets/images/noordersfound.png",width: 250,height: 250,),
                                ),
                              ],
                            )),
                      ): _ordersHistoryItems(),
                    ]),
              ],
            ),
          ),
          
        ],
      ),
    );

  }


  Widget _ordersHistoryItems() {
    return isLoading
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
                            const SizedBox(height: 10,width: 10,),
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
    )
        : Expanded(
          child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: ordersHistoryList.length,
      itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetailsScreen(cartOrderId: ordersHistoryList[index]["OrderDetailId"],)));
            },
            child: Column(
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
                            Card(
                              elevation: 1,
                              child: Image.network(
                                ordersHistoryList[index]["ImageUrl"],
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(8.0),
                            //   child: Image.asset(
                            //     "assets/images/desibg.png",
                            //     height: 160,
                            //     width: MediaQuery.of(context).size.width,
                            //     fit: BoxFit.fitWidth,
                            //   ),
                            // )
                          ],
                        ),

                        // Positioned(
                        //     top: 10,
                        //     right: 8,
                        //     child: Image.asset(
                        //       "assets/images/delete.png",
                        //       fit: BoxFit.fill,
                        //       height: 45,
                        //       width: 45,
                        //     ))

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 5, 8),
                    child: Text(
                      "" + ordersHistoryList[index]["StoreName"] +", "+ ordersHistoryList[index]["City"] +", "+ ordersHistoryList[index]["State"],
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Mont-SemiBold'
                      ),
                    ),
                  ),
                  Row(
                    children:  [
                       Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 8),
                         child: Image.asset(
                           (ordersHistoryList[index]["PaymentStatus"] == "Completed")?"assets/images/completed.png":"assets/images/pending.png",
                           height: 30,
                         ),
                      ),
                      const Spacer(),
                      (ordersHistoryList[index]["IsFileUpload"] == "Yes") ?const Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 8),
                        child: Text(
                          "UPLOAD AD!",
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontFamily: 'Mont-Regular',
                          ),
                        ),
                      ):const SizedBox(width: 0,height: 0,),
                      (ordersHistoryList[index]["IsFileUpload"] == "Yes") ?Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Image.asset(
                          "assets/images/link.png",
                          fit: BoxFit.fill,
                          height: 20,
                          width: 20,
                        ),
                      ):const SizedBox(width: 0,height: 0,),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Card(
                        elevation: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: SizedBox(
                                height: 75,
                                //width: MediaQuery.of(context).size.width * 0.23,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:  [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            "AD TYPE",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Mont-Regular',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            "" + ordersHistoryList[index]["ScreenSize"].toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Mont-SemiBold',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: SizedBox(
                                height: 75,
                                //width: MediaQuery.of(context).size.width * 0.23,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:  [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            "NO OF TIMES",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Mont-Regular',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            "" + ordersHistoryList[index]["NoofTimes"].toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Mont-SemiBold',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: SizedBox(
                                height: 75,
                                //width: MediaQuery.of(context).size.width * 0.19,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:  [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            "TOTAL",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Mont-Regular',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text(
                                            // "\$21.00",
                                            "\$" + ordersHistoryList[index]["ActualPrice"].toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Mont-SemiBold',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 8, 0),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      24), // if you need this
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      color: Colors.transparent,
                                      width: 48,
                                      height: 48,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5,8,5,0),
                                      child: Image.asset(
                                        "assets/images/blueRightArrow.png",
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          );
      },
    ),
        );
  }


}
