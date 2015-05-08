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

        var viewName = getViewNameForJMDict(text)
        
        var output_array:[DummyEntity] = []
        
        var results = DatabaseInterface.sharedInstance.queryWordinJMDict(inputText, viewName: viewName)
        
        var mid = NSDate().timeIntervalSince1970
        
        var wordList = CBLQueryEnumeratorToJMEntity(results, text: text)
        output_array = output_array + wordList
        
        var endtime = NSDate().timeIntervalSince1970
        //println("CBLQueryEnumeratorToJMEntity Duration : \(endtime-mid) Seconds")
        println("queryTextInput(text:String) Duration : \(endtime-starttime) Seconds")
        
//        for var i = 0 ; i < output_array.count ; i++ {
//            var doc = (output_array[i] as DummyEntity).doc
//            
//            var str = Utility.nsobjectToString(doc!.properties)
//            println("\((output_array[i] as DummyEntity).frequency) \(str)")
//
//        }
        
        return output_array
    }
    
    func getViewNameForJMDict(text:String) -> DatabaseInterface.JMDictViewName {
        
        for tempChar in text.unicodeScalars {
            if !tempChar.isASCII() {
                return DatabaseInterface.JMDictViewName.KANJI_VIEW
            }
        }
        
        return DatabaseInterface.JMDictViewName.ENGLISH_VIEW
    }
    
    func textAddingSearchFunction(text:String) -> String{
        
        for tempChar in text.unicodeScalars {
            if !tempChar.isASCII() {
                return text + "*"
            }
        }
        
        return text
        
    }
    
    func CBLQueryEnumeratorToJMEntity(queryLists:CBLQueryEnumerator, text:String) -> [DummyEntity]{
        var starttime = NSDate().timeIntervalSince1970
        var output:[DummyEntity] = []

        println("queryLists \(queryLists.count)")
//        
        while let row = queryLists.nextRow() {
            var jmDict = DummyEntity(row: row, dbName:DatabaseInterface.DatabaseName.JMDICT)
//            if (find(output, jmDict) == nil){
//                
//            }
            output.append(jmDict)
        }
        
//        println("queryLists Removed \(output.count)")
//        
        var mid = NSDate().timeIntervalSince1970
        output.sort({
            (a:DummyEntity,b:DummyEntity)-> Bool in
            return a.frequency > b.frequency
        })
        var endtime = NSDate().timeIntervalSince1970
        
        println("DummayEntity Duration : \(mid-starttime) Seconds")
        println("output.sort Duration : \(endtime-mid) Seconds")
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