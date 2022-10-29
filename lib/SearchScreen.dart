import 'dart:convert';
import 'dart:ffi';

import 'package:adslay/CartScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'API.dart';
import 'ChoosePlan.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'StoreDetails.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final searchtext = TextEditingController();

  String searchKeyword = "";

  int coursescount=0;
  int universitycount=0;
  bool isLoading = true;
  bool isSearching = false;

  
  List <dynamic> searchResults = [];

  String email = '';
  String mobileNumber = '';

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

  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
                        const Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const CartScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                        ),


                      ],
                    ),
                  ],
                ),
                _searchBar(),
                searchResults.isEmpty
                    ?Expanded(
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                        child: Image.asset("assets/images/noresultsfound.png",width: 250,height: 250,),
                      )),
                    )
                    :Expanded(
                  child: _showStoresList(),
                ),

              ]),
        ),
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
          children: List.generate(searchResults.length, (index) {
            return InkWell(
              child: GestureDetector(
                onTap: (){
                  print("Selected store id is:"+searchResults[index]["StoreId"].toString());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetails(storeId: searchResults[index]["StoreId"].toString())));
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
                                          imageUrl: searchResults[index]["ImageUrl"],
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
                          '' + searchResults[index]["StoreName"] + ", " + searchResults[index]["City"],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          '' + searchResults[index]["State"] + ", " + searchResults[index]["Country"],
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 2,
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

  Widget _searchBar() {
    return Container(
      height: 70,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10.39, 15, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(

                onFieldSubmitted: (term) {
                  if(term.length>2){
                    setState(() {
                      searchKeyword = searchtext.text;
                    });
                    getSearchedStores();
                  }else{
                    setState(() {
                      isLoading = true;
                    });

                  }
                },
                onChanged: (term) {
                  if(term.length>2){
                    setState(() {
                      searchKeyword = searchtext.text;
                    });
                    getSearchedStores();
                  }else{
                    setState(() {
                      isLoading = true;
                    });

                  }
                },
                controller: searchtext,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Image.asset(
                        'assets/images/search.png',
                        width: 15,
                        height: 15,
                        fit: BoxFit.contain,
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 2,
                      minHeight: 2,
                    ),
                    suffixIcon:
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            searchtext.text = '';
                            isSearching = false;
                            getSearchedStores();
                          });
                        },
                        child: Image.asset(
                          'assets/images/close.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                       const BorderSide(color: Color(0xFFFFFFFF), width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: const Color(0xFFF2F2F2).withOpacity(1.0),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: BorderSide(
                        color: const Color(0xFFF2F2F2).withOpacity(1.0),
                        width: 1.0,
                      ),
                    ),
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: true,
                    contentPadding: const EdgeInsets.all(15),
                    hintStyle: TextStyle(
                        color: ConstantColors.appTheme,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Lorin"),
                    hintText: "Search for AD Spaces",
                    fillColor: const Color(0xFFFFFFFF).withOpacity(1.0)),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getSearchedStores() async {
    setState(() {
      isLoading = true;
      searchResults = [];
    });

    String url1 = APIConstant.autoSearchADSpaces;
    print(url1);
    Map<String, dynamic> body = {
      'Mobile': ''+mobileNumber,
      'Search': searchtext.text,
    };
    print('Search request body :' + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    print('Searched results body:' + response.body.toString());
    setState(() {
      isLoading = false;
      searchResults = jsonDecode(response.body)['StoresList'];
      print('Search result stores list: '+searchResults.toString());

    });

  }

}
