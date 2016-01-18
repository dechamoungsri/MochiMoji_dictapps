//
//  JapaneseEntityView.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 5/31/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class JapaneseEntityView : UIView {
    
    @IBOutlet weak var japaneseEntity: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var romajiContainerView: UIView!
    
    @IBOutlet weak var ui_romajiEntityLabel: UILabel!
    
    @IBOutlet weak var borderline: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(entity:Entity){
        
        // TODO: Cast to JMDict
        let jmDict = entity as! JMDictEntity
        
        // FIXME: Correct it
        japaneseEntity.text = jmDict.japaneseEntity
        ui_romajiEntityLabel.text = ((jmDict.readingEntityList[0] as NSDictionary)["reb"] as! String)
        self.layoutIfNeeded()
    }
    
    func getHeight() -> CGFloat{
        return borderline.frame.origin.y + borderline.frame.height
    }
    
}