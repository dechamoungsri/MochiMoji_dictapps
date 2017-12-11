//
//  MenuAreaController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/19/2559 BE.
//  Copyright © 2559 Decha Moungsri. All rights reserved.
//

import Foundation

class MenuAreaController {
    
    var mainPage_controller:MainPageController
    
    init(controller:MainPageController) {
        self.mainPage_controller = controller
    }
    
    func menuPressAction() {
        
        var isMenuButtonPressed = mainPage_controller.isMenuButtonPressed
        let menuView = mainPage_controller.menuView
        
        if isMenuButtonPressed {
            isMenuButtonPressed = false
            let tranformY: POPSpringAnimation? = menuView.pop_animationForKey("translationAnimation") as? POPSpringAnimation
            
            if (tranformY != nil) {
                tranformY!.toValue = -150
            }
            else {
                let tranformY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                tranformY!.toValue = -150
                tranformY!.springBounciness = 10.0
                tranformY!.springSpeed = 1.0
                menuView.pop_addAnimation(tranformY, forKey: "translationAnimation")
            }
        }
        else {
            isMenuButtonPressed = true
            var tranformY: POPSpringAnimation? = menuView.pop_animationForKey("translationAnimation") as? POPSpringAnimation
            
            if (tranformY != nil) {
                tranformY!.toValue = 150
            }
            else {
                tranformY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                tranformY!.toValue = 150
                tranformY!.springBounciness = 10.0
                tranformY!.springSpeed = 1.0
                menuView.pop_addAnimation(tranformY, forKey: "translationAnimation")
            }
        }
    }
    
}