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
        frontView.frame = CGRect(x: 0, y: 0, width: ui_card.bounds.width, height: ui_card.bounds.height)
        frontView.isHidden = false
        (frontView as! DummyCardView).ui_label.text = "frontView"
        ui_card.addSubview(frontView)
        
        backView = UIView.loadFromNibNamed("DummyCardView")!
        backView!.frame = CGRect(x: 0, y: 0, width: ui_card.bounds.width, height: ui_card.bounds.height)
        backView!.isHidden = true
        (backView as! DummyCardView).ui_label.text = "backView"
        ui_card.addSubview(backView!)
        
    }
    
    func flipFlashcard() {
        
        debugPrint("Flip")
        
        UIView.transition(with: ui_card , duration: 0.4, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            if self.isFlipped {
                self.frontView.isHidden = false
                self.backView!.isHidden = true
                self.isFlipped = false
            }
            else {
                self.frontView.isHidden = true
                self.backView!.isHidden = false
                self.isFlipped = true
            }
        }, completion: nil)
        
    }
    
    func handleGesture(_ sender: AnyObject){
        
        let myView = ui_card
        let location = sender.location(in: self)
        let boxLocation = sender.location(in: self)
        
        if sender.state == UIGestureRecognizerState.began {
            if snapBehavior != nil {
                animator.removeBehavior(snapBehavior)
            }

            let centerOffset = UIOffsetMake(boxLocation.x - (myView?.bounds.midX)!, boxLocation.y - (myView?.bounds.midY)!);
            attachmentBehavior = UIAttachmentBehavior(item: myView!, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.ended {
            animator.removeBehavior(attachmentBehavior)

            snapBehavior = UISnapBehavior(item: ui_card, snapTo: self.center)
            animator.addBehavior(snapBehavior!)
            
            let translation = sender.translation(in: self)
            if translation.y > 100 {
                animator.removeAllBehaviors()
                
                let gravity = UIGravityBehavior(items: [ui_card])
                gravity.gravityDirection = CGVector(dx: 0, dy: 10)
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
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let translate = CGAffineTransform(translationX: 0, y: -200)
        ui_card.transform = scale.concatenating(translate)
        
        SpringAnimation.spring(0.5) {
            let scale = CGAffineTransform(scaleX: 1, y: 1)
            let translate = CGAffineTransform(translationX: 0, y: 0)
            self.ui_card.transform = scale.concatenating(translate)
        }
        
        ui_card.alpha = 1
    }
    
}
