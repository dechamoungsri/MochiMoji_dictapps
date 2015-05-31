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
    
    @IBOutlet weak var heightDeterminer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(){
        japaneseEntity.text = "食べる食べる食べる食べる食べる食べる食べる食べる食べる食べる食べる"
        ui_romajiEntityLabel.text = "ta"
        self.layoutIfNeeded()
    }
    
    func setHeight(){
        resizeToFitSubviews(self)
    }
    
    func resizeToFitSubviews(view:UIView) {
        var h:CGFloat = 0
        if view.subviews.count == 0 {
            return
        }
        for var i = 0 ; i < view.subviews.count ; i++ {
            let v = view.subviews[i] as UIView
            var fh = v.frame.origin.y + v.frame.size.height
//            println("height : \(v.frame.origin.y) \(v.frame.size.height) \(v.tag)")
//            println("Max height : \(fh) \(h)")
            h = max(fh, h)
            
        }
        println(h)
        view.frame = CGRectMake(0, 0, view.frame.width, h)
    }
    
}