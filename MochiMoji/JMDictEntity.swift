//
//  JMDictEntity.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/12/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}

class JMDictEntity: Entity {
    
    var japaneseEntityList = [NSDictionary]()
    var englishEntityList = [NSDictionary]()
    
    override init(){
        super.init()
    }
    
    convenience init(row:CBLQueryRow){
        
        self.init()
        
        var doc = row.document
        if doc == nil {
            return
        }
        
        var unique:String = (doc.properties as NSDictionary).valueForKey("ent_seq") as String
        //println(unique)
        
        assignJapaneseEntity(doc)
        assignEnglishEntity(doc)
        
    }
    
    func assignJapaneseEntity(doc: CBLDocument) {
        var k_ele_Key = "k_ele"
        if let d = Utility.getArrayForKey(doc.properties, keyString: k_ele_Key) {
            for var i = 0; i < d.count ; i++ {
                japaneseEntityList.append(d[i] as NSDictionary)
            }
            self.japaneseEntity = jpListTojpString(self.japaneseEntityList)
            //println("Japanese Entity : \(self.japaneseEntity)")
        }
    }
    
    func assignEnglishEntity(doc: CBLDocument) {
        var senseKey = "sense"
        var glossKey = "gloss"
        var posKey = "pos"
        var languageKey = "language"
        var meaningKey = "meaning"
        
        var englishList = [NSDictionary]()
        
        var meaningEntity = ""
        
        if let senses = Utility.getArrayForKey(doc.properties, keyString: senseKey) {
            for var i = 0; i < senses.count ; i++ {
                let dictionary = senses[i] as NSDictionary
                
                // Gloss Extraction
                var meaning_list = Array<Dictionary<String,String>>()
                if let glosses = Utility.getArrayForKey(dictionary, keyString: glossKey) {
                    for var j = 0; j < glosses.count ; j++ {
                        if let gloss = glosses[j] as? String {
                            //println("Eng : \(gloss)")
                            var dict = [languageKey: "eng", meaningKey: gloss]
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
                        pos_list.append(poses[j] as String)
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
                out = out + (jplist[i].valueForKey("keb") as String)
                if i != (jplist.count-1) {
                    out = out + ", "
                }
            }
        }
        return out
    }
    
}