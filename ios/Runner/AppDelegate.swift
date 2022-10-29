import UIKit
import Flutter
import Firebase
import FirebaseAuth
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        return true
  }
  
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
      Messaging.messaging().token { (token, error) in
          if let error = error {
              print("Error fetching remote instance ID: \(error.localizedDescription)")
          } else if let token = token {
              print("Token is \(token)")
          }
      }
  }

//     override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//         let firebaseAuth = Auth.auth()
//         firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
//
//     }
     override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         let firebaseAuth = Auth.auth()
         if (firebaseAuth.canHandleNotification(userInfo)){
             print(userInfo)
             return
         }

     }
}
