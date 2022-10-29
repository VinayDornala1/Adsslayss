import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart'; //yashwanth
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BoolProvider.dart';
import 'HistoryScreen.dart';
import 'MainScreen.dart';
import 'OrderDetailsScreen.dart';
import 'ProfileScreen.dart';
import 'StoresList.dart';
import 'StoresScreen.dart';
import 'animated_custom_dialog.dart';
import 'guest_dialog.dart';
class BottomNavigationMenu extends StatefulWidget {
    static var indexbottom=0 ;
  @override
  _BottomNavigationMenuState createState() => _BottomNavigationMenuState();
}
class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  int _index = 0;

  _onSelected(int index) {
    setState(() {
      _index = index;
    });
  }
  var index=BottomNavigationMenu.indexbottom;
// int index=0;
  // int _selectedPage = 0;
  List<Widget> pageList = [
    MainScreen(),
    const StoresScreen(),
    HistoryScreen(),
    const ProfileScreen(),
  ];
    onItemTapped(index) {
    setState(() async {
      // _selectedPage = index;
      BottomNavigationMenu.indexbottom = index;
      _boolProvider.setBottomChange(index);
      if (index == 0) {
        print('dfcgfg');
        _boolProvider.setBottomChange(0);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                BottomNavigationMenu(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationMenu()));
      }
      if (index == 1) {
        print('dfcgfg');
        _boolProvider.setBottomChange(1);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                BottomNavigationMenu(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationMenu(),));
      }
      if (index == 2) {
        if (Email == 'guest@guest.com') {
          _boolProvider.setBottomChange(0);
          showAnimatedDialog(context, GuestDialog(), isFlip: true);
        } else {
          print('dfcgfg');
          _boolProvider.setBottomChange(2);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  BottomNavigationMenu(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationMenu()));
      }
      if (index == 3) {
        if (Email == 'guest@guest.com') {
          _boolProvider.setBottomChange(0);
          showAnimatedDialog(context, GuestDialog(), isFlip: true);
        } else {
          print('dfcgfg');
          _boolProvider.setBottomChange(3);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  BottomNavigationMenu(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationMenu()));
      }
    });
  }

  String Email = '';

  @override
  void initState() {
    super.initState();
    print("object$_index");
    new Future.delayed(Duration.zero, () {
      initOneSignal(); //yashwanth
    });
  }

  bool _requireConsent = false;
  bool _enableConsentButton = false;

  Future<void> initOneSignal() async {
    //yashwanth
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        Email = prefs.getString('email')!;
      });
    } catch (e) {}
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      this.setState(() {});
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);

      this.setState(() {});
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {});
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared
        .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
      print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
      print("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
      print("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
      print("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
      print("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.setAppId("303226ba-4137-4a39-8f09-43e823a8ec97");

    // iOS-only method to open launch URLs in Safari when set to false
    OneSignal.shared.setLaunchURLsInApp(false);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(() {
      _enableConsentButton = requiresConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    oneSignalInAppMessagingTriggerExamples();

    OneSignal.shared.disablePush(false);

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    oneSignalOutcomeEventsExamples();

    bool userProvidedPrivacyConsent =
        await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
    // try {
    //   var deviceState = await OneSignal.shared.getPermissionSubscriptionState();
    //   var playerId = deviceState.subscriptionStatus.userId;
    //   print('Player ID: ' + playerId);
    //   print('-------------' + playerId);
    //   String url1 = APIConstant.base_url + "StudentsAPI/TokenUpdate?Email="+email+"&TokenNo="+playerId+"&Type=Student";
    //   url1 = url1.replaceAll('+', '');
    //   print(''+url1);
    //   Response response=await get(Uri.parse(url1));
    //   Map data = jsonDecode(response.body);
    //   print(data);
    // }catch (error) {
    //
    // }
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);
    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");
    // Get the value for a trigger by its key
    Object? triggerValue =
        await OneSignal.shared.getTriggerValueForKey("trigger_3");
    print("'trigger_3' key trigger value: ${triggerValue?.toString()}");
    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.shared.removeTriggersForKeys(keys);
    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    outcomeAwaitExample();
    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
  }

  Future<void> outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    print(outcomeEvent.jsonRepresentation());
  }

  List<Widget> _pages() {
    return [
      MainScreen(),
      StoresList(),
      HistoryScreen(),
      const ProfileScreen(),
    ];
  }

  static const int totalPage = 4;
  static const List<String> names = [
    'Home',
    'Search',
    'Application',
    'Profile',
  ];
  List<IconData> icons = [
    Icons.home,
    Icons.movie,
    Icons.timer,
    Icons.multiline_chart
  ];
  BoolProvider _boolProvider = BoolProvider();

  @override
  Widget build(BuildContext context) {

    _boolProvider = Provider.of<BoolProvider>(context);
    return WillPopScope(
      onWillPop: ()async{
        // _boolProvider=intdsg.toString() as BoolProvider;
        if(index == 0){
          return true;
        }
        setState(() {
          onItemTapped(0);
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _boolProvider.indexes,
          children: pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontFamily: "Lorin",
            color: Color(0xFF9D9D9D),
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontFamily: "Lorin",
            color: Color(0xFF9D9D9D),
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/home-icon2.png",
                    width: 25, height: 25),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                child: Image.asset("assets/images/home-icon.png",
                    width: 25, height: 25,),
                // child: SvgPicture.asset(
                //   'assets/images/hom.svg',
                //   height: 20,
                //   color: Color(0xFF0063AD),
                // ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/stores.png",
                    width: 25, height: 25),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                child: Image.asset("assets/images/stores2.png",
                    width: 25, height: 25),
              ),
              label: 'AD Spaces',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/history.png",
                    width: 25, height: 25),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                child: Image.asset("assets/images/history.png",
                    width: 25, height: 25, color: const Color(0xFF0063AD)),
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/profile.png",
                    width: 25, height: 25),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                child: Image.asset("assets/images/profile2.png",
                    width: 25, height: 25),
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _boolProvider.indexes,
          backgroundColor: const Color(0xFFFFFFFF),
          selectedItemColor: const Color(0xFF0063AD),
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
