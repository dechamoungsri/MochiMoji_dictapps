//
//  DummyEntity.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/24/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class DummyEntity {
    
    let doc:CBLDocument?
    let frequency: Int
    let databaseName:DatabaseInterface.DatabaseName
    
    init(){
        self.doc = nil
        self.frequency = 0
        self.databaseName = DatabaseInterface.DatabaseName.JMDICT
    }
    
    init(row:CBLQueryRow, dbName:DatabaseInterface.DatabaseName){
        
        var doc = row.document
        
        self.doc = doc
        self.frequency = ((doc.properties as NSDictionary).valueForKey("frequency") as Int)
        self.databaseName = dbName
    }
    
}