import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'API.dart';
import 'CartScreen.dart';
import 'ChoosePlan.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'SearchScreen.dart';
import 'StoresList.dart';


class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {



  late List<dynamic> categoriesList;
  bool isLoading = true;
  bool isLoading1 = true;

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

    String url1 = APIConstant.getAllCategoriesList;
    print('Get all categories url: '+url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
    };
    print('Get all categories body:' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    //print('Get all categories List response in stores tab :' + response.body.toString());
    setState(() {
      categoriesList = jsonDecode(response.body)['CategoriesList'];
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

              const Padding(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                child: Text(
                  'All Categories',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: _allAdSpaceCategories(),
              ),

            ]),
      ),
    );
  }


  Widget _allAdSpaceCategories(){
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
              children: List.generate(6, (index) {
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
        : GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: categoriesList.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.20,
      ),
      itemBuilder: (context, index) {
        return Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  String categoryName = categoriesList[index]["CategoryName"].toString();
                  if (categoryName == "All" || categoryName == "all") {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>StoresList(categoryId: categoriesList[index]["CategoryId"].toString(),storeCategory: categoriesList[index]["CategoryName"])));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>StoresList(categoryId: categoriesList[index]["CategoryId"].toString(),storeCategory: categoriesList[index]["CategoryName"]))).then((value) => {
                      setState(() {
                        isLoading1 = true;
                      }),
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Card(
                                    elevation: 2,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 140,
                                          width: 170,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Image(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(categoriesList[index]['ImageUrl'],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 140,
                                          width: 170,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Image.asset(
                                              "assets/images/black-transparent.png",
                                              fit: BoxFit.fill,

                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0,right:35,bottom: 8),
                                            child: Text(
                                              ''+categoriesList[index]['CategoryName'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: "Mont-Regular",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0,bottom: 8),
                                            child: Image.asset(
                                              "assets/images/right-arrow.png",
                                              height: 22,
                                              width: 22,),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
