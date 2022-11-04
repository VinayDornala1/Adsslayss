import 'package:adslay/BoolProvider.dart';
import 'package:adslay/SplashScreen.dart';
import 'package:adslay/stripe/blocs/pay/pay_bloc.dart';
import 'package:adslay/stripe/services/stripe_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'MultipleNotifier3.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'bottom_bar.dart';
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51KFd7HHjhOs2YctLJgLY8xxj2LJduIQxYPDe04GyTjTLPFP6viTeGUfneSqDWaIHXu5Xlxr17cIfklJATpqB7hOk00NCJjjYro';

  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  print("initialLink<><><>$initialLink");
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BoolProvider()),
      BlocProvider(create: (_) => PayBloc())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // StripeService().init();
    return Consumer<BoolProvider>(
      builder: (context, model, child) {
        return MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 1200,
            minWidth: 375,
            defaultScale: false,
            breakpoints: [
              // ResponsiveBreakpoint.resize(375, name: MOBILE),
              // ResponsiveBreakpoint.autoScale(800, name: TABLET),
              // ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              // ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              // ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
          ),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFFFAFAFA),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const SplashScreen(),
          navigatorObservers: [
            // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
          ],
        );
      },
    );
  }
}
