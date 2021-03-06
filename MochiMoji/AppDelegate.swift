//
//  AppDelegate.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 1/25/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let debug_appdelegate = true
    let fileName = "AppDelegate"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        databaseConnection()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func databaseConnection() {
        
        let dbname = DatabaseInterface.DatabaseStringName.JMDICT.rawValue
        
        let dbManager = CBLManager.sharedInstance()
        var error :NSError?
        var database: CBLDatabase!
        do {
            database = try dbManager?.existingDatabaseNamed(dbname)
        } catch let error1 as NSError {
            error = error1
            database = nil
        }
        
        print("Couchbase version : \(CBLVersion())")
        
        if database == nil {
            
            Utility.debug_println(debug_appdelegate, swift_file: fileName, function: "databaseConnection", text: "database == nil : Trying to copying")
            
            let cannedDbPath = Bundle.main.path(forResource: dbname, ofType: "cblite")
            //println(cannedDbPath)
            let cannedAttPath = Bundle.main.path(forResource: "CouchbaseLite/jmdict attachments", ofType: "")
            do {
                try dbManager?.replaceDatabaseNamed(dbname, withDatabaseFile: cannedDbPath!, withAttachments: cannedAttPath)
            } catch let error1 as NSError {
                error = error1
            }
            do {
                database = try dbManager?.existingDatabaseNamed(dbname)
            } catch let error1 as NSError {
                error = error1
                database = nil
            }
            if error != nil {
                //self.handleError(error)
                print("Error \(error?.description)")
            }
        }
        
        DatabaseInterface.sharedInstance.reEmitWordView(database)
        
        DatabaseHelper.sharedInstance.queryTextInput("drink")
        var dummy = DatabaseHelper.sharedInstance.queryTextInput("食")
//        print(Utility.nsobjectToString(dummy[0].doc!.properties))
        
//        DatabaseInterface.sharedInstance
//        let result = DatabaseInterface.sharedInstance.queryWordinJMDict("食べる")
        
        
//        let wordView = database?.viewNamed("wordsViewDidAppear")
//        let query = database?.viewNamed("wordsViewDidAppear").createQuery()
//        //query?.limit = 10
//        query?.fullTextQuery = "飲む"
//        
//        var starttime = NSDate().timeIntervalSince1970
//        println("ViewDidAppaer Query start : \(NSDate().timeIntervalSince1970)")
//        let result = query?.run(&error)
//        
//        var endtime = NSDate().timeIntervalSince1970
//        println("ViewDidAppaer Query end : \(NSDate().timeIntervalSince1970)")
//        println("ViewDidAppaer Query Duration : \(endtime-starttime) Seconds")
//        
//        var list = getListOfDictionary(result)
//        println("Result \(list.count)")
//        for var i = 0 ; i < list.count ; i++ {
//            let jsData = NSJSONSerialization.dataWithJSONObject(list[i].document!.properties["k_ele"]!, options: NSJSONWritingOptions.allZeros, error: &error)
//            let nsJson = NSString(data: jsData!, encoding: NSUTF8StringEncoding)
//            println(nsJson!)
//        }
        
    }
    
    func getListOfDictionary(_ enumerator: CBLQueryEnumerator) -> [CBLQueryRow] {
        var outList: [CBLQueryRow] = [];
        let setCheck = NSMutableSet()
        while let row = enumerator.nextRow() {
            let st = row.documentID
            if !setCheck.contains(st) {
                setCheck.add(st)
                outList.append(row)
            }
        }
        return outList
    }
    
}

