//
//  MeaningTableSectionCell.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 6/12/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class MeaningTableSectionCell: UIView {
    
    @IBOutlet weak var partOfSpeechLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}