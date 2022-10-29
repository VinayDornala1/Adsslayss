import 'dart:convert';
import 'package:adslay/CartScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:images_picker/images_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'API.dart';
import 'BoolProvider.dart';
import 'Constant/ConstantsColors.dart';
import 'MainScreen.dart';
import 'OrderDetailsScreen.dart';
import 'SearchScreen.dart';
import 'ThankYouScreen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  List tabBars = ['Personal Details', 'Order Details'];
  int _currentIndex = 0;
  bool isLoading = true;
  bool isLoading1 = true;
  bool isEditProfile = true;
  bool isCheckoutAvailable = false;
  List<dynamic> ordersHistoryList = [];
  List<dynamic> userDetails = [];
  List<dynamic> countriesList = [];
  List<dynamic> statesLists = [];
  String email = '';
  String profilePicUrl = '';
  String fullName = '';
  String customerId = '';
  String mobileNumber = '';
  double subTotalValue = 0.0;
  late ProgressDialog pr;
  TextEditingController userNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController profileImage = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countryControllerId = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  Future<void> getData() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mobileNumber = prefs.getString('mobilenumber')!;
        email = prefs.getString('email')!;
        customerId = prefs.getString('CustomerId')!;
      });
    }catch(e){
      print(e);
    }
    _getUserProfileDetails();
    String url ="http://app.adslay.com/API/HomeAPI/CountriesList" ;
    print(url);
    var response1 =
    await get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      print(''+response1.body.toString());
      countriesList = jsonDecode(response1.body)['CountriesList'];
    });
    setState(() {
      isLoading=false;
    });
  }
  Future<void> _getOrdersHistory() async {
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
    }
    else{
      for (var item in ordersHistoryList) {
        double actualPrice = item["ActualPrice"];
        subTotalValue += actualPrice;
        //print("Cart items actual prices are: "+actualPrice.toString());
      }
      print("Cart items total price: "+subTotalValue.toString());
    }

    setState(() {
      isLoading1=false;
    });
  }

  Future<void> _getUserProfileDetails() async {

    String url1 = APIConstant.login;
    print(url1);
    Map<String, dynamic> body = {
      'MobileNo': ''+mobileNumber,
    };
    print("Profile get details api calling :" + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );

    Map data = jsonDecode(response.body);
    //print(data);
    String msg = data['msg'];
    print(msg);

    if (msg=='No Records Found') {
      print("No records found...");
    } else {
      setState(() {
        stateController.text='Select State';
        fullName = data['objCustomers']['FirstName'] + " " + data['objCustomers']['LastName'];
        userNameController.text = data['objCustomers']['FirstName'];
        lastNameController.text = data['objCustomers']['LastName'];
        emailController.text = data['objCustomers']['Email'];
        mobileNumberController.text = data['objCustomers']['MobileNo'];
        profileImage.text = data['objCustomers']['ProfileImage'];
        addressController.text = data['objCustomers']['Address1'];
        cityController.text = data['objCustomers']['City'];
        stateController.text = data['objCustomers']['State'];
        countryController.text = data['objCustomers']['Country'];
        zipcodeController.text = data['objCustomers']['ZipCode'];
        customerIdController.text = data['objCustomers']['CustomerId'].toString();
        profilePicUrl = data['objCustomers']['ProfileImage'];
        print("Profile pic url is:"+profilePicUrl);
      });
    }
    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  String profilePic='';
  final String uploadUrl = APIConstant.postProfilePicToServer;
  TextEditingController vendor_image = TextEditingController();
  List<Media>? res111;

  _chooseProfilePic() async {
    // var picked = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg','png'],
    // );

    res111 = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      quality: 0.8,
    );
    if (res111 != null) {
      setState(() {
        profilePic = res111![0].path.toString();
      });
      print('file path: '+res111![0].path.toString());
      await pr.show();
      var res = await uploadImage( res111![0].path.toString(), uploadUrl);
      print("Profile pic uploading to server response: "+ res.toString());
      Map data1 = jsonDecode(res);
      // String fileName = picked.files.first.path!.split('/').last;
      print('Uploaded file name: '+data1.toString());

      vendor_image.text = data1['fileName'].toString();
      String url1 = APIConstant.postProfilePicDetailsToServer;
      print('Upload profile pic details to server url: '+url1);
      Map<String, dynamic> body = {
        'MobileNo': ''+mobileNumber,
        'ProfileImage': vendor_image.text.toString(),
      };
      print('Upload profile pic details to server body:' + body.toString());
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final encoding = Encoding.getByName('utf-8');
      final response = await post(
        Uri.parse(url1),
        headers: headers,
        body: body,
        encoding: encoding,
      );
      print('Upload profile pic details to server data :' + response.body.toString());
      await pr.hide();
      setState(() {
        isLoading = true;
        _getUserProfileDetails();
      });
    }
  }

  Future<String> uploadImage(filepath, url) async {
    var request = MultipartRequest('POST', Uri.parse(url));
    request.files.add(await MultipartFile.fromPath('file', filepath));
    var res = await request.send();
    var responseString = await res.stream.bytesToString();
    print('Upload image to server data response: '+responseString);
    return responseString;
  }
  _onSelected(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1){
        setState(() {
          isEditProfile = false;
          isLoading1 = true;
        });
        // _getOrdersHistory();
        _boolProvider.setBottomChange(2);

      }else if (index == 0){
        _getUserProfileDetails();
      }
    });
  }
  BoolProvider _boolProvider = BoolProvider();
  @override
  Widget build(BuildContext context) {
    _boolProvider  =  Provider.of<BoolProvider>(context,);
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
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          left: false,
          top: true,
          right: false,
          bottom: false,
          child: isLoading
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
              :Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 10),
                    //     child: Image.asset(
                    //       "assets/images/back.png",
                    //       width: 45,
                    //       height: 65,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 0, right: 30, left: 10),
                        child: Image.asset(
                          "assets/images/home-logo.png", width: 130,)
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen()));
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "User Profile",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Mont-SemiBold"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SizedBox(width: 100,child: Divider(height: 1,thickness: 1,color: ConstantColors.appTheme,),),
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _previewImage(),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "" + fullName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Mont-Regular"
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Spacer(),
                              Text(
                                "+1 $mobileNumber",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Mont-Light",
                                  color: ConstantColors.appTheme,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(height: 24,width: 2,child: Container(color: ConstantColors.lightGrey,),),
                              const Spacer(),
                              Text(
                                "Unique ID: " + customerIdController.text,
                                style: TextStyle(
                                    color: ConstantColors.appTheme,
                                    fontSize: 17,
                                    fontFamily: "Mont-Light"
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(15.0, 20, 0, 0),
                              child:
                              Row(
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
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: _currentIndex == index
                                              ? ConstantColors.appTheme
                                              : Color(0xFFF2F2F2),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              index == 0
                                                  ? Image.asset(
                                                "assets/images/user.png",
                                                color: _currentIndex == index ? Colors.white : Colors.black,
                                                width: 14,
                                                height: 14,
                                              )
                                                  : Image.asset(
                                                "assets/images/orderDetails.png",
                                                color: _currentIndex == index ? Colors.white : Colors.black,
                                                width: 16,
                                                height: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
                                                child: Text(
                                                  e.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Mont-Light',
                                                    color: _currentIndex ==
                                                        index
                                                        ? Color(0xFFFFFFFF)
                                                        : Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                          ),
                          Divider(height: 25,thickness: 2,color: ConstantColors.lightGrey,),
                          _currentIndex == 0
                              ? _personalDetails()
                              : _currentIndex == 1
                              ? _ordersHistoryItems()
                              : const SizedBox(width: 0,height: 0,)
                        ],
                      )
                  ),
                )
              ]),
        ),
      ),
    );
  }
  Widget _previewImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // _pickImage();
            _chooseProfilePic();
            print("Choose profile image.");
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Stack(fit: StackFit.loose, children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  profilePicUrl == ''
                      ? Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          image: ExactAssetImage(
                              'assets/images/userprofile.png'),
                          fit: BoxFit.cover,
                        ),
                      ))
                      : Container(
                    height: 130,
                    width: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(65.0),
                      child: CachedNetworkImage(
                        imageUrl: profilePicUrl,
                        placeholder: (context, url) =>
                        const Center(
                            child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/userprofile.png"),
                        //const Icon(Icons.refresh_outlined),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // height: 150,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 88.0, left: 75.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: ConstantColors.lightGrey,
                        radius: 15.0,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      )
                    ],
                  )),
            ]),
          ),
        ),
      ],
    );
  }
  Widget _personalDetails() {
    return GestureDetector(
      onTap: () {
        // _pickImage();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:  [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children:  [
                  const Text(
                    "Personal Information",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Mont-SemiBold"
                    ),
                  ),
                  const Spacer(),
                  isEditProfile?GestureDetector(
                    onTap: (){
                      setState(() {
                        isEditProfile = false;
                      });
                    },
                    child: Container(
                      width: 90,
                      height: 33,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(20),
                        color: ConstantColors.darkYellow,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/edit.png",
                              color: Colors.black,
                              width: 20,
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  fontFamily: 'Mont-Regular',
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ):const SizedBox(width: 0,height: 0,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: TextField(
                controller: userNameController,
                readOnly: isEditProfile,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Enter Your Name',

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: TextField(
                controller: lastNameController,
                readOnly: isEditProfile,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Enter Your Last Name',

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: TextField(
                controller: addressController,
                readOnly: isEditProfile,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Enter Your Address',

                ),
              ),
            ),Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: TextField(
                controller: emailController,
                readOnly: isEditProfile,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Enter Your Email',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:   [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                    child: countriesList == null
                        ? const SizedBox(height: 0, width: double.infinity)
                        : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 5, 0),
                          child: IgnorePointer(
                            ignoring: isEditProfile,
                            child: DropdownButton(
                              icon: const Icon(
                                Icons
                                    .arrow_drop_down_circle_outlined,
                                size: 15,
                              ),
                              dropdownColor:
                              Colors.white,
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: const Padding(
                                padding:  EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Select Country',
                                  style: TextStyle(
                                      fontFamily:
                                      "Lorin",
                                      fontSize: 16.0,
                                      color: Colors.black),
                                ),
                              ),
                              value: countryController.text != '' ? countryController.text : null,
                              items: countriesList
                                  .map((item) {
                                return DropdownMenuItem(
                                  child: Text(
                                    item['CountryName'],
                                    style: const TextStyle(
                                        color: Color(
                                            0xFF000000)),
                                  ),
                                  value: item['CountryName']
                                      .toString(),
                                );
                              }).toList(), onChanged: (Object? value) {
                              setState(() {
                                print('selected country' + value!.toString());
                                countryController.text =
                                    value.toString();
                                for(int i=0;i<countriesList.length;i++){
                                  if(countryController.text==countriesList[i]['CountryName']){
                                    countryControllerId.text=countriesList[i]['CountryId'].toString();
                                  }
                                }
                                loadstates();
                              });
                            },
                            ),
                          ),
                        ),
                        const Divider(thickness: 1,height: 1,color: Colors.grey,)
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 15, 0),
                    child: statesLists == null ? const SizedBox(height: 0, width: double.infinity)
                        : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: DropdownButton(
                            icon: const Icon(
                              Icons
                                  .arrow_drop_down_circle_outlined,
                              size: 15,
                            ),
                            dropdownColor:
                            Colors.white,
                            isExpanded: true,
                            underline: SizedBox(),
                            hint:  Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                ''+stateController.text,
                                style: const TextStyle(
                                    fontFamily:
                                    "Lorin",
                                    fontSize: 16.0,
                                    color: Colors.black),
                              ),
                            ),
                            value: stateController.text != '' ? stateController.text : null,
                            items: statesLists
                                .map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item['StateName'],
                                  style: const TextStyle(
                                      color: Color(
                                          0xFF000000)),
                                ),
                                value: item['StateName']
                                    .toString(),
                              );
                            }).toList(), onChanged: (Object? value) {
                            setState(() {
                              print('' + value!.toString());
                              stateController.text =
                                  value.toString();
                              // for(int i=0;i<CountriesList.length;i++){
                              //   if(countryController.text==CountriesList[i]['CountryName']){
                              //     countryControllerId.text=CountriesList[i]['CountryId'].toString();
                              //   }
                              // }
                              // loadstates();
                            });
                          },

                          ),
                        ),
                        const Divider(thickness: 1,height: 1,color: Colors.grey,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:   [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                    child: TextField(
                      readOnly: isEditProfile,

                      controller: cityController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'City',

                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 15, 0),
                    child: TextField(
                      readOnly: isEditProfile,
                      controller: zipcodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Enter Zip Code ',
                        counterText: "",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isEditProfile
                ?const SizedBox(width: 0,height: 0,):Padding(
              padding: const EdgeInsets.only(top: 20),
              child: MaterialButton(
                onPressed: () {
                  //Write update profile details api and do isEditProfile to false
                  verifyFormDetails();
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: 46,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      gradient:  const LinearGradient(
                        colors: [
                          Color(0xff3962cb),
                          Color(0xff3962cb),
                        ],
                      )
                  ),
                  //padding: const EdgeInsets.all(10.0),
                  child: const Center(
                    child: Text(
                      "UPDATE",
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
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
  Future<void> loadstates() async {
    String url1 = 'http://app.adslay.com/API/HomeAPI/StatesList';
    print(url1);
    Map<String, dynamic> body = {
      'CountryId': ''+countryControllerId.text.toString(),
    };
    print("Profile get details api calling :" + body.toString());
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final encoding = Encoding.getByName('utf-8');
    final response = await post(
      Uri.parse(url1),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    Map data = jsonDecode(response.body);
    print(data);
    setState(() {
      print(''+data.toString());
      statesLists =data['StatesList'];
      isLoading=false;
    });
  }
  Widget _ordersHistoryItems() {
    return isLoading1
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
        : ordersHistoryList.isEmpty?Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Image.asset("assets/images/noordersfound.png",width: 250,height: 250,),
                ),
              ],
            )):ListView.builder(
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
                    // const Padding(
                    //   padding: EdgeInsets.fromLTRB(15, 5, 5, 8),
                    //   child: Text(
                    //     "\$3.00",
                    //     maxLines: 2,
                    //     style: TextStyle(
                    //       fontSize: 18.0,
                    //       fontFamily: 'Mont-Regular',
                    //       color: Colors.blue,
                    //     ),
                    //   ),
                    // ),
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
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                          const Spacer(),
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
                          const Spacer(),
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
    );
  }
  Future<void> updateProfileDetails() async {
    await pr.show();
    //API Calling
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      String url1 = APIConstant.updateProfileDetails;
      print("Update profile details api:" + url1);
      Map<String, dynamic> body;
      body = {
        'MobileNo': mobileNumber,
        'FirstName': userNameController.text,
        'LastName': lastNameController.text,
        'Country': countryController.text,
        'State': stateController.text,
        'City': cityController.text,
        'ZipCode': zipcodeController.text,
        'Address1': addressController.text,
        'Email':emailController.text,
      };
      print('' + body.toString());
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final encoding = Encoding.getByName('utf-8');
      final response = await post(
        Uri.parse(url1),
        headers: headers,
        body: body,
        encoding: encoding,
      );
      Map data1 = jsonDecode(response.body);
      print("Update profile data response:" + data1.toString());
      await pr.hide();
      String msg = data1["msg"];
      if (msg == "Success" || msg == "Updated" || msg == "success" ) {
        print("Profile details updated successfully.");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', ""+emailController.text);
        setState(() {
          isEditProfile = true;
          isLoading = true;
          getData();
        });

      } else {
        print("Something went wrong..");
      }
    } else {
      print("Check internet connection..!");
    }
  }
  Future<void> verifyFormDetails() async {
    if (userNameController.text == '') {
      Fluttertoast.showToast(
          msg: "Please enter first name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    } else if ( lastNameController.text == '') {
      Fluttertoast.showToast(
          msg: "Please enter last name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    } else if (countryController.text == '') {
      Fluttertoast.showToast(
          msg: "Please select country",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    } else if (stateController.text == '') {
      Fluttertoast.showToast(
          msg: "Please select state",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    } else if (cityController.text == '') {
      Fluttertoast.showToast(
          msg: "Please enter city",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    } else {
      print('updating profile details..');
      updateProfileDetails();
      return;
    }
  }
}