//
//  AppDelegate.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/8.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import MMDrawerController
import Material
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//        
//        let rightDrawer = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftDrawerVC")
//        let cenDrawer = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabBarController")
//        let drawerController = MMDrawerController(centerViewController: cenDrawer, leftDrawerViewController: rightDrawer)
////        drawerController.restorationIdentifier = "MMDrawer"
//        drawerController.openDrawerGestureModeMask = .All
//       
//        drawerController.closeDrawerGestureModeMask = .All
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window?.tintColor = UIColor.redColor()
//        self.window?.rootViewController = drawerController
        let bottomNavigationController: AppBottomNavigationController = AppBottomNavigationController()
        let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
        navigationController.hidesBarsOnTap = true
        navigationController.hidesBarsOnSwipe =  true
        navigationController.hidesBottomBarWhenPushed = true
        navigationController.toolbarHidden = true
        let menuController: AppMenuController = AppMenuController(rootViewController: navigationController)
        let statusBarController: StatusBarController = StatusBarController(rootViewController: menuController)
        let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: statusBarController, leftViewController: AppLeftViewController())
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = navigationDrawerController
        window!.makeKeyAndVisible()
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

