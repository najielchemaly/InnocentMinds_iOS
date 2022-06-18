//
//  AppDelegate.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/22/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
//import FBSDKCoreKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var _services: Services!
    var services: Services {
        get {
            if _services == nil {
                _services = Services.init()
            }
            
            return _services
        }
    }
    
    var window: UIWindow?
    
    let gcmMessageIDKey: String = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        Settings.appID = FACEBOOK_APP_ID
        
        Localization.doTheExchange()
        
        self.getGlobalVariables()
        
        // TODO Select Language
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "didSelectLanguage") {
            if let selectLanguageViewController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.SelectLanguageViewController) as? SelectLanguageViewController {
                window?.rootViewController = selectLanguageViewController
            }
        }
        
        return true
    }
    
    @objc func getGlobalVariables() {
        if let baseVC = self.window?.rootViewController?.children.last as? BaseViewController {
            baseVC.showLoader(backgroundColor: .black)
        
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.getConfig()
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue,
                        let json = result?.json?.first {
                        guard let variables = Variables.init(dictionary: json) else {
                            return
                        }
                        
                        if let base_url = variables.config?.base_url {
                            Services.setBaseUrl(url: base_url)
                        }
                        
                        Objects.variables = variables
                        
                        self.checkIfUserIsLoggedIn()
                    } else {
                        baseVC.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), buttonOkTitle: Localization.string(key: MessageKey.Retry), isError: true)
                        
                        if let alertView = baseVC.customView as? AlertView {
                            alertView.buttonOk.addTarget(self, action: #selector(self.getGlobalVariables), for: .touchUpInside)
                        }
                        
                        baseVC.hideLoader()
                    }
                }
            }
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if let baseVC = currentVC as? BaseViewController {
            if let data = UserDefaults.standard.data(forKey: "user"),
                let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                Objects.user = user
                if let userId = user.id, let email = user.email {
                    DispatchQueue.global(qos: .background).async {
                        let access_token = "\(userId)\(email)"
                        let result = self.services.login(accessToken: access_token)
                        
                        DispatchQueue.main.async {
                            if result?.status == ResponseStatus.SUCCESS.rawValue, let json = result?.json?.first {
                                guard let userResponse = UserResponse.init(dictionary: json) else {
                                    return
                                }
                                
                                guard let user = userResponse.user else {
                                    return
                                }
                                
                                Objects.user = user
                                
                                self.checkUserRole(user: user, message: result?.message ?? "")
                                
                                baseVC.saveUserInUserDefaults()
                            } else {
                                // Navigate to login screen
                            }
                            
                            baseVC.hideLoader()
                        }
                    }
                }
            } else {
                // Navigate to login screen
                baseVC.hideLoader()
            }
        }
    }
    
    func checkUserRole(user: User, message: String = "") {
        if let window = self.window, let role = user.role_id {
            switch role {
            case UserRole.Parent.rawValue:
                if let dashboardNC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.DashboardNavigationBarController) as? UINavigationController {
                    window.rootViewController = dashboardNC
                }
            case UserRole.Nurse.rawValue:
                if let dashboardNC = nurseStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NurseNavigationController) as? UINavigationController {
                    window.rootViewController = dashboardNC
                }
            case UserRole.Teacher.rawValue, UserRole.TeacherSupervisor.rawValue:
                if let dashboardNC = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.TeacherNavigationController) as? UINavigationController {
                    studentsNotArrived = message.isEmpty ? false : true
                    window.rootViewController = dashboardNC
                }
            case UserRole.Secretary.rawValue:
                if let registerChildVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.RegisterChildViewController) as? RegisterChildViewController {
                    registerChildVC.mode = .add
                    window.rootViewController = registerChildVC
                }
            default:
                break
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func unregisterFromRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        var sourceApplication: String = ""
//        var annotation: String = ""
//        if options[.sourceApplication] != nil {
//            sourceApplication = options[.sourceApplication] as! String
//        }
//        if options[.annotation] != nil {
//            annotation = options[.annotation] as! String
//        }
//        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        let handled: Bool = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        if let fcmToken = Messaging.messaging().fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: "firebase_token")
            UserDefaults.standard.synchronize()
            
            if let userId = Objects.user.id {
                DispatchQueue.global(qos: .background).async {
                    _ = appDelegate.services.updateToken(id: userId, token: fcmToken)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            
            DispatchQueue.main.async {
                if let baseVC = currentVC as? BaseViewController {
                    baseVC.updateNotificationBadge()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            
            DispatchQueue.main.async {
                if let dashboardVC = currentVC as? DashboardViewController {
                    dashboardVC.updateNotificationBadge()
                    dashboardVC.setNotificationBadgeNumber(label: dashboardVC.labelBadge)
                    
                    if let messagesView = dashboardVC.customView as? MessagesView {
                        messagesView.getNotifications()
                    }
                }
//                if let notificationsVC = currentVC as? NotificationsViewController {
//                    notificationsVC.handleRefresh()
//                }
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
}

