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
    
    let DEBUG_THIS_FILE = false
    let class_name = "DatabaseInterface"
    
    class var sharedInstance: DatabaseInterface {
        return sharedDatabaseInstance
    }
    
    enum DatabaseName {
        case JMDICT
        case KANJI_DICT
        case GRAMMAR
        case EXAMPLE_SENTENCES
    }
    
    enum JMDictViewName: String {
        case KANJI_VIEW = "kanjiView"
        case ENGLISH_VIEW = "englishWordView"
    }
    
    enum DatabaseStringName: String{
        case JMDICT = "jmdict-30-4-2015-view"
    }
    
    var dbManager:CBLManager
    var databases = [DatabaseName:CBLDatabase]()
    
    init(){
        dbManager = CBLManager.sharedInstance()
        var error :NSError?
        var database = dbManager.existingDatabaseNamed(DatabaseStringName.JMDICT.rawValue, error: &error)
        databases[DatabaseName.JMDICT] = database
    }

    func queryWordinJMDict(text:String, viewName:JMDictViewName) -> CBLQueryEnumerator {
        
        let function_name = "queryWordinJMDict"
        
        var databaseManager = CBLManager.sharedInstance().copy()
        var error :NSError?
        var database = databaseManager.existingDatabaseNamed(DatabaseStringName.JMDICT.rawValue, error: &error)
        
        var starttime = NSDate().timeIntervalSince1970
        //let query = databases[DatabaseName.JMDICT]?.viewNamed("wordsViewDidAppear").createQuery()
        
//        let query = database.viewNamed("wordsViewDidAppear").createQuery()
        let query = database.viewNamed(viewName.rawValue).createQuery()
        
        query?.limit = 500
        query?.fullTextQuery = text
        let result = query?.run(&error)

        var endtime = NSDate().timeIntervalSince1970

        Utility.debug_println(DEBUG_THIS_FILE, swift_file : class_name, function : function_name, text: "queryWordinJMDict Query Duration : \(endtime-starttime) Seconds")
        
        return result!
        
    }
    
    let kanji_element_key = "k_ele"
    let kanji_entity = "keb"
    
    let senseKey = "sense"
    let glossKey = "gloss"
    
    func reEmitWordView(database:CBLDatabase){
        
        let wordView = database.viewNamed(JMDictViewName.KANJI_VIEW.rawValue)
        wordView?.setMapBlock({ (doc, emit) in
            
            var emitting_string = ""
            
            if doc[self.kanji_element_key] != nil {
                
                if let d = (doc as NSDictionary).objectForKey(self.kanji_element_key) as? NSArray {
                    var str_all = ""
                    for var i = 0; i < d.count ; i++ {
                        if ((d[i] as NSDictionary)[self.kanji_entity] != nil) {
                            let str = (d[i] as NSDictionary)[self.kanji_entity] as String
                            str_all = str_all + " " + str
                        }
                    }
                    //emit(CBLTextKey(str_all),nil)
                    emitting_string = emitting_string + " " + str_all
                }
                else {
                    let d:NSDictionary = (doc as NSDictionary).objectForKey(self.kanji_element_key) as NSDictionary!
                    if (d[self.kanji_entity] != nil) {
                        let str = d[self.kanji_entity] as String
                        //emit(CBLTextKey(str),nil)
                        emitting_string = emitting_string + " " + str
                    }
                }
                
            }
            
            emit(CBLTextKey(emitting_string),nil)
            
        }, version: "1")
        
//        let wordView = database.viewNamed(JMDictViewName.KANJI_VIEW.rawValue)
//        wordView?.setMapBlock({ (doc, emit) in
//            
//            var emitting_string = ""
//            
//            if doc[self.kanji_element_key] != nil {
//                
//                if let d = (doc as NSDictionary).objectForKey(self.kanji_element_key) as? NSArray {
//                    var str_all = ""
//                    for var i = 0; i < d.count ; i++ {
//                        if ((d[i] as NSDictionary)[self.kanji_entity] != nil) {
//                            let str = (d[i] as NSDictionary)[self.kanji_entity] as String
//                            str_all = str_all + " " + str
//                            emit(CBLTextKey(str),nil)
//                        }
//                    }
//                    //emit(CBLTextKey(str_all),nil)
//                    emitting_string = emitting_string + " " + str_all
//                }
//                else {
//                    let d:NSDictionary = (doc as NSDictionary).objectForKey(self.kanji_element_key) as NSDictionary!
//                    if (d[self.kanji_entity] != nil) {
//                        let str = d[self.kanji_entity] as String
//                        emit(CBLTextKey(str),nil)
//                        emitting_string = emitting_string + " " + str
//                    }
//                }
//                
//            }
//            
//            //emit(CBLTextKey(emitting_string),nil)
//            
//        }, version: "6")

        let englishWordView = database.viewNamed(JMDictViewName.ENGLISH_VIEW.rawValue)
        englishWordView?.setMapBlock({ (doc, emit) in
            
            var emitting_string = ""
            
            var meaning = ""

            if let senses = Utility.getArrayForKey(doc, keyString: self.senseKey) {
                for var i = 0; i < senses.count ; i++ {
                    let dictionary = senses[i] as NSDictionary

                    // Gloss Extraction
                    var meaning_list = Array<Dictionary<String,String>>()
                    if let glosses = Utility.getArrayForKey(dictionary, keyString: self.glossKey) {
                        for var j = 0; j < glosses.count ; j++ {
                            if let gloss = glosses[j] as? String {
                                //println("Eng : \(gloss)")
                                meaning = meaning + " | " + gloss
                            }
                        }
                    }
                    // End Gloss Extraction

                }

            }
            
            emitting_string = emitting_string + " " + meaning
            //println(emitting_string)
            emit(CBLTextKey(emitting_string),nil)
            
        }, version: "1")
        
//        let englishWordView = database.viewNamed(JMDictViewName.ENGLISH_VIEW.rawValue)
//        englishWordView?.setMapBlock({ (doc, emit) in
//            
//            var emitting_string = ""
//            
//            var meaning = ""
//            
//            if let senses = Utility.getArrayForKey(doc, keyString: self.senseKey) {
//                for var i = 0; i < senses.count ; i++ {
//                    let dictionary = senses[i] as NSDictionary
//                    
//                    // Gloss Extraction
//                    var meaning_list = Array<Dictionary<String,String>>()
//                    if let glosses = Utility.getArrayForKey(dictionary, keyString: self.glossKey) {
//                        for var j = 0; j < glosses.count ; j++ {
//                            if let gloss = glosses[j] as? String {
//                                //println("Eng : \(gloss)")
//                                meaning = meaning + " | " + gloss
//                                emit(CBLTextKey(gloss),nil)
//                            }
//                        }
//                    }
//                    // End Gloss Extraction
//                    
//                }
//                
//            }
//            
//            emitting_string = emitting_string + " " + meaning
//            //println(emitting_string)
//            //emit(CBLTextKey(emitting_string),nil)
//            
//        }, version: "6")
        
    }

    
}