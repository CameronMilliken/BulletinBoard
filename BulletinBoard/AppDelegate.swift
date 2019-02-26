//
//  AppDelegate.swift
//  BulletinBoard
//
//  Created by Jack Knight on 2/25/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let messageController = MessageController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                print("💩There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
            }
            
            guard granted == true else {return}
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        messageController.subscribeToCreationOfMessages { (subscription, error) in
            // Handle error
            //Handle if it was success
        }
        
    }
}

