import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'API.dart';
import 'Constant/ConstantsColors.dart';
import 'ImagesScreen.dart';

class VideoCounselling extends StatefulWidget {

  var cartOrderId;

  VideoCounselling({this.cartOrderId});

  @override
  _VideoCounsellingState createState() => _VideoCounsellingState();
}

class _VideoCounsellingState extends State<VideoCounselling> {
  @override
  bool valuefirst = false;
  String valueChoose='';
  List tabBars = ['Images Uploaded By You', 'Images Uploaded By Vendor'];
  bool confirm = false;

  List listItem = [];
  int _currentIndex = 0;

  String Email = '';
  String MobileNo = '';
  String userid = '';
  String userLocation = '';
  String username = '';
  List<dynamic> OrderDetailsList = [];
  bool isLoading = true;
  
  bool valuefirst1 = false;
  String valueChoose1='';
  _onSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  List<dynamic> OrderImageList = [];
  List<dynamic> CustomerOrderImageList = [];

  Future<void> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     
    });

    String url121 = APIConstant.getCustomerOrderImagesListAPI+widget.cartOrderId.toString();
    print("Get order image list :" +url121);
    final response221 = await get(
      Uri.parse(url121),
    );
    print(''+response221.body);
    CustomerOrderImageList = jsonDecode(response221.body)['CustomerOrderImageList'];


    String url12 = APIConstant.getOrderImagesListApi+widget.cartOrderId.toString();
    print("Get order image list :" +url12);
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
    super.initState();
    getdata();
  }


  Widget build(BuildContext context) {
    return SafeArea(
      left: true,
      top: true,
      right: true,
      bottom: false,
      child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
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
                                  padding: const EdgeInsets.only(top: 0, right: 30,left: 10),
                                  child: Image.asset("assets/images/home-logo.png",width: 130,)
                              ),

                            ],
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: Text(
                          //     "Photos",
                          //     style: TextStyle(
                          //         fontSize: 20,
                          //         fontFamily: "Mont-SemiBold"
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                          //   child: SizedBox(width: 100,child: Divider(height: 1,thickness: 1,color: ConstantColors.appTheme,),),
                          // ),
                        ],
                      ),
                    ],
                  ),


                  isLoading
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.grey,
                    enabled: true,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 23.0, 24, 0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(
                                    color: const Color(0xFFF2F2F2), width: 1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 64.0,
                                      width: 56.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8, 14, 0, 12),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(1.0),
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.6,
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 32, 11.5, 0),
                                    child: SvgPicture.asset(
                                      'assets/icons/right.svg',
                                      height: 16,
                                      width: 16,
                                      color:
                                      const Color(0xFF141E28).withOpacity(0.45),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(
                                    color: const Color(0xFFF2F2F2), width: 1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 64.0,
                                      width: 56.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8, 14, 0, 12),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(1.0),
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.6,
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 32, 11.5, 0),
                                    child: SvgPicture.asset(
                                      'assets/icons/right.svg',
                                      height: 16,
                                      width: 16,
                                      color:
                                      const Color(0xFF141E28).withOpacity(0.45),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(
                                    color: const Color(0xFFF2F2F2), width: 1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 64.0,
                                      width: 56.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8, 14, 0, 12),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(1.0),
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.6,
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 32, 11.5, 0),
                                    child: SvgPicture.asset(
                                      'assets/icons/right.svg',
                                      height: 16,
                                      width: 16,
                                      color:
                                      const Color(0xFF141E28).withOpacity(0.45),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(
                                    color: const Color(0xFFF2F2F2), width: 1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 64.0,
                                      width: 56.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8, 14, 0, 12),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(1.0),
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5.6,
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        new Text(
                                          '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: const Color(0xFF141E28)
                                                .withOpacity(0.45),
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontFamily: "Lorin",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 32, 11.5, 0),
                                    child: SvgPicture.asset(
                                      'assets/icons/right.svg',
                                      height: 16,
                                      width: 16,
                                      color:
                                      const Color(0xFF141E28).withOpacity(0.45),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 15, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: tabBars.map((e) {
                              var index = tabBars.indexOf(e);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _onSelected(index);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 0),
                                  child: Container(
                                    width: 155,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(9),
                                      color: _currentIndex == index
                                          ? const Color(0xFF0063AD)
                                          : const Color(0xFFF2F2F2),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            e.toString(),
                                            style: TextStyle(
                                                fontFamily: 'Lorin',
                                                color: _currentIndex ==
                                                    index
                                                    ? const Color(0xFFFFFFFF)
                                                    : const Color(0xFFAAAAAA),
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          ),
  ]
                        ),
                        _currentIndex == 0
                            ? _toComeIn()
                            : _currentIndex == 1
                            ? _schedule()
                            : _toComeIn(),
                        // _currentIndex == 0
                        //     ? isLoading
                        //     ? Shimmer.fromColors(
                        //   baseColor: Colors.grey,
                        //   highlightColor: Colors.grey,
                        //   enabled: true,
                        //   child: Container(
                        //     height: 110,
                        //     width: double.infinity,
                        //     child: ListView.builder(
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount: 5,
                        //       itemBuilder: (context, index) {
                        //         return Padding(
                        //           padding: const EdgeInsets.fromLTRB(
                        //               24.0, 0, 0, 0),
                        //           child: GestureDetector(
                        //             onTap: () {},
                        //             child: Container(
                        //               //  height: 200,
                        //               width: 155,
                        //               decoration: BoxDecoration(
                        //                 borderRadius:
                        //                 BorderRadius.circular(
                        //                     20.0),
                        //               ),
                        //               child: Container(
                        //                 //    height: 200,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                   BorderRadius.circular(
                        //                       20.0),
                        //                   gradient: LinearGradient(
                        //                       begin: FractionalOffset
                        //                           .topCenter,
                        //                       end: FractionalOffset
                        //                           .bottomCenter,
                        //                       colors: [
                        //                         Color(0xFFC4C4C4)
                        //                             .withOpacity(0.0),
                        //                         Color(0xFF0063AD)
                        //                             .withOpacity(0.9),
                        //                       ],
                        //                       stops: [
                        //                         0.0,
                        //                         0.9,
                        //                       ]),
                        //                 ),
                        //                 child: Container(
                        //                   //  height: 200.0,
                        //                   child: Padding(
                        //                     padding: const EdgeInsets
                        //                         .fromLTRB(
                        //                         9.0, 0.0, 0, 0),
                        //                     child: Column(
                        //                       mainAxisAlignment:
                        //                       MainAxisAlignment
                        //                           .end,
                        //                       crossAxisAlignment:
                        //                       CrossAxisAlignment
                        //                           .start,
                        //                       children: [
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .all(1.0),
                        //                           child: SvgPicture
                        //                               .asset(
                        //                             'assets/icons/right.svg',
                        //                             height: 18,
                        //                             width: 18,
                        //                             color: Color(
                        //                                 0xFFFFFFFF),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 3,
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .fromLTRB(
                        //                               1.0,
                        //                               5,
                        //                               0,
                        //                               0),
                        //                           child: Text(
                        //                             '',
                        //                             style: TextStyle(
                        //                                 fontFamily:
                        //                                 'Lorin',
                        //                                 fontStyle:
                        //                                 FontStyle
                        //                                     .normal,
                        //                                 color: Color(
                        //                                     0xFFFFFFFF),
                        //                                 fontSize: 12,
                        //                                 fontWeight:
                        //                                 FontWeight
                        //                                     .w800),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .all(1.0),
                        //                           child: Text(
                        //                             '',
                        //                             style: TextStyle(
                        //                                 fontFamily:
                        //                                 'Lorin',
                        //                                 fontStyle:
                        //                                 FontStyle
                        //                                     .normal,
                        //                                 color: Color(
                        //                                     0xFFFFFFFF),
                        //                                 fontSize: 12,
                        //                                 fontWeight:
                        //                                 FontWeight
                        //                                     .w800),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 3,
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .all(1.0),
                        //                           child: Text(
                        //                             '',
                        //                             style: TextStyle(
                        //                                 fontFamily:
                        //                                 'Lorin',
                        //                                 fontStyle:
                        //                                 FontStyle
                        //                                     .normal,
                        //                                 color: Color(
                        //                                     0xFFFFFFFF),
                        //                                 fontSize: 10,
                        //                                 fontWeight:
                        //                                 FontWeight
                        //                                     .w400),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 12,
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // )
                        //     : topRatedCounsllorsList.length == 0
                        //     ? SizedBox(width: 0, height: 0)
                        //     : Padding(
                        //   padding: const EdgeInsets.fromLTRB(
                        //       24, 25, 0, 23),
                        //   child: Text(
                        //     'Top Rated Counsellors',
                        //     style: TextStyle(
                        //         fontFamily: 'Lorin',
                        //         color: Color(0xFF141E28)
                        //             .withOpacity(1.0),
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w800),
                        //   ),
                        // )
                        //     : Container(),
                        //
                        // _currentIndex == 1
                        //     ? isLoading
                        //     ? Shimmer.fromColors(
                        //   baseColor: Colors.grey[300],
                        //   highlightColor: Colors.grey[100],
                        //   enabled: true,
                        //   child: Container(
                        //     height: 110,
                        //     width: double.infinity,
                        //     child: ListView.builder(
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount: 5,
                        //       itemBuilder: (context, index) {
                        //         return Padding(
                        //           padding: const EdgeInsets.fromLTRB(
                        //               24.0, 0, 0, 0),
                        //           child: GestureDetector(
                        //             onTap: () {},
                        //             child: Container(
                        //               //  height: 200,
                        //               width: 155,
                        //               decoration: BoxDecoration(
                        //                 borderRadius:
                        //                 BorderRadius.circular(
                        //                     20.0),
                        //               ),
                        //               child: Container(
                        //                 //    height: 200,
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                   BorderRadius.circular(
                        //                       20.0),
                        //                   gradient: LinearGradient(
                        //                       begin: FractionalOffset
                        //                           .topCenter,
                        //                       end: FractionalOffset
                        //                           .bottomCenter,
                        //                       colors: [
                        //                         Color(0xFFC4C4C4)
                        //                             .withOpacity(0.0),
                        //                         Color(0xFF0063AD)
                        //                             .withOpacity(0.9),
                        //                       ],
                        //                       stops: [
                        //                         0.0,
                        //                         0.9,
                        //                       ]),
                        //                 ),
                        //                 child: Container(
                        //                   //  height: 200.0,
                        //                   child: Padding(
                        //                     padding: const EdgeInsets
                        //                         .fromLTRB(
                        //                         9.0, 0.0, 0, 0),
                        //                     child: Column(
                        //                       mainAxisAlignment:
                        //                       MainAxisAlignment
                        //                           .end,
                        //                       crossAxisAlignment:
                        //                       CrossAxisAlignment
                        //                           .start,
                        //                       children: [
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .all(1.0),
                        //                           child: SvgPicture
                        //                               .asset(
                        //                             'assets/icons/right.svg',
                        //                             height: 18,
                        //                             width: 18,
                        //                             color: Color(
                        //                                 0xFFFFFFFF),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 3,
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .fromLTRB(
                        //                               1.0,
                        //                               5,
                        //                               0,
                        //                               0),
                        //                           child: Text(
                        //                             '',
                        //                             style: TextStyle(
                        //                                 fontFamily:
                        //                                 'Lorin',
                        //                                 fontStyle:
                        //                                 FontStyle
                        //                                     .normal,
                        //                                 color: Color(
                        //                                     0xFFFFFFFF),
                        //                                 fontSize: 12,
                        //                                 fontWeight:
                        //                                 FontWeight
                        //                                     .w800),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .all(1.0),
                        //                           child: Text(
                        //                             '',
                        //                             style: TextStyle(
                        //                                 fontFamily:
                        //                                 'Lorin',
                        //                                 fontStyle:
                        //                                 FontStyle
                        //                                     .normal,
                        //                                 color: Color(
                        //                                     0xFFFFFFFF),
                        //                                 fontSize: 12,
                        //                                 fontWeight:
                        //                                 FontWeight
                        //                                     .w800),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 3,
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                           const EdgeInsets
                        //                               .all(1.0),
                        //                           child: Text(
                        //                             '',
                        //                             style: TextStyle(
                        //                                 fontFamily:
                        //                                 'Lorin',
                        //                                 fontStyle:
                        //                                 FontStyle
                        //                                     .normal,
                        //                                 color: Color(
                        //                                     0xFFFFFFFF),
                        //                                 fontSize: 10,
                        //                                 fontWeight:
                        //                                 FontWeight
                        //                                     .w400),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 12,
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // )
                        //     : topRatedCounsllorsList.length == 0
                        //     ? SizedBox(width: 0, height: 0)
                        //     : Padding(
                        //   padding: const EdgeInsets.fromLTRB(
                        //       24, 25, 0, 23),
                        //   child: Text(
                        //     'Top Rated Counsellors',
                        //     style: TextStyle(
                        //         fontFamily: 'Lorin',
                        //         color: Color(0xFF141E28)
                        //             .withOpacity(1.0),
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w800),
                        //   ),
                        // )
                        //     : Container(),

                        const SizedBox(height: 30,)
                      ]),
              )
      ),
    );
  }

  Widget _toComeIn() {
    return isLoading?SizedBox(height: 0,width: 0,):CustomerOrderImageList.length==0?Container(
      alignment: Alignment.center, //Set container alignment  then wrap the column with singleChildScrollView
      height: MediaQuery.of(context).size.height * 0.70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          Image.asset(
            'assets/images/noimage.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(
            height: 5,
          ),

          const SizedBox(
            height: 5,
          ),
          const Text(
            'NO IMAGES FOUND \n',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Mont-Light",
                fontSize: 19,
                color: Colors.black
            ),
          ),

        ],
      ),
    ):CustomScrollView(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        slivers: <Widget>[ SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.75,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagesScreen(cartOrderId: widget.cartOrderId.toString(),type:'user')));

                  },
                  child: Container(
                    //  height: 200,
                    width: 155,
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //   image: NetworkImage(CustomerOrderImageList[index]['ImageUrl'].toString(),),
                      //   fit: BoxFit.cover,
                      // ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: CustomerOrderImageList[index]['ImageUrl'].toString(),
                      placeholder: (context, url) => Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
                  ),
                );
              },
              childCount: CustomerOrderImageList.length,
            ),
          ),
        ),
        ]);
  }

  Widget _schedule() {
    return isLoading?SizedBox(height: 0,width: 0,):OrderImageList.length==0?Container(
      alignment: Alignment.center, //Set container alignment  then wrap the column with singleChildScrollView
      height: MediaQuery.of(context).size.height * 0.70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          Image.asset(
            'assets/images/noimage.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(
            height: 5,
          ),

          const SizedBox(
            height: 5,
          ),
          const Text(
            'NO IMAGES FOUND \n',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Mont-Light",
                fontSize: 19,
                color: Colors.black
            ),
          ),

        ],
      ),
    ):CustomScrollView(
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        slivers: <Widget>[ SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.75,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagesScreen(cartOrderId: widget.cartOrderId.toString(),type:'vendor')));

                  },
                  child: Container(
                    //  height: 200,
                    width: 155,
                    decoration: BoxDecoration(
                      // image: DecorationImage(
                      //   image: NetworkImage(OrderImageList[index]['ImageUrl'].toString(),),
                      //   fit: BoxFit.cover,
                      // ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: OrderImageList[index]['ImageUrl'].toString(),
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
                  ),
                );
              },
              childCount: OrderImageList.length,
            ),
          ),
        ),
        ]);
  }

}
