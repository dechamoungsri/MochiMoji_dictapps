//
//  Entity.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/10/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

//extension Date
//{
//    init(dateString:String) {
//        let dateStringFormatter = DateFormatter()
//        dateStringFormatter.dateFormat = "yyyy-MM-dd"
//        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
//        let d = dateStringFormatter.date(from: dateString)
////        (self as NSDate).type(of:init)(timeInterval:0, since:d!)
//        
//    }
//}

class Entity {
    
    var japaneseEntity:String
    var englishEntity:String
    var readingEntity:String
    var databaseName:DatabaseInterface.DatabaseName
    var tableCellEntityType:SearchResultEntityCell.CellEntityType
    var lastseen:String
    
    init(){
        self.japaneseEntity = ""
        self.englishEntity = ""
        self.readingEntity = ""
        self.databaseName = DatabaseInterface.DatabaseName.jmdict
        self.tableCellEntityType = SearchResultEntityCell.CellEntityType.other
        self.lastseen = ""//NSDate(dateString:"2015-04-01")
    }
    
    init(jpEntity:String, engEntity:String, dbName:DatabaseInterface.DatabaseName, cellEntityType:SearchResultEntityCell.CellEntityType, last_seen:String){
        self.japaneseEntity = jpEntity;
        self.englishEntity = engEntity;
        self.readingEntity = ""
        self.databaseName = dbName
        self.tableCellEntityType = cellEntityType
        self.lastseen = last_seen
    }
}
