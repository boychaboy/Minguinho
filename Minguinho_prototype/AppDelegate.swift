//
//  AppDelegate.swift
//  Minguinho_prototype
//
//  Created by Eric Jeong on 06/06/2019.
//  Copyright © 2019 boychaboy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    struct global {
//        static var dicList = [String]()
        static var dicList1 = [String]()
        static var dicList2 = [String]()
        static var dicList3 = [String]()
        static var dicList4 = [String]()
        static var dicList11 = [[String]]()
        static var dicList22 = [[String]]()
        static var dicList33 = [[String]]()
        static var dicList44 = [[String]]()
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        readDictionary()
//        print(global.dicList[0][0])
//        print(global.dicList[3][0])
        makeDicList()
        return true
    }
    
    func makeDicList(){
        for i in 0..<7{
            global.dicList11.append(global.dicList1[i].components(separatedBy: " "))
        }
        for i in 0..<49{ global.dicList22.append(global.dicList2[i].components(separatedBy: " "))
        }
        
        for i in 0..<343{ global.dicList33.append(global.dicList3[i].components(separatedBy: " "))
        }
        
        for i in 0..<2401{ global.dicList44.append(global.dicList4[i].components(separatedBy: " "))
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
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

    // MARK: - Core Data stack

//    func readDictionary(){
//        if let filePath = Bundle.main.path(forResource: "dic", ofType: "txt"){
//            do {
//                let original = try String(contentsOfFile : filePath)
//                global.dicList = original.components(separatedBy: " ")
////debug                print("dic.txt loaded:)")
//            } catch {
//                print("Error : content load fail")
//            }
//        }
//        else{
//            print("Error : 'dic.txt' not found")
//        }
//    }
        func readDictionary(){
            var dicname = String()
            for i in 0...3 {
                if(i==0){dicname = "dic_1"}
                else if(i==1){dicname = "dic_2"}
                else if(i==2){dicname = "dic_3"}
                else if(i==3){dicname = "dic_4"}
                if let filePath = Bundle.main.path(forResource: dicname, ofType: "txt"){
                    do {
                        let original = try String(contentsOfFile : filePath)
                        if(i==0){global.dicList1 = original.components(separatedBy: "\n")}
                        else if(i==1){global.dicList2 = original.components(separatedBy: "\n")}
                        else if(i==2){global.dicList3 = original.components(separatedBy: "\n")}
                        else if(i==3){global.dicList4 = original.components(separatedBy: "\n")}
                        print(dicname,"loaded :-)")
                    } catch {
                        print("Error : content load fail")
                    }
                }
                else{
                    print("Error : 'dic.txt' not found")
                }
            }
        }

}

