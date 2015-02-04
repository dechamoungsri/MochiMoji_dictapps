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
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var flashCardView: UIView!
    @IBOutlet weak var answerCardView: UIView!
    @IBOutlet weak var cardFrontView: UIView!

    var isMenuButtonPressed : Bool = false
    var isFliped : Bool = false
    var flashCardCenter : CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        animator = UIDynamicAnimator(referenceView: view)
        
        //var flashCardCenterX = view.constraints().
        
        var cardView = UIView.loadFromNibNamed("KanjiCardView")!
        cardView.frame = CGRectMake(0, 0, cardContextView.bounds.width, cardContextView.bounds.height)
        //cardView.frame = CGRectMake(0, 0, 200, 2000)
        cardContextView.addSubview(cardView)
        
        //menuView.layer.anchorPoint = CGPointMake(0.5, 0)
        //menuView.transform = CGAffineTransformMakeTranslation(0, -150)
        
        //menuView.layer.transform =
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(Bool())
        flashCardCenter = flashCardView.center
        self.cardFrontView.hidden = false
        self.answerCardView.hidden = true
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let translate = CGAffineTransformMakeTranslation(0, -200)
        flashCardView.transform = CGAffineTransformConcat(scale, translate)
        
        spring(0.5) {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.flashCardView.transform = CGAffineTransformConcat(scale, translate)
        }
        
        flashCardView.alpha = 1
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        springWithCompletion(0.3, {
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width;
            let screenHeight = screenSize.height;
            
            self.searchTextField.frame = CGRectMake(0, 0, screenWidth, 80)
            self.searchTextField.layer.cornerRadius = 0
            self.searchTextField.backgroundColor = self.colorWithHexString("F5F5F5")
            self.searchTextField.textColor = self.searchTextField.backgroundColor
            self.searchButton.alpha = 0
            self.menuButton.alpha = 0
            self.flashCardView.alpha = 0

            }, { finished in
                self.performSegueWithIdentifier("mainToSearchView", sender: self)
        })
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

