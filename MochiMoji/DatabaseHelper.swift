//
//  DatabaseHelper.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/10/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

/*
Database Helper :
Contain function for querying entity in the databases with filtering algorithm
*/

import Foundation

private let sharedHelperInstance = DatabaseHelper()

class DatabaseHelper{
    
    class var sharedInstance: DatabaseHelper {
        return sharedHelperInstance
    }
    
    init(){
        
    }
    
    func queryTextInput(text:String) -> [Entity]{
        var starttime = NSDate().timeIntervalSince1970
        var results = DatabaseInterface.sharedInstance.queryWordinJMDict(text)
        var wordList = CBLQueryEnumeratorToJMEntity(results)
        var endtime = NSDate().timeIntervalSince1970
        println("queryTextInput(text:String) Duration : \(endtime-starttime) Seconds")
        return wordList
    }
    
    func CBLQueryEnumeratorToJMEntity(queryLists:CBLQueryEnumerator) -> [JMDictEntity]{
        
        var output:[JMDictEntity] = []
        
        var qlist_clean = removeDuplicate(queryLists)
        
        for var i = 0 ; i < qlist_clean.count ; i++ {
            var jmDict = JMDictEntity(row: qlist_clean[i])
            output.append(jmDict)
        }
        
        return output
    }
 
    func removeDuplicate(enumerator: CBLQueryEnumerator) -> [CBLQueryRow] {
        var outList: [CBLQueryRow] = [];
        var setCheck = NSMutableSet()
        while let row = enumerator.nextRow() {
            var st = row.documentID
            if !setCheck.containsObject(st) {
                setCheck.addObject(st)
                outList.append(row)
            }
        }
        return outList
    }
    
}