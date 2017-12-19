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
        
        let doc = entity.doc
        if doc == nil {
            return
        }
        
        self.document = doc!
        
        let unique:String = (self.document!.properties as NSDictionary).value(forKey: "ent_seq") as! String
        self.unique_id = Int(unique)!
        //println(unique)
        
        assignDictName()
        assignJapaneseEntity(self.document!)
        assignEnglishEntity(self.document!)
        assignReadingEntity(self.document!)
    }
    
    func assignDictName(){
        self.databaseName = DatabaseInterface.DatabaseName.jmdict
    }
    
    func assignReadingEntity(_ doc: CBLDocument){
        let r_ele_Key = "r_ele"
        if let d = Utility.getArrayForKey(doc.properties as NSDictionary, keyString: r_ele_Key) {
            for i in 0 ..< d.count  {
                readingEntityList.append(d[i] as! NSDictionary)
            }
        }
    }
    
    func assignJapaneseEntity(_ doc: CBLDocument) {
        let k_ele_Key = "k_ele"
        if let d = Utility.getArrayForKey(doc.properties as NSDictionary, keyString: k_ele_Key) {
            for i in 0 ..< d.count  {
                japaneseEntityList.append(d[i] as! NSDictionary)
            }
            self.japaneseEntity = jpListTojpString(self.japaneseEntityList)
            //println("Japanese Entity : \(self.japaneseEntity)")
        }
    }
    
    func assignEnglishEntity(_ doc: CBLDocument) {
        
        var englishList = [NSDictionary]()
        
        var meaningEntity = ""
        
        if let senses = Utility.getArrayForKey(doc.properties as NSDictionary, keyString: senseKey) {
            for i in 0 ..< senses.count  {
                let dictionary = senses[i] as! NSDictionary
                
                // Gloss Extraction
                var meaning_list = Array<Dictionary<String,String>>()
                if let glosses = Utility.getArrayForKey(dictionary, keyString: glossKey) {
                    for j in 0 ..< glosses.count  {
                        if let gloss = glosses[j] as? String {
                            //println("Eng : \(gloss)")
                            let dict = [languageKey: englishValue, meaningKey: gloss]
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
                    for j in 0  ..< poses.count  {
                        //println("Pos : \(poses[j])")
                        pos_list.append(poses[j] as! String)
                    }
                }
                // End Part of speech Extraction
                
                let sense_dictionary = NSMutableDictionary()
                sense_dictionary.setObject(meaning_list, forKey: glossKey as NSCopying)
                sense_dictionary.setObject(pos_list, forKey: posKey as NSCopying)
                englishList.append(sense_dictionary)
                
            }
            
            self.englishEntityList = englishList
            self.englishEntity = meaningEntity[Range( 0 ..< meaningEntity.length-2)]
            
        }
    }
    
    func jpListTojpString(_ jplist:[NSDictionary]) -> String{
        var out = ""
        for i in 0 ..< jplist.count  {
            if jplist[i].value(forKey: "keb") != nil {
                out = out + (jplist[i].value(forKey: "keb") as! String)
                if i != (jplist.count-1) {
                    out = out + ", "
                }
            }
        }
        return out
    }
    
    
    convenience init(row:CBLQueryRow){
        
        self.init()
        
        let doc = row.document
        if doc == nil {
            return
        }
        
        self.document = doc
        
        let unique:String = (doc!.properties as NSDictionary).value(forKey: "ent_seq") as! String
        self.unique_id = Int(unique)!
        //println(unique)
        
        assignDictName()
        assignJapaneseEntity(doc!)
        assignEnglishEntity(doc!)
        
    }
    
    
}
