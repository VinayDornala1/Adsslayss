import 'dart:convert';
import 'package:adslay/Constant/ConstantsColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'API.dart';
import 'BillingScreen.dart';
import 'CartScreen.dart';
import 'MainScreen.dart';
class ImagesScreen extends StatefulWidget {

  var cartOrderId;
  var type;

  ImagesScreen({this.cartOrderId,this.type});

  @override
  State<ImagesScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<ImagesScreen> {

  String email = '';
  String mobileNumber = '';
  bool isLoading = true;
  String deviceOS = '';


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



    if(widget.type=='user') {
      String url12 = APIConstant.getCustomerOrderImagesListAPI +
          widget.cartOrderId.toString();
      print("Get order image list :" + url12);
      final response22 = await get(
        Uri.parse(url12),
      );
      print('' + response22.body);
      OrderImageList = jsonDecode(response22.body)['CustomerOrderImageList'];
    }else {
      String url12 = APIConstant.getOrderImagesListApi +
          widget.cartOrderId.toString();
      print("Get order image list :" + url12);
      final response22 = await get(
        Uri.parse(url12),
      );
      print('' + response22.body);
      OrderImageList = jsonDecode(response22.body)['OrderImageList'];
    }
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



  int _current = 0;


  @override
  Widget build(BuildContext context) {
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
                      "ADSPACE PHOTOS",
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
                    Container(
                      child:  SizedBox(
                        //X:1125,Pro: 1170,Pro Max: 1284
                          height: double.infinity,
                          width: double.infinity,
                          child: isLoading
                              ?Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey,
                            enabled: true,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  //  height: 180,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          )
                              :CarouselSlider(
                            items: [
                              for(int i=0;i<OrderImageList.length;i++)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {

                                    },
                                    child: FittedBox(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   image: NetworkImage(OrderImageList[i]['ImageUrl'].toString(),),
                                          //   fit: BoxFit.fill,
                                          // ),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: OrderImageList[i]['ImageUrl'].toString(),
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) => Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
                                          errorWidget: (context, url, error) => new Icon(Icons.error),
                                        ),
                                        //  height: 180,

                                        
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                height: MediaQuery.of(context).size.height / 0.8,
                                viewportFraction: 1.0,
                                initialPage: 0,
                                aspectRatio: 5.0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration: Duration(milliseconds: 800),
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                          )
                      ),
                    ),
                  ),

                ]),
          ),
        ],
      ),
    );
  }
}
