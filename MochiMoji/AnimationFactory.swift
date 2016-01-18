//
//  AnimationFactory.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 7/8/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class AnimationFactory {
    
    class func scaleYAnimaionFactory(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
        var scaleY: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (scaleY != nil) {
            //println("Not new \(toValue)")
            scaleY!.toValue = toValue
        }
        else {
            //println("New \(toValue)")
            scaleY = POPSpringAnimation(propertyNamed: kPOPViewScaleY)
            scaleY!.toValue = toValue
            scaleY!.springBounciness = 10.0
            scaleY!.springSpeed = 10.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return scaleY!
    }
    
    
    // MARK: - Animation Factory
    
    class func frameSizeAnimationFactory(name:String, toValue:NSValue, animatedTarget:UIView, bounce:CGFloat, speed:CGFloat) -> POPSpringAnimation {
        
        // Find animation already exist
        var popAnimation: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (popAnimation != nil) {
            popAnimation!.toValue = toValue
        }
        else {
            popAnimation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
            popAnimation!.toValue = toValue
            popAnimation!.springBounciness = bounce
            popAnimation!.springSpeed = speed
        }
        
        return popAnimation!
    }
    
    class func translationYPosition(name:String, toValue:CGFloat, animatedTarget:UIView, bounce:CGFloat, speed:CGFloat) -> POPSpringAnimation {
        // Find animation already exist
        var popAnimation: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (popAnimation != nil) {
            popAnimation!.toValue = toValue
        }
        else {
            popAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            popAnimation!.toValue = toValue
            popAnimation!.springBounciness = bounce
            popAnimation!.springSpeed = speed
            print("translationYPosition")
        }
        
        return popAnimation!
    }
    
    
    // MARK: - Animation Factory
    
    class func scaleToComponent(component:UIView, scaleTo:CGFloat){
        let scaleAnimation = scaleAnimaionFactory("scaleAnimation", toValue:scaleTo, animatedTarget: component)
        component.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
    }
    
    class func scaleAnimaionFactory(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
        var scaleXY: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (scaleXY != nil) {
            //println("Not new \(toValue)")
            scaleXY!.toValue = NSValue(CGSize: CGSize(width: toValue, height: toValue))
        }
        else {
            //println("New \(toValue)")
            scaleXY = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scaleXY!.toValue = NSValue(CGSize: CGSize(width: toValue, height: toValue))
            scaleXY!.springBounciness = 10.0
            scaleXY!.springSpeed = 20.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return scaleXY!
    }
    
    class func fadeToComponent(component:UIView, fadeTo:CGFloat){
        let fadeAnimation = fadeAnimationFactory("fade", toValue: fadeTo, animatedTarget: component)
        component.pop_addAnimation(fadeAnimation, forKey: "fade")
    }
    
    class func fadeAnimationFactory(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
        var fade: POPSpringAnimation?  = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if fade != nil {
            fade?.toValue = toValue
        }
        else {
            fade = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
            fade!.toValue = toValue
        }
        
        return fade!
    }
    
    class func fadeAnimationFactory(name:String, toValue:CGFloat, animatedTarget:UIView, bounce:CGFloat, speed:CGFloat) -> POPSpringAnimation {
        var fade: POPSpringAnimation?  = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if fade != nil {
            fade?.toValue = toValue
        }
        else {
            fade = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
            fade!.toValue = toValue
            fade!.springBounciness = bounce
            fade!.springSpeed = speed
        }
        
        return fade!
    }
    
    class func touchDownPopSpringAnimationGenerate(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
        var scaleXY: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (scaleXY != nil) {
            //println("Not new \(toValue)")
            scaleXY!.toValue = NSValue(CGSize: CGSize(width: toValue, height: toValue))
        }
        else {
            //println("New \(toValue)")
            scaleXY = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scaleXY!.toValue = NSValue(CGSize: CGSize(width: toValue, height: toValue))
            scaleXY!.springBounciness = 10.0
            scaleXY!.springSpeed = 20.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return scaleXY!
    }
    
    
}