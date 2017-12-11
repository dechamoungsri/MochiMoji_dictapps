//
//  UICardView.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/16/2559 BE.
//  Copyright © 2559 Decha Moungsri. All rights reserved.
//

import Foundation

class UICardView : UIView {
    
    @IBOutlet weak var ui_card: UIView!
    
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
    
    var cardView_center : CGPoint!

    var isFlipped = false
    var frontView:UIView!
    var backView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initial(){
        self.layoutIfNeeded()
        ui_card.layoutIfNeeded()
        animator = UIDynamicAnimator(referenceView: self)
        
        frontView = UIView.loadFromNibNamed("DummyCardView")!
        frontView.frame = CGRectMake(0, 0, ui_card.bounds.width, ui_card.bounds.height)
        frontView.hidden = false
        (frontView as! DummyCardView).ui_label.text = "frontView"
        ui_card.addSubview(frontView)
        
        backView = UIView.loadFromNibNamed("DummyCardView")!
        backView!.frame = CGRectMake(0, 0, ui_card.bounds.width, ui_card.bounds.height)
        backView!.hidden = true
        (backView as! DummyCardView).ui_label.text = "backView"
        ui_card.addSubview(backView!)
        
    }
    
    func flipFlashcard() {
        
        debugPrint("Flip")
        
        UIView.transitionWithView(ui_card , duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            if self.isFlipped {
                self.frontView.hidden = false
                self.backView!.hidden = true
                self.isFlipped = false
            }
            else {
                self.frontView.hidden = true
                self.backView!.hidden = false
                self.isFlipped = true
            }
        }, completion: nil)
        
    }
    
    func handleGesture(sender: AnyObject){
        
        let myView = ui_card
        let location = sender.locationInView(self)
        let boxLocation = sender.locationInView(self)
        
        if sender.state == UIGestureRecognizerState.Began {
            if snapBehavior != nil {
                animator.removeBehavior(snapBehavior)
            }

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

            snapBehavior = UISnapBehavior(item: ui_card, snapToPoint: self.center)
            animator.addBehavior(snapBehavior!)
            
            let translation = sender.translationInView(self)
            if translation.y > 100 {
                animator.removeAllBehaviors()
                
                let gravity = UIGravityBehavior(items: [ui_card])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator.addBehavior(gravity)
                
                delay(0.3) {
                    self.refreshView()
                }
            }
        }
        
    }
    
    func refreshView() {

        animator.removeAllBehaviors()
    
        ui_card.center = self.center
        viewDidAppear()
    }
    
    func viewDidAppear(){
        
//        card_center = ui_card.center
//        self.cardFrontView.hidden = false
//        self.answerCardView.hidden = true
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let translate = CGAffineTransformMakeTranslation(0, -200)
        ui_card.transform = CGAffineTransformConcat(scale, translate)
        
        SpringAnimation.spring(0.5) {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.ui_card.transform = CGAffineTransformConcat(scale, translate)
        }
        
        ui_card.alpha = 1
    }
    
}