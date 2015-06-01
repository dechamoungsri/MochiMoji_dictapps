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
        
        var scrollviewDummy = UIScrollView(frame: CGRectMake(0, 0, screenWidth, screenHeight-80))
        
        japaneseEntityView = UIView.loadFromNibNamed("JapaneseEntityView")! as JapaneseEntityView
        scrollviewDummy.addSubview(japaneseEntityView)
        japaneseEntityView.frame.size.width = scrollviewDummy.frame.width
        japaneseEntityView.setData()

        var jap2 = UIView.loadFromNibNamed("JapaneseEntityView")! as JapaneseEntityView
        scrollviewDummy.addSubview(jap2)
        jap2.frame.size.width = scrollviewDummy.frame.width
        jap2.setData()
        jap2.layoutIfNeeded()
        jap2.frame = CGRectMake(0, japaneseEntityView.getHeight(), scrollviewDummy.frame.width, jap2.borderline.frame.origin.y + jap2.borderline.frame.height)
        jap2.layoutIfNeeded()
        
        scrollviewDummy.contentSize = CGSizeMake(screenWidth, japaneseEntityView.getHeight()*2)
        wordViewBody.addSubview(scrollviewDummy)
    }
    
    override func viewDidLayoutSubviews() {
        //scrollview.contentSize = CGSizeMake(wordViewBody.frame.width, 2000)
        //println("viewDidLayoutSubviews \(japaneseEntityView.frame)")
    }
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear \(japaneseEntityView.frame)")
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear \(japaneseEntityView.frame)")
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