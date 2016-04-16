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
    
    let DEBUG_THIS_FILE = false
    let class_name = "DatabaseHelper"

    class var sharedInstance: DatabaseHelper {
        return sharedHelperInstance
    }
    
    init(){
        
    }

    func queryTextInput(text:String) -> [DummyEntity]{
        
        let function_name = "queryTextInput"
        
        Utility.debug_println(DEBUG_THIS_FILE, swift_file : class_name, function : function_name, text: "\n Text input : \(text) \n")
        
        let starttime = NSDate().timeIntervalSince1970
        
        let inputText = textAddingSearchFunction(text)

        let viewName = getViewNameForJMDict(text)
        
        var output_array:[DummyEntity] = []
        
        let results = DatabaseInterface.sharedInstance.queryWordinJMDict(inputText, viewName: viewName)
        
        _ = NSDate().timeIntervalSince1970
        
//        Utility.debug_println(DEBUG_THIS_FILE, swift_file : class_name, function : function_name, text: "\n Query Time : \(mid-starttime) Seconds \n")
        
        let wordList = CBLQueryEnumeratorToJMEntity(results, text: text)
        output_array = output_array + wordList
        
        let endtime = NSDate().timeIntervalSince1970
        //println("CBLQueryEnumeratorToJMEntity Duration : \(endtime-mid) Seconds")
        
        Utility.debug_println(DEBUG_THIS_FILE, swift_file : class_name, function : function_name, text: "\n queryTextInput(text:String) Duration : \(endtime-starttime) Seconds \n")
        
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
        
//        for tempChar in text.unicodeScalars {
//            if !tempChar.isASCII() {
//                return text + "*"
//            }
//        }
        
        return text
        
    }
    
    func CBLQueryEnumeratorToJMEntity(queryLists:CBLQueryEnumerator, text:String) -> [DummyEntity]{
        
        let function_name = "CBLQueryEnumeratorToJMEntity"
        
        _ = NSDate().timeIntervalSince1970
        var output:[DummyEntity] = []

        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "\n  queryLists \(queryLists.count) \n")
        
        _ = [Int]()
        
        while let row = queryLists.nextRow() {
            let jmDict = DummyEntity(row: row, dbName:DatabaseInterface.DatabaseName.JMDICT)
            
//            if !contains(set, jmDict.unique){
                output.append(jmDict)
//                set.append(jmDict.unique)
//            }
            
        }
        
        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "\n  output \(output.count) \n")
        
        _ = NSDate().timeIntervalSince1970
        output.sortInPlace({
            (a:DummyEntity,b:DummyEntity)-> Bool in
            return a.frequency > b.frequency
        })
        _ = NSDate().timeIntervalSince1970
        
//        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "DummayEntity Duration : \(mid-starttime) Seconds")
//        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "output.sort Duration : \(endtime-mid) Seconds")

        return output
        
    }
 
    func removeDuplicate(enumerator: CBLQueryEnumerator) -> [CBLQueryRow] {
        var outList: [CBLQueryRow] = [];
        let setCheck = NSMutableSet()
        while let row = enumerator.nextRow() {
            let st = row.documentID
            if !setCheck.containsObject(st) {
                setCheck.addObject(st)
                outList.append(row)
            }

        }
        return outList
    }
    
}