//
//  JMDictEntity.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/12/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class JMDictEntity: Entity {
    
    var japaneseEntityList = [NSDictionary]()
    var englishEntityList = [NSDictionary]() //Sense List
    var readingEntityList = [NSDictionary]()
    var document: CBLDocument?
    var unique_id: Int = 0
    
    enum KEY: String {
        case senseKey = "sense"
        case glossKey = "gloss"
        case posKey = "pos"
        case languageKey = "language"
        case meaningKey = "meaning"
        case englishValue = "eng"
    }
    
    var senseKey = KEY.senseKey.rawValue
    var glossKey = KEY.glossKey.rawValue
    var posKey = KEY.posKey.rawValue
    var languageKey = KEY.languageKey.rawValue
    var meaningKey = KEY.meaningKey.rawValue
    var englishValue = KEY.englishValue.rawValue
    
    override init(){
        self.document = nil
        super.init()
    }

    convenience init(entity:DummyEntity){
        self.init()
        
        var doc = entity.doc
        if doc == nil {
            return
        }
        
        self.document = doc!
        
        var unique:String = (self.document!.properties as NSDictionary).valueForKey("ent_seq") as! String
        self.unique_id = unique.toInt()!
        //println(unique)
        
        assignDictName()
        assignJapaneseEntity(self.document!)
        assignEnglishEntity(self.document!)
        assignReadingEntity(self.document!)
    }
    
    func assignDictName(){
        self.databaseName = DatabaseInterface.DatabaseName.JMDICT
    }
    
    func assignReadingEntity(doc: CBLDocument){
        var r_ele_Key = "r_ele"
        if let d = Utility.getArrayForKey(doc.properties, keyString: r_ele_Key) {
            for var i = 0; i < d.count ; i++ {
                readingEntityList.append(d[i] as! NSDictionary)
            }
        }
    }
    
    func assignJapaneseEntity(doc: CBLDocument) {
        var k_ele_Key = "k_ele"
        if let d = Utility.getArrayForKey(doc.properties, keyString: k_ele_Key) {
            for var i = 0; i < d.count ; i++ {
                japaneseEntityList.append(d[i] as! NSDictionary)
            }
            self.japaneseEntity = jpListTojpString(self.japaneseEntityList)
            //println("Japanese Entity : \(self.japaneseEntity)")
        }
    }
    
    func assignEnglishEntity(doc: CBLDocument) {
        
        var englishList = [NSDictionary]()
        
        var meaningEntity = ""
        
        if let senses = Utility.getArrayForKey(doc.properties, keyString: senseKey) {
            for var i = 0; i < senses.count ; i++ {
                let dictionary = senses[i] as! NSDictionary
                
                // Gloss Extraction
                var meaning_list = Array<Dictionary<String,String>>()
                if let glosses = Utility.getArrayForKey(dictionary, keyString: glossKey) {
                    for var j = 0; j < glosses.count ; j++ {
                        if let gloss = glosses[j] as? String {
                            //println("Eng : \(gloss)")
                            var dict = [languageKey: englishValue, meaningKey: gloss]
                            meaning_list.append(dict)
                            meaningEntity += gloss + ", "
                        }
//                        // Other language
//                        else if let gloss = glosses[j] as? NSDictionary {
//                            var lang = gloss.valueForKey("-xml:lang") as? String
//                            var meaning = gloss.valueForKey("#text") as? String
//                            println("\(lang!) : \(meaning!)")
//                        }
                    }
                }
                // End Gloss Extraction
                
                // Part of speech Extraction
                var pos_list = [String]()
                if let poses = Utility.getArrayForKey(dictionary, keyString: posKey) {
                    for var j = 0 ; j < poses.count ; j++ {
                        //println("Pos : \(poses[j])")
                        pos_list.append(poses[j] as! String)
                    }
                }
                // End Part of speech Extraction
                
                var sense_dictionary = NSMutableDictionary()
                sense_dictionary.setObject(meaning_list, forKey: glossKey)
                sense_dictionary.setObject(pos_list, forKey: posKey)
                englishList.append(sense_dictionary)
                
            }
            
            self.englishEntityList = englishList
            self.englishEntity = meaningEntity[Range(start: 0,end: meaningEntity.length-2)]
            
        }
    }
    
    func jpListTojpString(jplist:[NSDictionary]) -> String{
        var out = ""
        for var i=0; i < jplist.count ; i++ {
            if jplist[i].valueForKey("keb") != nil {
                out = out + (jplist[i].valueForKey("keb") as! String)
                if i != (jplist.count-1) {
                    out = out + ", "
                }
            }
        }
        return out
    }
    
    
    convenience init(row:CBLQueryRow){
        
        self.init()
        
        var doc = row.document
        if doc == nil {
            return
        }
        
        self.document = doc
        
        var unique:String = (doc.properties as NSDictionary).valueForKey("ent_seq") as! String
        self.unique_id = unique.toInt()!
        //println(unique)
        
        assignDictName()
        assignJapaneseEntity(doc)
        assignEnglishEntity(doc)
        
    }
    
    
}