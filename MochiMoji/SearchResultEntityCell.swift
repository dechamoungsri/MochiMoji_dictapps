//
//  SearchResultEntityCell.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/9/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import UIKit

class SearchResultEntityCell: UITableViewCell {

    enum CellEntityType {
        case NOUN
        case ADJECTIVE
        case VERB
        case ADVERB
        case OTHER
    }
    
    @IBOutlet weak var japaneseEntityLabel: UILabel!
    @IBOutlet weak var englishEntityLabel: UILabel!
    @IBOutlet weak var entityTypeLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var lastseenLabel: UILabel!
    
    func setComponentExample(dummy:String){
        japaneseEntityLabel.text = dummy
        englishEntityLabel.text = dummy
        readingLabel.text = dummy
        lastseenLabel.text = dummy
    }
    
}
