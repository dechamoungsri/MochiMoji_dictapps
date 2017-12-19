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
        case jmdict
        case kanji_DICT
        case grammar
        case example_SENTENCES
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
        var database: CBLDatabase!
        do {
            database = try dbManager.existingDatabaseNamed(DatabaseStringName.JMDICT.rawValue)
        } catch let error1 as NSError {
            error = error1
            database = nil
        }
        databases[DatabaseName.jmdict] = database
    }

    func queryWordinJMDict(_ text:String, viewName:JMDictViewName) -> CBLQueryEnumerator {
        
        let function_name = "queryWordinJMDict"
        
        let databaseManager = CBLManager.sharedInstance().copy()
        var error :NSError?
        var database: CBLDatabase!
        do {
            database = try databaseManager?.existingDatabaseNamed(DatabaseStringName.JMDICT.rawValue)
        } catch let error1 as NSError {
            error = error1
            database = nil
        }
        
//        var starttime = NSDate().timeIntervalSince1970
        
        Utility.debug_println(DEBUG_THIS_FILE, swift_file: class_name, function: function_name, text: "\n Input : \(text)\n")
        
//        let query = databases[DatabaseName.JMDICT]?.viewNamed("wordsViewDidAppear").createQuery()
//        let query = database.viewNamed("wordsViewDidAppear").createQuery()
        let query = database.viewNamed(viewName.rawValue).createQuery()
        
        query?.limit = 500
        query?.startKey = text
        query?.endKey = text + "\u{FFFF}"
        
        //query?.fullTextQuery = text
        let result: CBLQueryEnumerator!
        do {
            result = try query?.run()
        } catch let error1 as NSError {
            error = error1
            result = nil
        }

//        var endtime = NSDate().timeIntervalSince1970

//        Utility.debug_println(DEBUG_THIS_FILE, swift_file : class_name, function : function_name, text: "\n Run queryWordinJMDict Query Duration : \(endtime-starttime) Seconds \n")
        
        return result!
        
    }
    
    let kanji_element_key = "k_ele"
    let kanji_entity = "keb"
    
    let senseKey = "sense"
    let glossKey = "gloss"
    
    func reEmitWordView(_ database:CBLDatabase){
        
        let wordView = database.viewNamed(JMDictViewName.KANJI_VIEW.rawValue)
        wordView?.setMapBlock({ (doc, emit) in
            
            var emitting_string = ""
            
            if doc?[self.kanji_element_key] != nil {
                
                if let d = ( doc! as [AnyHashable: Any] as NSDictionary ).object(forKey: self.kanji_element_key) as? NSArray {
                    var str_all = ""
                    for i in 0 ..< d.count  {
                        if ((d[i] as! NSDictionary)[self.kanji_entity] != nil) {
                            let str = (d[i] as! NSDictionary)[self.kanji_entity] as! String
                            str_all = str_all + " " + str
                            //emit(CBLTextKey(str),nil)
                            emit!(str,nil)
                        }
                    }
                    emitting_string = emitting_string + " " + str_all
                }
                else {
                    let d:NSDictionary = (doc! as [AnyHashable: Any] as NSDictionary).object(forKey: self.kanji_element_key) as! NSDictionary!
                    if (d[self.kanji_entity] != nil) {
                        let str = d[self.kanji_entity] as! String
                        //emit(CBLTextKey(str),nil)
                        emit!(str,nil)
                        emitting_string = emitting_string + " " + str
                    }
                }
                
            }
            
            //emit(CBLTextKey(emitting_string),nil)
            
        }, version: "2")
        

        let englishWordView = database.viewNamed(JMDictViewName.ENGLISH_VIEW.rawValue)
        englishWordView?.setMapBlock({ (doc, emit) in
            
            var emitting_string = ""
            
            var meaning = ""

            if let senses = Utility.getArrayForKey(doc! as [AnyHashable: Any] as NSDictionary, keyString: self.senseKey) {
                for i in 0 ..< senses.count  {
                    let dictionary = senses[i] as! NSDictionary

                    // Gloss Extraction
                    _ = Array<Dictionary<String,String>>()
                    if let glosses = Utility.getArrayForKey(dictionary, keyString: self.glossKey) {
                        for j in 0 ..< glosses.count  {
                            if let gloss = glosses[j] as? String {
                                //println("Eng : \(gloss)")
                                meaning = meaning + " | " + gloss
                                emit!(gloss,nil)
                            }
                        }
                    }
                    // End Gloss Extraction

                }

            }
            
            emitting_string = emitting_string + " " + meaning
            //println(emitting_string)
            //emit(CBLTextKey(emitting_string),nil)
            
        }, version: "2")
        
    }

    
}
