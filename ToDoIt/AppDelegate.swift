//
//  AppDelegate.swift
//  ToDoIt
//
//  Created by NB on 2018. 04. 04..
//  Copyright © 2018. coolCodeAgency. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //megmutatja a Realm DB helyét
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //!!!!!!!!!!!!!!!!!!!!!!
        //akkor töltődik be amikor az app betöltődik, még a többi Controller előtt, _ helyett a "let realm" állt, ezért lehet a class-oknál let realm = try! Realm()
        do{
            _ = try Realm()
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //!!!!!!!!!!!!!!!!!!!!!!
        //az app ideiglenesen háttérbe kerül, mert hívás, sms, egyéb interrakció oda sorolja

        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //!!!!!!!!!!!!!!!!!!!!!!
        //amikor az app a háttérbe megy a user által (megnyomjuk a home button-t)
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    

    
    
    
    
    
    
    

}

