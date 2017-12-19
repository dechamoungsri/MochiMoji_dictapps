//
//  SearchAreaController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/19/2559 BE.
//  Copyright © 2559 Decha Moungsri. All rights reserved.
//

import Foundation

class SearchAreaController {
    
    var mainPage_controller:MainPageController
    
    init(controller:MainPageController) {
        self.mainPage_controller = controller
    }
    
    // MARK: IBAction section
    
    func searchAreaTouchUpInside() {
        
        let searchTextField = mainPage_controller.searchTextField
        let searchButton = mainPage_controller.searchButton
        let menuButton = mainPage_controller.menuButton
        let ui_flashCardView = mainPage_controller.ui_flashCardView
        var component_list = mainPage_controller.component_list
        let backButton = mainPage_controller.backButton
        let clearButton = mainPage_controller.clearButton
        
        // Dictionary Textfield Scale Up animation
        let searchTextFieldAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField!)
        searchTextFieldAnimation.completionBlock = {
            (animation, finished) in
            self.searchControllerPreprocessing(true)
        }
        searchTextField?.pop_add(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        // Search Button and Menu button Scale Up
        let searchButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton!)
        searchButton?.pop_add(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        let menuButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton!)
        menuButton?.pop_add(menuButtonAnimation, forKey: "menuButtonScaleTouch")
        
        // Main view component fade away
        AnimationFactory.fadeToComponent(menuButton!, fadeTo: 0.0)
        AnimationFactory.fadeToComponent(searchButton!, fadeTo: 0.0)
        AnimationFactory.fadeToComponent(ui_flashCardView!, fadeTo: 0.0)
        
        // Change Dictionary Color
        var searchTextFieldColor = searchTextField?.pop_animation(forKey: "searchTextFieldColor") as? POPSpringAnimation
        if (searchTextFieldColor != nil) {
            searchTextFieldColor!.toValue = Utility.colorWithHexString("#FAFAFA")
        }
        else {
            
            searchTextFieldColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            searchTextFieldColor!.toValue = Utility.colorWithHexString("#FAFAFA")
            searchTextField?.pop_add(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        // Search view component move in
        let translateBackButton = AnimationFactory.translateXAnimationFactory("translateBackButton", toValue: component_list["backButton.layer.position.x"]!, animatedTarget: backButton!, bounce: 5.0, speed: 20.0)
        backButton?.pop_add(translateBackButton, forKey: "translateBackButton")
        
        let translateClearButton = AnimationFactory.translateXAnimationFactory("translateClearButton", toValue: component_list["clearButton.layer.position.x"]!, animatedTarget: clearButton!, bounce: 5.0, speed: 20.0)
        clearButton?.pop_add(translateClearButton, forKey: "translateClearButton")
        
        mainPage_controller.tableViewContainer.isHidden = false
        AnimationFactory.fadeToComponent(mainPage_controller.tableViewContainer, fadeTo: 1.0)
        
    }
    
    func searchAreaTouchDown() {
        
        let searchTextField = mainPage_controller.searchTextField
        let searchButton = mainPage_controller.searchButton
        let menuButton = mainPage_controller.menuButton
        
        //println("Touch Down")
        let searchTextFieldAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:0.9, animatedTarget: searchTextField!)
        searchTextField?.pop_add(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        let searchButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:0.9, animatedTarget: searchButton!)
        searchButton?.pop_add(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        let menuButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:0.9, animatedTarget: menuButton!)
        menuButton?.pop_add(menuButtonAnimation, forKey: "menuButtonScaleTouch")
        
    }
    
    func searchAreaTouchUpOutside() {
        
        let searchTextField = mainPage_controller.searchTextField
        let searchButton = mainPage_controller.searchButton
        let menuButton = mainPage_controller.menuButton
        
        let searchTextFieldAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField!)
        searchTextField?.pop_add(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        let searchButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton!)
        searchButton?.pop_add(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        let menuButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton!)
        menuButton?.pop_add(menuButtonAnimation, forKey: "menuButtonScaleTouch")
    }
    
    func onBackPressed() {
        
        let searchTextField = mainPage_controller.searchTextField
        let searchButton = mainPage_controller.searchButton
        let menuButton = mainPage_controller.menuButton
        let ui_flashCardView = mainPage_controller.ui_flashCardView
        var component_list = mainPage_controller.component_list
        let backButton = mainPage_controller.backButton
        let clearButton = mainPage_controller.clearButton
        let tableViewContainer = mainPage_controller.tableViewContainer
        
        //searchTextField.textColor = colorWithHexString("#2D8BCE")
        var searchTextFieldColor = searchTextField?.pop_animation(forKey: "searchTextFieldColor") as? POPSpringAnimation
        if (searchTextFieldColor != nil) {
            searchTextFieldColor!.toValue = Utility.colorWithHexString("#2D8BCE")
        }
        else {
            searchTextFieldColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            searchTextFieldColor!.toValue = Utility.colorWithHexString("#2D8BCE")
            searchTextFieldColor!.completionBlock = {
                (animation, finished) in
                self.searchControllerPreprocessing(false)
            }
            searchTextField?.pop_add(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        menuButton?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
        AnimationFactory.scaleToComponent(menuButton!, scaleTo: 1.0)
        searchButton?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
        AnimationFactory.scaleToComponent(searchButton!, scaleTo: 1.0)
        
        // Main view component fade in
        
        AnimationFactory.fadeToComponent(menuButton!, fadeTo: 1.0)
        AnimationFactory.fadeToComponent(searchButton!, fadeTo: 1.0)
        AnimationFactory.fadeToComponent(ui_flashCardView!, fadeTo: 1.0)
        
        // Search view component move in
        let translateBackButton = AnimationFactory.translateXAnimationFactory("translateBackButton", toValue: component_list["backButton.layer.position.x"]! - 80, animatedTarget: backButton!, bounce: 5.0, speed: 20.0)
        backButton?.pop_add(translateBackButton, forKey: "translateBackButton")
        
        let translateClearButton = AnimationFactory.translateXAnimationFactory("translateClearButton", toValue: component_list["clearButton.layer.position.x"]! + 80, animatedTarget: clearButton!, bounce: 5.0, speed: 20.0)
        clearButton?.pop_add(translateClearButton, forKey: "translateClearButton")
        
        let fadeAnimation = AnimationFactory.fadeAnimationFactory("fade", toValue: 0.0, animatedTarget: tableViewContainer!)
        fadeAnimation.completionBlock = {
            (animation, finished) in
            self.mainPage_controller.tableViewContainer.isHidden = true
        }
        tableViewContainer?.pop_add(fadeAnimation, forKey: "fade")
        
        searchTextField?.resignFirstResponder()
    }
    
    /*
     Search Controller processing
     Do this after finish tranformation
     */
    func searchControllerPreprocessing(_ showSearchView: Bool) {
        
        let searchTextField = mainPage_controller.searchTextField
        let searchView = mainPage_controller.searchView
        
        // Move to search controller
        //self.performSegueWithIdentifier("mainToSearchView", sender: self)
        if showSearchView {
            searchTextField?.text = ""
            searchTextField?.placeholder = "Search"
            searchTextField?.textAlignment = NSTextAlignment.left
            searchView?.isHidden = false
            searchTextField?.textColor = Utility.colorWithHexString("#7D7D7D")
            mainPage_controller.searchTextField.becomeFirstResponder()
            
        }
        else {
            searchTextField?.text = "Dictionary"
            searchTextField?.placeholder = ""
            searchTextField?.textAlignment = NSTextAlignment.center
            searchView?.isHidden = true
            searchTextField?.textColor = Utility.colorWithHexString("#FAFAFA")
            
        }
    }
    
}
