//
//  ViewController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 1/25/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}

class MainPageController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var lastSeenReportUILabel: UILabel!
    @IBOutlet weak var cardContextView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UILabel!
    @IBOutlet weak var flashCardView: UIView!
    @IBOutlet weak var answerCardView: UIView!
    @IBOutlet weak var cardFrontView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var topview: UIView!

    var isMenuButtonPressed : Bool = false
    var isFliped : Bool = false
    var flashCardCenter : CGPoint!
    
    var screenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        animator = UIDynamicAnimator(referenceView: view)
        
        //var flashCardCenterX = view.constraints().
        
        var cardView = UIView.loadFromNibNamed("KanjiCardView")!
        cardView.frame = CGRectMake(0, 0, cardContextView.bounds.width, cardContextView.bounds.height)
        //cardView.frame = CGRectMake(0, 0, 200, 2000)
        cardContextView.addSubview(cardView)
        
        component_list["backButton.layer.position.x"] = 80+backButton.layer.position.x
        component_list["clearButton.layer.position.x"] = -80 + screenWidth - 20 - clearButton.frame.width/2
        
        backButton.transform = CGAffineTransformMakeTranslation(-80, 0)
        clearButton.transform = CGAffineTransformMakeTranslation(80, 0)
        
        backButton.layer.position.x = backButton.layer.position.x-80
        clearButton.layer.position.x = clearButton.layer.position.x+80
//
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //println("viewWillAppear")
        super.viewWillAppear(animated)
//        component_list["backButton.layer.position.x"] = backButton.layer.position.x
//        component_list["clearButton.layer.position.x"] = clearButton.layer.position.x
//        backButton.layer.position.x = backButton.layer.position.x-80
//        clearButton.layer.position.x = clearButton.layer.position.x+80
//        backButton.layer.position.x = backButton.layer.position.x-80
//        clearButton.layer.position.x = clearButton.layer.position.x+80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //println("viewDidAppear")
        super.viewDidAppear(animated)
        flashCardCenter = flashCardView.center
        self.cardFrontView.hidden = false
        self.answerCardView.hidden = true
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let translate = CGAffineTransformMakeTranslation(0, -200)
        flashCardView.transform = CGAffineTransformConcat(scale, translate)
        
//        component_list["backButton.layer.position.x"] = backButton.layer.position.x
//        component_list["clearButton.layer.position.x"] = clearButton.layer.position.x
        
//        backButton.layer.position.x = backButton.layer.position.x-80
//        clearButton.layer.position.x = clearButton.layer.position.x+80
//
        spring(0.5) {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.flashCardView.transform = CGAffineTransformConcat(scale, translate)
        }
        
        flashCardView.alpha = 1
    }
    
    @IBAction func searchAreaTouchUpOutside(sender: UIButton) {
        var searchTextFieldAnimation = touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField)
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        var searchButtonAnimation = touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        var menuButtonAnimation = touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
    }
    
    var component_list = Dictionary<String, CGFloat>()
    var finish_check_list:[Bool] = []
    let max_anim = 4
    @IBAction func searchAreaTouchUpInside(sender: UIButton) {
        //println("Touch Up")
        finish_check_list = []
        var searchTextFieldAnimation = touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField)
        searchTextFieldAnimation.completionBlock = {
            (animation, finished) in
            self.finish_check_list.append(finished)
            if (self.finish_check_list.count == self.max_anim) {
                self.searchControllerPreprocessing()
            }
        }
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        var searchButtonAnimation = touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        var menuButtonAnimation = touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
        
        var alphaFade = searchButton.pop_animationForKey("FadeOutIcon") as? POPSpringAnimation
        if (alphaFade != nil) {
            alphaFade!.toValue = 0.0
        }
        else {
            alphaFade = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
            alphaFade!.toValue = 0.0
            menuButton.pop_addAnimation(alphaFade, forKey: "FadeOutIcon")
            searchButton.pop_addAnimation(alphaFade, forKey: "FadeOutIcon")
            flashCardView.pop_addAnimation(alphaFade, forKey: "FadeOutIcon")
        }
        
        var searchTextFieldColor = searchTextField.pop_animationForKey("searchTextFieldColor") as? POPSpringAnimation
        if (searchTextFieldColor != nil) {
            searchTextFieldColor!.toValue = colorWithHexString("#FAFAFA")
        }
        else {
            
            searchTextFieldColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            searchTextFieldColor!.toValue = colorWithHexString("#FAFAFA")
            searchTextFieldColor!.completionBlock = {
                (animation, finished) in
                self.finish_check_list.append(finished)
                if (self.finish_check_list.count == self.max_anim) {
                    self.searchControllerPreprocessing()
                }
            }
            searchTextField.pop_addAnimation(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        var translateBackButton = backButton.pop_animationForKey("translateBackButton") as? POPSpringAnimation
        if (translateBackButton != nil) {
            translateBackButton!.toValue = component_list["backButton.layer.position.x"]
        }
        else {
            translateBackButton = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            translateBackButton!.toValue = component_list["backButton.layer.position.x"]
            translateBackButton!.springBounciness = 5.0
            translateBackButton!.springSpeed = 20.0
            translateBackButton!.completionBlock = {
                (animation, finished) in
                self.finish_check_list.append(finished)
                if (self.finish_check_list.count == self.max_anim) {
                    self.searchControllerPreprocessing()
                }
            }
            backButton.pop_addAnimation(translateBackButton, forKey: "translateBackButton")
        }
        
        var translateClearButton = backButton.pop_animationForKey("translateClearButton") as? POPSpringAnimation
        if (translateClearButton != nil) {
            translateClearButton!.toValue = component_list["clearButton.layer.position.x"]
        }
        else {
            translateClearButton = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            translateClearButton!.toValue = component_list["clearButton.layer.position.x"]
            translateClearButton!.springBounciness = 5.0
            translateClearButton!.springSpeed = 20.0
            translateClearButton!.completionBlock = {
                (animation, finished) in
                self.finish_check_list.append(finished)
                if (self.finish_check_list.count == self.max_anim) {
                    self.searchControllerPreprocessing()
                }
            }
            clearButton.pop_addAnimation(translateClearButton, forKey: "translateClearButton")
        }
        
    }
    
    @IBAction func searchAreaTouchDown(sender: UIButton) {
        
        //println("Touch Down")
        var searchTextFieldAnimation = touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:0.9, animatedTarget: searchTextField)
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        var searchButtonAnimation = touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:0.9, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        var menuButtonAnimation = touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:0.9, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
        
    }
    
    func touchDownPopSpringAnimationGenerate(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
        var scaleXY: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (scaleXY != nil) {
            //println("Not new \(toValue)")
            scaleXY!.toValue = NSValue(CGSize: CGSize(width: toValue, height: toValue))
        }
        else {
            //println("New \(toValue)")
            scaleXY = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scaleXY!.toValue = NSValue(CGSize: CGSize(width: toValue, height: toValue))
            scaleXY!.springBounciness = 5.0
            scaleXY!.springSpeed = 20.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return scaleXY!
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        println("dog")
        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController)
    }
    
    
    func searchControllerPreprocessing() {
        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(dur * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("mainToSearchView", sender: self)
//        }

    }
    
    @IBAction func menuPressAction(sender: AnyObject) {
        
        if isMenuButtonPressed {
            isMenuButtonPressed = false
            var tranformY: POPSpringAnimation? = menuView.pop_animationForKey("translationAnimation") as? POPSpringAnimation
            
            if (tranformY != nil) {
                tranformY!.toValue = -150
            }
            else {
                var tranformY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
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
    
    @IBAction func tabOnFlashcard(sender: AnyObject) {
        self.flipFlashcard()
    }
    
    
    func flipFlashcard() {
        
        UIView.transitionWithView(self.flashCardView , duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            if self.isFliped {
                self.cardFrontView.hidden = false
                self.answerCardView.hidden = true
                self.isFliped = false
            }
            else {
                self.cardFrontView.hidden = true
                self.answerCardView.hidden = false
                self.isFliped = true
            }
        }, completion: nil)
        
    }
    
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
    
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    @IBAction func handleGesture(sender: AnyObject) {
        let myView = flashCardView
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(flashCardView)
        
        if sender.state == UIGestureRecognizerState.Began {
            animator.removeBehavior(snapBehavior)
            
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapToPoint: flashCardCenter) //view.center)
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translationInView(view)
            if translation.y > 100 {
                animator.removeAllBehaviors()
                
                var gravity = UIGravityBehavior(items: [flashCardView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator.addBehavior(gravity)
                
                delay(0.3) {
                    self.refreshView()
                }
            }
        }
    }
    
    func refreshView() {
//        number++
//        if number > 3 {
//            number = 0
//        }
        
        animator.removeAllBehaviors()
        
        snapBehavior = UISnapBehavior(item: flashCardView, snapToPoint: flashCardCenter)//view.center)
        attachmentBehavior.anchorPoint = flashCardCenter//view.center
        
        flashCardView.center = flashCardCenter//view.center
        viewDidAppear(true)
    }
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (countElements(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rString = (cString as NSString).substringToIndex(2)
        var gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        var bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

}

