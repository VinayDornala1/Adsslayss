import 'dart:convert';
import 'dart:io';

import 'package:adslay/otp_Screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:images_picker/images_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'API.dart';
import 'Constant/ConstantsColors.dart';
import 'ThankYouRegister.dart';


class VendorUpload extends StatefulWidget {
  var vendroname;
  var vendorid;

  VendorUpload({this.vendroname,this.vendorid});

  @override
  State<VendorUpload> createState() => _VendorRegisterState();
}

class _VendorRegisterState extends State<VendorUpload> {



  late ProgressDialog pr;



  Future<void> getData() async {

  }
  bool isLoading = true;
  List<dynamic> uploadedImagesList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
        message: 'Loading',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
            padding: const EdgeInsets.all(10.0), child: const CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600)
    );
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        left: false,
        top: true,
        right: false,
        bottom: false,
        child: Scaffold(
          bottomNavigationBar: MaterialButton(
            onPressed: () {
              if (uploadedImagesList.isNotEmpty)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ThankYouRegister()));
              }else {
                Fluttertoast.showToast(
                    msg: "Please upload atleast one store image",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
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
                  "Complete",
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
          body: Column(
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
                    ""+widget.vendroname,
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


                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Upload Store Images",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Mont-SemiBold"
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                              _chooseFiles();
                          },
                          child: SizedBox(
                            //height: 220,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 40),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Card(
                                            child: Container(
                                              height: 180,
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: const [
                                                  SizedBox(height: 60),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Upload your image",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.normal,
                                                        color: Colors.grey,
                                                      ),

                                                    ),
                                                  ),
                                                  // SizedBox(height: 40),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80), // if you need this
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          color: Colors.transparent,
                                          width: 100,
                                          height: 100,
                                          child: Image.asset(
                                            "assets/images/uploadfiles.png",
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  //top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        _chooseFiles();
                                      },
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.60,
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
                                            "Upload",
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
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

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
                                  childAspectRatio: 2,
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  children: List.generate(3, (index) {
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
                                                            height: MediaQuery.of(context).size.width * 0.30,
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
                            :ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,

                          physics: const BouncingScrollPhysics(),
                          itemCount: uploadedImagesList.length,
                          itemBuilder: (context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            uploadedImagesList[index]["ImageUrl"],
                                            height: 100,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(8, 10, 5, 15),
                                              child: Text(
                                                "" + uploadedImagesList[index]["FileName"],
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),

                                            MaterialButton(
                                              onPressed: () {
                                                removeUploadedFiles(uploadedImagesList[index]["StoreImageId"]);
                                              },
                                              textColor: Colors.white,
                                              padding: const EdgeInsets.all(0.0),
                                              child: Container(
                                                width: 80,
                                                height: 40,
                                                child: const Center(
                                                  child: Text(
                                                    "Remove",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        color: Colors.blue,//ConstantColors.appTheme,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "Lorin"
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]
                            );
                          },
                        ),
                        const SizedBox(height: 50),

                      ],
                    ),
                  ),
                ),





              ]),
        ),
      ),
    );
  }

  String selectedFile='';
  final String uploadUrl = APIConstant.base_url + 'HomeAPI/PostStoreImage';
  TextEditingController vendor_image =  TextEditingController();
  List<Media>? res111;

  _chooseFiles() async {

    // var picked = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg','png'],
    //   allowCompression: true,
    //
    // );
    res111 = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      quality: 0.8,
    );
    if (res111 != null) {
      setState(() {
        selectedFile = res111![0].path.toString();
      });
      print(''+res111![0].path.toString());
      await pr.show();
      File compressedFile = await FlutterNativeImage.compressImage(res111![0].path.toString(),
        quality: 5,);
      var res = await uploadImage( compressedFile.path, uploadUrl);
      print("File uploading to server response: "+ res.toString());
      Map data1 = jsonDecode(res);
      String fileName = compressedFile.path.split('/').last;
      print(fileName);
      vendor_image.text = data1['fileName'].toString();
      print("Successfully File uploaded to server"+vendor_image.text);

      String msg = data1['msg'].toString();

      if (msg == "Success" || msg == "success") {
        _uploadFileDetailsToserver();
      } else {
        Fluttertoast.showToast(
            msg: "Unable to upload file..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print("Unable to upload file details to server");
      }

      await pr.hide();

      setState(() {
        isLoading = true;
        // getdata();
      });
    }
  }

  Future<void> _uploadFileDetailsToserver() async {
    pr.show();
    String url1 = APIConstant.base_url + "HomeAPI/UpdateStoreImageAPI";
    print('Upload file url: '+url1);
    Map<String, dynamic> body = {
      'StoreId': widget.vendorid.toString(),
      'ImageUrl': vendor_image.text,
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
    pr.hide();
    print('Category base StoresList response :' + response.body.toString());

    String msg = jsonDecode(response.body)['msg'];

    if (msg == "Success" || msg == "success") {

      Fluttertoast.showToast(
          msg: "File uploaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ConstantColors.appTheme,
          textColor: Colors.white,
          fontSize: 16.0
      );

      setState(() {
        isLoading = true;
        getUploadedFiles();
      });
    } else {

      Fluttertoast.showToast(
          msg: "Unable to upload file details.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      print("Unable to get uploaded Images List response.");
    }

  }

  Future<String> uploadImage(filepath, url) async {
    var request = MultipartRequest('POST', Uri.parse(url));
    request.files.add(await MultipartFile.fromPath('file', filepath));
    var res = await request.send();
    var responseString = await res.stream.bytesToString();
    print(responseString);
    return responseString;
  }

  Future<void> getUploadedFiles() async {
    String ul='http://app.adslay.com/API/HomeAPI/GetStoreImages?StoreId='+widget.vendorid.toString();

    print("Get order image list :" + ul);
    final response22 = await get(
      Uri.parse(ul),
    );
    print('' + response22.body);
    uploadedImagesList = jsonDecode(response22.body)['CustomerOrderImageList'];
    setState(() {
      isLoading = false;
    });


  }

  Future<void> removeUploadedFiles(CusAdId) async {

    String ul='http://app.adslay.com/API/HomeAPI/RemoveStoreImage?StoreImageId='+CusAdId.toString();
    print("Get order image list :" + ul);
    final response22 = await get(
      Uri.parse(ul),
    );
    setState(() {
        Fluttertoast.showToast(
            msg: "File removed successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print("File removed successfully.");
        isLoading = true;
        getUploadedFiles();
    });
    setState(() {
      isLoading = false;
    });
  }

}
