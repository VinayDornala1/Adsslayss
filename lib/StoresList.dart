import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'StoreDetails.dart';
class StoresList extends StatefulWidget {
  var categoryId;
  var storeCategory;
  StoresList({this.categoryId,this.storeCategory});
  @override
  _StoresList createState() => _StoresList();
}
class _StoresList extends State<StoresList> {
  String Email='';
  String MobileNo='';
  bool isLoading = true;
  bool isLoading1 = true;
  String deviceOS='';
  double screenWidth=0.0;
  List<dynamic> storesList=[];
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
      'CategoryId': widget.categoryId.toString(),
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
    print('Category base StoresList response :' + response.body.toString());
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
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                child: Text(
                  ''+widget.storeCategory,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              _showStoresList()

            ]),
      ),
    );
  }


  Widget _showStoresList() {
    return isLoading
        ? Expanded(
          child: Shimmer.fromColors(
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
    ),
        )
        : Expanded(
      child: ListView(
        shrinkWrap: true, // use it
        physics: const BouncingScrollPhysics(),
        children: [
          storesList.isEmpty
              ?Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Image.asset("assets/images/noresultsfound.png",width: 250,height: 250,),
                  ))
              :GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.85, //MediaQuery.of(context).size.height / 900,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(
              storesList.length,
                  (index)
              {
                return InkWell(
                  child: GestureDetector(
                    onTap: (){
                      print("Selected store id is:"+storesList[index]["StoreId"].toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetails(storeId: storesList[index]["StoreId"].toString()))).then((value) => {
                        setState(() {
                          isLoading1 = true;
                        }),
                      });
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
                                  elevation: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.width * 0.40,
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            child: CachedNetworkImage(
                                              imageUrl: storesList[index]["ImageUrl"] ,//"https://image.tmdb.org/t/p/w300_and_h450_bestv2//iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg",
                                              placeholder: (context, url) => const Center(
                                                  child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                              fit: BoxFit.contain,
                                              width: double.infinity,
                                              height: 150,
                                            ),
                                          )
                                      ),
                                    ],
                                  )
                              ),
                            ),
                            Text(
                              storesList[index]["StoreName"],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                storesList[index]["City"] + ", " + storesList[index]["State"] + ", " + storesList[index]["Country"],
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal),
                              ),
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
      ));

  }


}
