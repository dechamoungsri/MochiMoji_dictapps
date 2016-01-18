//
//  SearchResultEntityCell.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/9/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import UIKit

class SearchResultEntityCell: UITableViewCell {

    struct COLOR {
        static let selectedColor = Utility.colorWithHexString("81D4FA")
        static let defaultColor = Utility.colorWithHexString("FAFAFA")
    }
    
    enum CellEntityType {
        case NOUN
        case ADJECTIVE
        case VERB
        case ADVERB
        case OTHER
    }
    
    struct PART_OF_SPEECH_INFO {
        static let Noun = "Noun"
        static let Verb = "Verb"
        static let Adjective = "Adjective"
        static let Adverb = "Adverb"
        static let Other = "Other"
        static let Etc = "Etc"
        static let Pos_JMDict = [
            "n" : PART_OF_SPEECH_INFO.Noun,
            "v" : PART_OF_SPEECH_INFO.Verb,
            "adj" : PART_OF_SPEECH_INFO.Adjective ,
            "adv" : PART_OF_SPEECH_INFO.Adverb
        ]
        static let Pos_List = [
            "n", "v", "adj", "adv"
        ]
        
    }

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var dummyView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    var entity:Entity?
    
    @IBOutlet weak var japaneseEntityLabel: UILabel!
    @IBOutlet weak var englishEntityLabel: UILabel!
    @IBOutlet weak var entityTypeLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var lastseenLabel: UILabel!
    
    @IBOutlet weak var pos1: UILabel!
    @IBOutlet weak var pos2: UILabel!
    @IBOutlet weak var pos3: UILabel!
    @IBOutlet weak var pos4: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let view = UIView()
        view.backgroundColor = COLOR.defaultColor
        self.backgroundView = view
    }
    
    func setComponentExample(dummy:String){
        japaneseEntityLabel.text = dummy
        englishEntityLabel.text = dummy
        readingLabel.text = dummy
        lastseenLabel.text = dummy
    }
    
    func setComponentFromEntity(entity:Entity, text:String){
        japaneseEntityLabel.text = ""
        englishEntityLabel.text = ""
        readingLabel.text = ""
        lastseenLabel.text = ""
        switch entity.databaseName {
        case DatabaseInterface.DatabaseName.JMDICT:
            cellEntityFromJMDict(entity as! JMDictEntity,text: text)
        default:
            return
        }

    }
    
    func cellEntityFromDummyEntity(entity:DummyEntity, text:String){
        japaneseEntityLabel.text = ""
        englishEntityLabel.text = ""
        readingLabel.text = ""
        lastseenLabel.text = ""
        self.entity = JMDictEntity(entity: entity)
        cellEntityFromJMDict(self.entity as! JMDictEntity, text: text)
    }
    
    func cellEntityFromJMDict(entity:JMDictEntity, text:String){
        
        assignJapaneseEntityFromJMDict(entity, text: text)
        englishEntityLabel.text = entity.englishEntity
        assignPartOfSpeechFromJMDict(entity)
        assignReadingFromJMDict(entity)
        
    }
    
    func assignReadingFromJMDict(entity:JMDictEntity){
        var read_out = ""
        var readingList = entity.readingEntityList
        for var i = 0 ; i < readingList.count ; i++ {
            let read = (readingList[i] as NSDictionary)
            let str = read["reb"] as! String
            read_out = read_out + str
            if i != (readingList.count-1) {
                read_out = read_out + ", "
            }
        }
        
        self.readingLabel.text = read_out
        
    }
    
    func assignPartOfSpeechFromJMDict(entity:JMDictEntity){
        var pos_list = [String]()
        var senses = entity.englishEntityList
        for var i = 0; i < senses.count ; i++ {
            var pos = senses[i][JMDictEntity.KEY.posKey.rawValue] as! [String]
            for var j = 0; j < pos.count ; j++ {
                
                var pos_array_list = PART_OF_SPEECH_INFO.Pos_List
                
                var pos_other = PART_OF_SPEECH_INFO.Other
                
                for var k = 0 ; k < pos_array_list.count ; k++ {
                    if Utility.hasPrefix(pos[j], prefix: pos_array_list[k]) {
                        pos_other = PART_OF_SPEECH_INFO.Pos_JMDict[pos_array_list[k]]!
                        break
                    }
                }
                
                if !pos_list.contains(pos_other) {
                    pos_list.append(pos_other)
                    
                }
                
            }
        }
        
        
        if (pos_list.count > 4) {
            pos_list[2] = PART_OF_SPEECH_INFO.Etc
            settingWordTypeLabel(pos_list,count: 4)
        }
        else {
            //println(pos_list)
            settingWordTypeLabel(pos_list,count: pos_list.count)
        }
        
        
    }
    
    func settingWordTypeLabel(pos_list:[String], count:Int){
        var labels = [pos1,pos2,pos3,pos4]
        for var i = 0 ; i < labels.count ; i++ {
            labels[i].hidden = true
        }
        
        for var i = 0 ; i < count ; i++ {
            setPartOfSpeechLabel(labels[i], pos: pos_list[i])
        }
    }
    
    func setPartOfSpeechLabel(label:UILabel, pos:String){
        
        var titleDictionary = [
            PART_OF_SPEECH_INFO.Noun : "Noun",
            PART_OF_SPEECH_INFO.Verb : "Verb",
            PART_OF_SPEECH_INFO.Adjective : "Adj.",
            PART_OF_SPEECH_INFO.Adverb : "Adv",
        ]
        
        switch pos {
        case PART_OF_SPEECH_INFO.Noun:
            label.backgroundColor = Utility.colorWithHexString("#66BB6A")
        case PART_OF_SPEECH_INFO.Verb:
            label.backgroundColor = Utility.colorWithHexString("#5C6BC0")
        case PART_OF_SPEECH_INFO.Adjective:
            label.backgroundColor = Utility.colorWithHexString("#EF5350")
        default:
            label.backgroundColor = Utility.colorWithHexString("#000000")
        }
        
        label.text = titleDictionary[pos]
        label.hidden = false
    }
    
    func assignJapaneseEntityFromJMDict(entity:JMDictEntity, text:String) {
        
        for var i = 0; i < entity.japaneseEntityList.count ; i++ {
            let kanji = entity.japaneseEntityList[i]["keb"] as! String
            
            if i == 0 {
                japaneseEntityLabel.text = kanji
            }
            
            if let hasPrefix = kanji.hasPrefix(text) as Bool? {
                if hasPrefix {
                    japaneseEntityLabel.text = entity.japaneseEntityList[i]["keb"] as? String
                    return
                }
            }
        }
    }
    
    
}
