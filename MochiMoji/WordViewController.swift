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
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var scrollViewContainer: UIView!
    
    var japaneseEntityView: JapaneseEntityView!
    
    var screenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    var screenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        
        let stackSize = self.navigationController?.viewControllers.count
        println("Stack Size : \(stackSize)")
        
        var v1 = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight*2))
        v1.backgroundColor = UIColor.redColor()
        var v2 = UIView(frame: CGRectMake(0, screenHeight, screenWidth, screenHeight*2))
        v2.backgroundColor = UIColor.blueColor()

        
//        scrollview.contentSize = CGSizeMake(screenWidth, screenHeight*3)
//        scrollview.addSubview(v1)
//        scrollview.addSubview(v2)
        
        japaneseEntityView = UIView.loadFromNibNamed("JapaneseEntityView")! as JapaneseEntityView
        
        //japaneseEntityView.frame = CGRectMake(0, 0, wordViewBody.frame.width, 1000)
        
        wordViewBody.addSubview(japaneseEntityView)
        
        japaneseEntityView.frame.size.width = wordViewBody.frame.width
        japaneseEntityView.setData()
        
//        japaneseEntityView.frame = CGRectMake(0, 0, wordViewBody.frame.width, japaneseEntityView.borderline.frame.origin.y + japaneseEntityView.borderline.frame.height)
//        japaneseEntityView.layoutIfNeeded()
//        
//        println("\(screenWidth) \(screenHeight)")
//        
//        println("viewDidLoad \(japaneseEntityView.frame)")
//        println(japaneseEntityView.frame)
//        println(japaneseEntityView.borderline.frame)
        //println(japaneseEntityView.heightDeterminer.frame)
        
        var jap2 = UIView.loadFromNibNamed("JapaneseEntityView")! as JapaneseEntityView
        wordViewBody.addSubview(jap2)
        jap2.frame.size.width = wordViewBody.frame.width
        jap2.setData()
        jap2.layoutIfNeeded()
        jap2.frame = CGRectMake(0, japaneseEntityView.borderline.frame.origin.y + japaneseEntityView.borderline.frame.height, wordViewBody.frame.width, jap2.borderline.frame.origin.y + jap2.borderline.frame.height)
        jap2.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
//        println("\(screenWidth) \(screenHeight)")
//        
        println("viewWillAppear \(japaneseEntityView.frame)")
//        println(japaneseEntityView.borderline.frame)
        //println(japaneseEntityView.heightDeterminer.frame)
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear \(japaneseEntityView.frame)")
        
//        japaneseEntityView.frame = CGRectMake(0, 0, wordViewBody.frame.width, 300)
//        japaneseEntityView.layoutIfNeeded()

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