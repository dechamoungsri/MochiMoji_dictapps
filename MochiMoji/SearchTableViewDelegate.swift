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
        mainController!.searchTextField.resignFirstResponder()
        mainController!.dummyCell_animator.removeAllBehaviors()
        mainController!.wordControllerAnimation(tableView.cellForRowAtIndexPath(indexPath) as! SearchResultEntityCell, indexPath:indexPath)
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(mainController!.entityCellIdentifier, forIndexPath: indexPath) as! SearchResultEntityCell
        
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
        mainController!.searchTextField.resignFirstResponder()
    }
    
    // MARK: - Table Cell Animation Factory
    
    func setCellScaleY(component:UIView, scaleTo:CGFloat){
        var scaleAnimation = AnimationFactory.scaleYAnimaionFactory("scaleYAnimation", toValue:scaleTo, animatedTarget: component)
        scaleAnimation.completionBlock = {(animation, finished) in
            self.popDelayStack()
        }
        component.pop_addAnimation(scaleAnimation, forKey: "scaleYAnimation")
    }
    
    func setCellHeight(component:UIView, sizeTo:CGFloat){
        var heightAnimation = setHeightAnimaionFactory("heightAnimation", toValue:sizeTo, animatedTarget: component)
        component.pop_addAnimation(heightAnimation, forKey: "heightAnimation")
    }
    
    func setHeightAnimaionFactory(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
        var height: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (height != nil) {
            //println("Not new \(toValue)")
            height!.toValue = toValue
        }
        else {
            //println("New \(toValue)")
            height = POPSpringAnimation(propertyNamed: kPOPViewSize)
            height!.toValue = toValue
            height!.springBounciness = 10.0
            height!.springSpeed = 1.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return height!
    }
    
    // ----------------------------- End Table Sectionnnnnnnnn ----------------------------- //

    
}