//
//  DummyEntity.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/24/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation


func == (lhs: DummyEntity, rhs: DummyEntity) -> Bool {
    return lhs.unique == rhs.unique
}

class DummyEntity: Equatable {
    
    let doc:CBLDocument?
    let frequency: Int
    let unique: Int
    let databaseName:DatabaseInterface.DatabaseName
    
    var isShow = false

    init(){
        self.doc = nil
        self.frequency = 0
        self.unique = 0
        self.databaseName = DatabaseInterface.DatabaseName.jmdict
    }
    
    init(row:CBLQueryRow, dbName:DatabaseInterface.DatabaseName){
        
        let doc = row.document
        //ent_seq
        self.doc = doc
        //self.unique = 0
        self.unique = Int(((doc?.properties)?["ent_seq"] as! String))!
        
        self.frequency = ((doc?.properties["frequency"]) as! Int)
        
        self.databaseName = dbName
    }
    
    func showed() {
        isShow = true
    }
    
}
