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

    func queryWordinJMDict(text:String) -> CBLQueryEnumerator {
        var starttime = NSDate().timeIntervalSince1970
        let query = databases[DatabaseName.JMDICT]?.viewNamed("wordsViewDidAppear").createQuery()
        query?.limit = 50
        query?.fullTextQuery = text
        var error :NSError?
        let result = query?.run(&error)
        var endtime = NSDate().timeIntervalSince1970
        println("queryWordinJMDict Query Duration : \(endtime-starttime) Seconds")
        return result!
        
    }

    
}