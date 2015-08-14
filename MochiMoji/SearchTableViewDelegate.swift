//
//  SearchTableView.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 7/8/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class SearchTableViewDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {

    var mainController:MainPageController?
    
    override init() {
        self.mainController = nil
    }
    
    convenience init(mainController:MainPageController) {
        self.init()
        self.mainController = mainController
    }
    
    // MARK: - UITableView
    // ============================= Start Table Sectionnnnnnnnn ============================= //
    
    // TODO: OnClick Cell is here
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        println("didSelectRowAtIndexPath \(row)")
        
        if mainController?.animationCell != nil {
            
            if mainController?.animationCell?.hidden == true {
                
                mainController!.searchTextField.resignFirstResponder()
                mainController!.dummyCell_animator.removeAllBehaviors()
                
                wordControllerAnimation(tableView.cellForRowAtIndexPath(indexPath) as! SearchResultEntityCell, indexPath:indexPath)
            }
        }
        else {
            mainController!.searchTextField.resignFirstResponder()
            mainController!.dummyCell_animator.removeAllBehaviors()
            
            wordControllerAnimation(tableView.cellForRowAtIndexPath(indexPath) as! SearchResultEntityCell, indexPath:indexPath)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("numberOfRowsInSection")
        return self.mainController!.cellsEntity.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 72
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //println("cellForRowAtIndexPath \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(mainController!.entityCellIdentifier, forIndexPath: indexPath) as! SearchResultEntityCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.dummyView.alpha = 1
        let row = indexPath.row
        cell.cellEntityFromDummyEntity(self.mainController!.cellsEntity[row], text: mainController!.searchTextField.text)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row

        var frame = mainController!.tableViewContainer.frame
        var cell_height = cell.frame.height

        var lastFirstShowedCell:Int = Int( frame.size.height / cell_height ) + 1

        if !self.mainController!.cellsEntity[row].isShow {
            var animatedTarget = (cell as! SearchResultEntityCell).dummyView
            var shadow = (cell as! SearchResultEntityCell).shadowView
            animatedTarget.transform = CGAffineTransformMakeScale(1.0, 0.001)
            shadow.alpha = 0.0
            
            if row < lastFirstShowedCell {
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64( getDelay() * cellDelayTime * Double(NSEC_PER_SEC)))
                
                pushDelayStack()
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.setCellScaleY(animatedTarget,scaleTo: 1.0)
                    
                    UIView.animateWithDuration(0.3, animations: {
                        shadow.alpha = 0.0
                        }, completion: nil)
                    
                }
                
            }
            else {
                self.setCellScaleY(animatedTarget,scaleTo: 1.0)
                UIView.animateWithDuration(0.3, animations: {
                    shadow.alpha = 0.0
                    }, completion: nil)
                //self.fadeToComponent(animatedTarget, fadeTo: 1.0)
            }
            
            self.mainController!.cellsEntity[row].showed()
            
        }
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchResultEntityCell
        cell.viewContainer.backgroundColor = SearchResultEntityCell.COLOR.selectedColor
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchResultEntityCell
        cell.viewContainer.backgroundColor = SearchResultEntityCell.COLOR.defaultColor
    }
    
    var stack:Double = 0.0
    let cellDelayTime:Double = 0.075
    func getDelay() -> Double {
        return stack
    }
    
    func pushDelayStack() {
        stack+=1
    }
    
    func popDelayStack() {
        stack-=1
        if stack < 0 {
            stack = 0
        }
    }
    
    // MARK: - Table Scroll Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // TODO: Fix bug scroll
        // Bug description
        //      If query result is zero, it will call scroll. Then it automatically resign.
        
        //println("scroll")
        mainController!.searchTextField.resignFirstResponder()
        if mainController?.animationCell != nil {
            if mainController?.animationCell!.indexPath != nil {
                var row = mainController!.tableView.cellForRowAtIndexPath(mainController!.animationCell!.indexPath!)
                if row != nil {
                    var cellRectInTable = mainController!.tableView.convertRect(row!.frame, toView: mainController!.tableView.superview)
                    cellRectInTable.origin.y = cellRectInTable.origin.y + mainController!.topview.frame.height
                    //println("Scrolling :\(cellRectInTable)")
                    
                    var rowFrameSizeAnimation = AnimationFactory.frameSizeAnimationFactory(
                        "FrameSizeAnimation",
                        toValue: NSValue(CGRect: cellRectInTable),
                        animatedTarget:mainController!.animationCell! ,
                        bounce: 2,
                        speed: 10)
                    
                }
            }
        }
        
    }
    
    // MARK: - Table Cell Animation Factory
    
    func setCellScaleY(component:UIView, scaleTo:CGFloat){
        var scaleAnimation = AnimationFactory.scaleYAnimaionFactory("scaleYAnimation", toValue:scaleTo, animatedTarget: component)
        scaleAnimation.completionBlock = {(animation, finished) in
            self.popDelayStack()
        }
        component.pop_addAnimation(scaleAnimation, forKey: "scaleYAnimation")
    }
    
    // ----------------------------- End Table Sectionnnnnnnnn ----------------------------- //

    
    // MARK: - Word Controller Push
    
    func wordControllerAnimation(row:SearchResultEntityCell, indexPath: NSIndexPath){
        
        // Param:
        //      row is the selected row
        
        var bounce = CGFloat(5.0)
        var speed = CGFloat(10.0)
        
        // Cell enlarge Animation
        let cellFrame = mainController!.tableView.rectForRowAtIndexPath(indexPath) // Selected row
        var cellRectInTable = mainController!.tableView.convertRect(cellFrame, toView: mainController!.tableView.superview)
        
        cellRectInTable.origin.y = cellRectInTable.origin.y + mainController!.topview.frame.height
        
        if mainController!.animationCell == nil {
            mainController!.animationCell = UIView.loadFromNibNamed("TableCellForAnimationView") as? UICellForAnimationView
            //mainController!.animationCell?.topbar.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        mainController!.animationCell?.frame = cellRectInTable
        mainController!.animationCell?.hidden = false
        //mainController!.animationCell?.layer.zPosition = CGFloat(MAXFLOAT);
        mainController!.animationCell!.alpha = 1.0
        
        // Enlarge Animation Cell
        var rowFrameSizeAnimation = AnimationFactory.frameSizeAnimationFactory(
            "FrameSizeAnimation",
            toValue: NSValue(
                CGRect: CGRectMake(
                    0,
                    0,
                    mainController!.screenWidth,
                    mainController!.screenHeight
                )
            ),
            animatedTarget:mainController!.animationCell! ,
            bounce: bounce,
            speed: speed)
        
        rowFrameSizeAnimation.completionBlock = {(animation, finished) in
            var controller = self.mainController!.storyboard?.instantiateViewControllerWithIdentifier("WordViewController") as! WordViewController
            controller.entityObject = JMDictEntity(entity: self.mainController!.cellsEntity[indexPath.row])
            self.mainController!.navigationController?.pushViewController(controller, animated: false)
        }
        
        mainController!.animationCell?.pop_addAnimation(rowFrameSizeAnimation, forKey: "FrameSizeAnimation")
        
        // Alpha for dummy top view
        UIView.animateWithDuration(0.1, animations: {

            self.mainController!.animationCell!.topbar.alpha = 1.0
            
        }, completion: nil)
        
        mainController?.animationCell?.targetCell = row
        mainController?.animationCell?.rectWhenReturn = cellRectInTable
        mainController?.animationCell?.indexPath = indexPath
        
        mainController!.cellAnimatingView.addSubview(mainController!.animationCell!)
        
        onCallToOtherView()
        
        row.dummyView.alpha = 0
        
        // Just in case
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.mainController!.animationCell?.hidden = true
        }
        
    }
    
    // MARK: Top view of search page controller
    func onCallToOtherView(){
        //mainController?.maskView.hidden = false
        // Top View hide
        var scaleTopViewAnimation = AnimationFactory.scaleYAnimaionFactory("scaleTopViewAnimation", toValue: 0.0, animatedTarget: mainController!.topview_dummy)
        scaleTopViewAnimation.completionBlock = {
            (animation, finished) in
            self.mainController!.topBarIsHide = true
        }
        mainController!.topview_dummy.pop_addAnimation(scaleTopViewAnimation, forKey: "scaleTopViewAnimation")
        
    }
    
    func onBackToMainView(){
        
        var scaleTopViewAnimation = AnimationFactory.scaleYAnimaionFactory("scaleTopViewAnimation", toValue: 1.0, animatedTarget: mainController!.topview_dummy)
        scaleTopViewAnimation.completionBlock = {
            (animation, finished) in
            self.mainController!.topBarIsHide = false
        }
        mainController!.topview_dummy.pop_addAnimation(scaleTopViewAnimation, forKey: "scaleTopViewAnimation")

        if mainController!.animationCell != nil {
            
            mainController!.animationCell?.hidden = false
            
            var rowFrameSizeAnimation = AnimationFactory.frameSizeAnimationFactory(
                "FrameSizeAnimation",
                toValue: NSValue(CGRect: mainController!.animationCell!.rectWhenReturn!),
                animatedTarget:mainController!.animationCell! ,
                bounce: 2,
                speed: 10)
            rowFrameSizeAnimation.completionBlock = {
                (animation, finished) in
                UIView.animateWithDuration(0.1, animations: {
                    // Animation Go here
                    self.mainController?.animationCell?.alpha = 0
                    self.mainController?.animationCell?.targetCell?.dummyView.alpha = 1
                    }, completion: { (complete: Bool) in
                        // complete go here
                        self.mainController!.animationCell?.hidden = true
                        self.mainController!.animationCell?.indexPath = nil
                        //self.mainController?.maskView.hidden = true
                })
                
            }
            mainController!.animationCell?.pop_addAnimation(rowFrameSizeAnimation, forKey: "FrameSizeAnimation")
            
            UIView.animateWithDuration(0.2, animations: {
                // Animation Go here
                mainController?.animationCell?.topbar.alpha = 0
                }, completion: { (complete: Bool) in
                    // complete go here
            })
            
            // Just in case
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.mainController!.animationCell?.hidden = true
            }
            
        }
    }
}