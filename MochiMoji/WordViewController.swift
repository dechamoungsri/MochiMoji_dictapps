//
//  WordViewController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 5/8/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class WordViewController: UIViewController {
    
    let debug = true
    let filename = "WordViewController"
    
    @IBOutlet weak var wordViewBody: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var scrollViewContainer: UIView!
    
    var entityObject:Entity!
    
    var japaneseEntityView: JapaneseEntityView!
    var meaningEntityView: MeaningEntityView!
    
    var screenWidth:CGFloat = UIScreen.main.bounds.size.width
    var screenHeight:CGFloat = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        
        let functionName = "viewDidLoad"
        
        // TODO: Assume it is JMDict
        let jmDict = entityObject as! JMDictEntity
        Utility.debug_println(debug, swift_file: filename, function: functionName, text: "Id : \(jmDict.unique_id)")
        
        let stackSize = self.navigationController?.viewControllers.count
        print("Stack Size : \(stackSize)")
        
        let scrollviewDummy = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-80))
        
        japaneseEntityView = UIView.loadFromNibNamed("JapaneseEntityView") as! JapaneseEntityView
        scrollviewDummy.addSubview(japaneseEntityView)
        japaneseEntityView.frame.size.width = scrollviewDummy.frame.width
        japaneseEntityView.setData(jmDict)

        meaningEntityView = UIView.loadFromNibNamed("MeaningEntityView") as! MeaningEntityView
        meaningEntityView.loadTable()
        meaningEntityView.setData(jmDict)
        scrollviewDummy.addSubview(meaningEntityView)
        meaningEntityView.frame.size.width = scrollviewDummy.frame.width
        meaningEntityView.layoutIfNeeded()
        
        meaningEntityView.frame = CGRect(x: 0, y: japaneseEntityView.getHeight(), width: scrollviewDummy.frame.width, height: meaningEntityView.getHeight())
        meaningEntityView.layoutIfNeeded()
        
        scrollviewDummy.contentSize = CGSize(width: screenWidth,
                height: japaneseEntityView.getHeight() +
                meaningEntityView.getHeight())
        wordViewBody.addSubview(scrollviewDummy)
        
//        var controller = self.navigationController!.viewControllers[stackSize!-2] as! MainPageController
//        var tempArchiveView = NSKeyedArchiver.archivedDataWithRootObject(controller.tableView)
//        var viewOfSelf = NSKeyedUnarchiver.unarchiveObjectWithData(tempArchiveView) as! UITableView
//        self.view.addSubview(viewOfSelf)
        
    }
    
    override func viewDidLayoutSubviews() {
        //scrollview.contentSize = CGSizeMake(wordViewBody.frame.width, 2000)
        //println("viewDidLayoutSubviews \(japaneseEntityView.frame)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //println("viewWillAppear \(japaneseEntityView.frame)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //println("viewDidAppear \(japaneseEntityView.frame)")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: false)
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
