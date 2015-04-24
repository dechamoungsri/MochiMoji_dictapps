//
//  DatabaseInterface.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/10/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

private let sharedDatabaseInstance = DatabaseInterface()

class DatabaseInterface {
    
    class var sharedInstance: DatabaseInterface {
        return sharedDatabaseInstance
    }
    
    enum DatabaseName {
        case JMDICT
        case KANJI_DICT
        case GRAMMAR
        case EXAMPLE_SENTENCES
    }
    
    enum DatabaseStringName: String{
        case JMDICT = "jmdict"
    }
    
    var dbManager:CBLManager
    var databases = [DatabaseName:CBLDatabase]()
    
    init(){
        dbManager = CBLManager.sharedInstance()
        var error :NSError?
        var database = dbManager.existingDatabaseNamed(DatabaseStringName.JMDICT.rawValue, error: &error)
        databases[DatabaseName.JMDICT] = database
    }

    func queryWordinJMDict(text:String, size:Int) -> CBLQueryEnumerator {
        
        var databaseManager = CBLManager.sharedInstance().copy()
        var error :NSError?
        var database = databaseManager.existingDatabaseNamed(DatabaseStringName.JMDICT.rawValue, error: &error)
        
        var starttime = NSDate().timeIntervalSince1970
        //let query = databases[DatabaseName.JMDICT]?.viewNamed("wordsViewDidAppear").createQuery()
        
        reEmitWordView(database)
        
        let query = database.viewNamed("wordsViewDidAppear").createQuery()
        
//        query?.limit = 100
        query?.fullTextQuery = text + "*"

//        query?.startKey = [size, text]
        
        //if size < 10 {
//        query?.endKey = [size, text + "\u{FFFFF}"]
        //}
        
//        var error :NSError?
        let result = query?.run(&error)

        var endtime = NSDate().timeIntervalSince1970
        println("queryWordinJMDict Query Duration : \(endtime-starttime) Seconds")
        return result!
        
    }
    
    func reEmitWordView(database:CBLDatabase){
        let wordView = database.viewNamed("wordsViewDidAppear")
        wordView?.setMapBlock({ (doc, emit) in
            if doc["k_ele"] != nil {
                
                if let d = (doc as NSDictionary).objectForKey("k_ele") as? NSArray {
                    var str_all = ""
                    for var i = 0; i < d.count ; i++ {
                        if ((d[i] as NSDictionary)["keb"] != nil) {
                            let str = (d[i] as NSDictionary)["keb"] as String
                            str_all = str_all + " " + str
                            
                            //emit(str,nil)
                            //emit([countElements(str),str],nil)
                            //emit([countElements(str),str],nil)
//                            for var j = 0 ; j < countElements(str) ; j++ {
//                                emit(CBLTextKey(str[Range(start: j,end: countElements(str))]),nil)
//                            }
                        }
                    }
                    emit(CBLTextKey(str_all),nil)
                }
                else {
                    let d:NSDictionary = (doc as NSDictionary).objectForKey("k_ele") as NSDictionary!
                    if (d["keb"] != nil) {
                        let str = d["keb"] as String
                        emit(CBLTextKey(str),nil)
                        //emit(str,nil)
                        //emit([countElements(str),str],nil)
                        //emit([countElements(str),str],nil)
//                        for var j = 0 ; j < countElements(str) ; j++ {
//                            emit(CBLTextKey(str[Range(start: j,end: countElements(str))]),nil)
//                        }
                    }
                }
                
            }
        }, version: "13")
        
        //println("Max \(maxy)")
        
    }

    
}