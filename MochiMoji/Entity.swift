//
//  Entity.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/10/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}

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
        self.databaseName = DatabaseInterface.DatabaseName.JMDICT
        self.tableCellEntityType = SearchResultEntityCell.CellEntityType.OTHER
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