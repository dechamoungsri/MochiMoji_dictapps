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

    func queryTextInput(_ text:String) -> [DummyEntity]{
        
        let function_name = "queryTextInput"
        
        Utility.debug_println(DEBUG_THIS_FILE, swift_file : class_name, function : function_name, text: "\n Text input : \(text) \n")
        
        let starttime = Date().timeIntervalSince1970
        
        let inputText = textAddingSearchFunction(text)

        let viewName = getViewNameForJMDict(text)
        
        var output_array:[DummyEntity] = []
        
        let results = DatabaseInterface.sharedInstance.queryWordinJMDict(inputText, viewName: viewName)
        
        _ = Date().timeIntervalSince1970
        
//        Utility.debug_println(DEBUG_THIS_FILE, swift_file : class_name, function : function_name, text: "\n Query Time : \(mid-starttime) Seconds \n")
        
        let wordList = CBLQueryEnumeratorToJMEntity(results, text: text)
        output_array = output_array + wordList
        
        let endtime = Date().timeIntervalSince1970
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
    
    func getViewNameForJMDict(_ text:String) -> DatabaseInterface.JMDictViewName {
        
        for tempChar in text.unicodeScalars {
            if !tempChar.isASCII {
                return DatabaseInterface.JMDictViewName.KANJI_VIEW
            }
        }
        
        return DatabaseInterface.JMDictViewName.ENGLISH_VIEW
    }
    
    func textAddingSearchFunction(_ text:String) -> String{
        
//        for tempChar in text.unicodeScalars {
//            if !tempChar.isASCII() {
//                return text + "*"
//            }
//        }
        
        return text
        
    }
    
    func CBLQueryEnumeratorToJMEntity(_ queryLists:CBLQueryEnumerator, text:String) -> [DummyEntity]{
        
        let function_name = "CBLQueryEnumeratorToJMEntity"
        
        _ = Date().timeIntervalSince1970
        var output:[DummyEntity] = []

        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "\n  queryLists \(queryLists.count) \n")
        
        _ = [Int]()
        
        while let row = queryLists.nextRow() {
            let jmDict = DummyEntity(row: row, dbName:DatabaseInterface.DatabaseName.jmdict)
            
//            if !contains(set, jmDict.unique){
                output.append(jmDict)
//                set.append(jmDict.unique)
//            }
            
        }
        
        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "\n  output \(output.count) \n")
        
        _ = Date().timeIntervalSince1970
        output.sort(by: {
            (a:DummyEntity,b:DummyEntity)-> Bool in
            return a.frequency > b.frequency
        })
        _ = Date().timeIntervalSince1970
        
//        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "DummayEntity Duration : \(mid-starttime) Seconds")
//        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "output.sort Duration : \(endtime-mid) Seconds")

        return output
        
    }
 
    func removeDuplicate(_ enumerator: CBLQueryEnumerator) -> [CBLQueryRow] {
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
