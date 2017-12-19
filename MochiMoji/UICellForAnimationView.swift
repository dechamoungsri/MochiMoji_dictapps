//
//  CellForAnimation.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 5/10/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class UICellForAnimationView : UIView {

    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var japaneseEntity: UILabel!
    @IBOutlet weak var readingEntity: UILabel!
    @IBOutlet weak var englishEntity: UILabel!
    @IBOutlet weak var pos1: UILabel!
    @IBOutlet weak var pos2: UILabel!
    @IBOutlet weak var pos3: UILabel!
    @IBOutlet weak var pos4: UILabel!
    
    var targetCell:SearchResultEntityCell?
    var rectWhenReturn:CGRect?
    var indexPath:IndexPath?
    
//    init(tableCell:SearchResultEntityCell){
//        super.init()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
