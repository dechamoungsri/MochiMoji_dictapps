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
    let unique_id: Int
    
    init(){
        self.doc = nil
        self.unique_id = 0
    }
    
    init(row:CBLQueryRow){
        
        var doc = row.document
        
        self.doc = doc
        self.unique_id = ((doc.properties as NSDictionary).valueForKey("ent_seq") as String).toInt()!
        
    }
    
}