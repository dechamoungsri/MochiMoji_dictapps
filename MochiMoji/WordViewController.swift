//
//  WordViewController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 5/8/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class WordViewController: UIViewController {
    
    @IBOutlet weak var wordViewBody: UIView!
    
    var japaneseEntityView: JapaneseEntityView!
    
    var screenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    var screenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        
        let stackSize = self.navigationController?.viewControllers.count
        println("Stack Size : \(stackSize)")
        
        japaneseEntityView = UIView.loadFromNibNamed("JapaneseEntityView")! as JapaneseEntityView
        
        japaneseEntityView.frame = CGRectMake(0, 0, wordViewBody.frame.width, 1000)
        japaneseEntityView.setData()
        //japaneseEntityView.frame = CGRectMake(0, 0, wordViewBody.frame.width, japaneseEntityView.heightDeterminer.frame.height + japaneseEntityView.heightDeterminer.frame.origin.y)
        japaneseEntityView.frame = CGRectMake(0, 0, wordViewBody.frame.width, 5)
        //japaneseEntityView.frame = CGRectMake(0, 0, wordViewBody.frame.width, 60)
        japaneseEntityView.layoutIfNeeded()
        
        println("\(screenWidth) \(screenHeight)")
        
        println(japaneseEntityView.frame)
        println(japaneseEntityView.borderline.frame)
        println(japaneseEntityView.heightDeterminer.frame)
        
        wordViewBody.addSubview(japaneseEntityView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        println("\(screenWidth) \(screenHeight)")
        
        println(japaneseEntityView.frame)
        println(japaneseEntityView.borderline.frame)
        println(japaneseEntityView.heightDeterminer.frame)
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        println("backButtonPressed")
        self.navigationController?.popViewControllerAnimated(false)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        println("prepareForSegue backButtonPressed")
//    }
    
//    -(void)resizeToFitSubviews
//    {
//    float w = 0;
//    float h = 0;
//    
//    for (UIView *v in [self subviews]) {
//    float fw = v.frame.origin.x + v.frame.size.width;
//    float fh = v.frame.origin.y + v.frame.size.height;
//    w = MAX(fw, w);
//    h = MAX(fh, h);
//    }
//    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
//    }

    
}