import 'dart:convert';

import 'package:adslay/Constant/ConstantsColors.dart';
import 'package:adslay/SearchScreen.dart';
import 'package:adslay/StoreDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'API.dart';
import 'CartScreen.dart';
import 'ChoosePlan.dart';
import 'MainScreen.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {

  late List<dynamic> storesList;
  bool isLoading = true;

  String Email='';
  String MobileNo='';
  String deviceOS='';
  double screenWidth=0.0;

  String mobileNumber='';
  String email='';


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

    String url1 = APIConstant.categoryBaseStoresList;
    print('Category base StoresList url: '+url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
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
    //print('Category base StoresList response in stores tab :' + response.body.toString());
    setState(() {
      storesList = jsonDecode(response.body)['StoresList'];
    });

    setState(() {
      isLoading = false;
    });

  }

  @override
  void initState() {
    super.initState();

    getdata();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              Expanded(
                child: _showStoresList(),
              ),
            ]),
      ),
    );
  }
  Widget _showStoresList() {
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
              crossAxisCount: 2,
              childAspectRatio: 0.90,
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
    )
        : ListView(
      shrinkWrap: true, // use it
      physics: const BouncingScrollPhysics(),
      children: [
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(storesList.length, (index) {
            return InkWell(
              child: GestureDetector(
                onTap: (){
                  print("Selected store id is:"+storesList[index]["StoreId"].toString());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetails(storeId: storesList[index]["StoreId"].toString())));
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> ChoosePlan(storeId: storesList[index]["StoreId"].toString())));
                },
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
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: CachedNetworkImage(
                                          imageUrl: storesList[index]["ImageUrl"],
                                          placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                  ),
                                ],
                              )),
                        ),
                        Text(
                          '' + storesList[index]["StoreName"] + ", " + storesList[index]["City"],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '' + storesList[index]["State"] + ", " + storesList[index]["Country"],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal),
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
    );
  }
}
