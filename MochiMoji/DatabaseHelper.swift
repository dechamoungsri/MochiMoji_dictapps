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

    func queryTextInput(text:String) -> [DummyEntity]{
        var starttime = NSDate().timeIntervalSince1970
        
        var inputText = textAddingSearchFunction(text)

        var output_array:[DummyEntity] = []
        
        var results = DatabaseInterface.sharedInstance.queryWordinJMDict(inputText, size: countElements(inputText))
        
        var mid = NSDate().timeIntervalSince1970
        
        var wordList = CBLQueryEnumeratorToJMEntity(results, text: text)
        output_array = output_array + wordList
    
        
        var endtime = NSDate().timeIntervalSince1970
        //println("CBLQueryEnumeratorToJMEntity Duration : \(endtime-mid) Seconds")
        println("queryTextInput(text:String) Duration : \(endtime-starttime) Seconds")
        
//        for var i = 0 ; i < output_array.count ; i++ {
//            var doc = (output_array[i] as DummyEntity).doc
//            var k_ele = (doc!.properties as NSDictionary)["k_ele"]
//            var str = Utility.nsobjectToString(k_ele!)
//            println("\((output_array[i] as DummyEntity).frequency) \(str)")
//        }
        
        return output_array
    }
    
    func textAddingSearchFunction(text:String) -> String{
        return text + "*"
    }
    
    func CBLQueryEnumeratorToJMEntity(queryLists:CBLQueryEnumerator, text:String) -> [DummyEntity]{
        var starttime = NSDate().timeIntervalSince1970
        var output:[DummyEntity] = []

        while let row = queryLists.nextRow() {
            var jmDict = DummyEntity(row: row, dbName:DatabaseInterface.DatabaseName.JMDICT)
            output.append(jmDict)
        }
        
        var mid = NSDate().timeIntervalSince1970
        output.sort({
            (a:DummyEntity,b:DummyEntity)-> Bool in
            
            return a.frequency > b.frequency
        })
        var endtime = NSDate().timeIntervalSince1970
        
//        println("DummayEntity Duration : \(mid-starttime) Seconds")
//        println("output.sort Duration : \(endtime-mid) Seconds")
//        
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