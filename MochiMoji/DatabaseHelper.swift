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
    
//    func queryTextInput(text:String) -> [Entity]{
    func queryTextInput(text:String) -> [DummyEntity]{
        var starttime = NSDate().timeIntervalSince1970
        
        var inputText = text//textAddingSearchFunction(text)
        //println(inputText)
        
        //var output_array:[Entity] = []
        var output_array:[DummyEntity] = []
        
//        if countElements(inputText) < 10 {
//            for var size = countElements(inputText) ; size < 10 ; size++ {
//                var results = DatabaseInterface.sharedInstance.queryWordinJMDict(inputText, size: size)
//                var wordList = CBLQueryEnumeratorToJMEntity(results, text: text)
//                output_array = output_array + wordList
//                if (output_array.count > 50) {
//                    break
//                }
//            }
//        }
//        else {
//            var results = DatabaseInterface.sharedInstance.queryWordinJMDict(inputText, size: countElements(inputText))
//            var wordList = CBLQueryEnumeratorToJMEntity(results, text: text)
//            output_array = output_array + wordList
//        }
        
        var results = DatabaseInterface.sharedInstance.queryWordinJMDict(inputText, size: countElements(inputText))
        
        var mid = NSDate().timeIntervalSince1970
        
        var wordList = CBLQueryEnumeratorToJMEntity(results, text: text)
        output_array = output_array + wordList
    
//        println(results.count)
//        println(wordList.count)
        
        var endtime = NSDate().timeIntervalSince1970
        //println("DatabaseInterface.sharedInstance.queryWordinJMDict Duration : \(mid-starttime) Seconds")
        println("CBLQueryEnumeratorToJMEntity Duration : \(endtime-mid) Seconds")
        println("queryTextInput(text:String) Duration : \(endtime-starttime) Seconds")
        
        for var i = 0 ; i < output_array.count ; i++ {
            //println((output_array[i] as JMDictEntity).unique_id)
        }
        
        return output_array
    }
    
    func textAddingSearchFunction(text:String) -> String{
        return text + "*"
    }
    
    //func CBLQueryEnumeratorToJMEntity(queryLists:CBLQueryEnumerator, text:String) -> [JMDictEntity]{
    func CBLQueryEnumeratorToJMEntity(queryLists:CBLQueryEnumerator, text:String) -> [DummyEntity]{
        var starttime = NSDate().timeIntervalSince1970
        var output:[DummyEntity] = []
        //var output:[JMDictEntity] = []
        
        while let row = queryLists.nextRow() {
            //var jmDict = JMDictEntity(row: row)
            var jmDict = DummyEntity(row: row)
            output.append(jmDict)
        }
        
        var mid = NSDate().timeIntervalSince1970
        output.sort({
            //(a:JMDictEntity,b:JMDictEntity)-> Bool in
            (a:DummyEntity,b:DummyEntity)-> Bool in
            
            return a.unique_id < b.unique_id
        })
        var endtime = NSDate().timeIntervalSince1970
        
        println("JMDictEntity Duration : \(mid-starttime) Seconds")
        println("output.sort Duration : \(endtime-mid) Seconds")
        
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