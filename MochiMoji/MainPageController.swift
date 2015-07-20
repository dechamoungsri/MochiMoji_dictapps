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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var topview_dummy: UIView!
    @IBOutlet weak var cellAnimatingView: UIView!
    @IBOutlet weak var maskView: UIView!

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewContainer: UIView!
    
    var isMenuButtonPressed : Bool = false
    var isFliped : Bool = false
    var flashCardCenter : CGPoint!
    
    let screenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    let screenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
    
    let entityCellIdentifier = "searchResultEntittyCellidentifier"
    
    var topBarIsHide = false
    
    var dummyCell_animator: UIDynamicAnimator!
    
    var cellsEntity = [DummyEntity]()
    
    var searchTableViewDelegate:SearchTableViewDelegate?
    
    var component_list = Dictionary<String, CGFloat>()
    
    var animationCell:UICellForAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        var paddingView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.searchTextField.leftView = paddingView
        self.searchTextField.leftViewMode = UITextFieldViewMode.Always
        
        animator = UIDynamicAnimator(referenceView: view)
        dummyCell_animator = UIDynamicAnimator(referenceView: view)
        
        var cardView = UIView.loadFromNibNamed("KanjiCardView")!
        cardView.frame = CGRectMake(0, 0, cardContextView.bounds.width, cardContextView.bounds.height)
        cardContextView.addSubview(cardView)
        
        component_list["backButton.layer.position.x"] = 80+backButton.layer.position.x
        component_list["clearButton.layer.position.x"] = -80 + screenWidth - 20 - clearButton.frame.width/2
        
        backButton.transform = CGAffineTransformMakeTranslation(-80, 0)
        clearButton.transform = CGAffineTransformMakeTranslation(80, 0)
        
        backButton.layer.position.x = backButton.layer.position.x-80
        clearButton.layer.position.x = clearButton.layer.position.x+80
        
        // Search View initialization
        let nibName = UINib(nibName: "SearchResultEntityCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: entityCellIdentifier)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        searchTableViewDelegate = SearchTableViewDelegate(mainController: self)
        self.tableView.delegate = searchTableViewDelegate
        self.tableView.dataSource = searchTableViewDelegate
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //println("viewWillAppear")
        let stackSize = self.navigationController?.viewControllers.count
        println("Stack Size : \(stackSize)")
        
        // TODO: Implement Call back from Child
        
        if topBarIsHide {
            searchTableViewDelegate!.onBackToMainView()
        }
        
        super.viewWillAppear(animated)
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

        spring(0.5) {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.flashCardView.transform = CGAffineTransformConcat(scale, translate)
        }
        
        flashCardView.alpha = 1
    }
    
    @IBAction func searchAreaTouchUpOutside(sender: UIButton) {
        var searchTextFieldAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField)
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        var searchButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        var menuButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
    }
    
    // MARK: - Search Area Touch
    
    /*
        Search area touchup indeside 
        Animation tranform to search view
    */
    
    @IBAction func searchAreaTouchUpInside(sender: UIButton) {
        //println("Touch Up")
        //finish_check_list = []

        // Dictionary Textfield Scale Up animation
        var searchTextFieldAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField)
        searchTextFieldAnimation.completionBlock = {
            (animation, finished) in
            self.searchControllerPreprocessing(true)
        }
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        // Search Button and Menu button Scale Up
        var searchButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        var menuButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
        
        // Main view component fade away
        AnimationFactory.fadeToComponent(menuButton, fadeTo: 0.0)
        AnimationFactory.fadeToComponent(searchButton, fadeTo: 0.0)
        AnimationFactory.fadeToComponent(flashCardView, fadeTo: 0.0)
        
        // Change Dictionary Color
        var searchTextFieldColor = searchTextField.pop_animationForKey("searchTextFieldColor") as? POPSpringAnimation
        if (searchTextFieldColor != nil) {
            searchTextFieldColor!.toValue = Utility.colorWithHexString("#FAFAFA")
        }
        else {
            
            searchTextFieldColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            searchTextFieldColor!.toValue = Utility.colorWithHexString("#FAFAFA")
            searchTextField.pop_addAnimation(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        // Search view component move in
        var translateBackButton = translateXAnimationFactory("translateBackButton", toValue: component_list["backButton.layer.position.x"]!, animatedTarget: backButton, bounce: 5.0, speed: 20.0)
        backButton.pop_addAnimation(translateBackButton, forKey: "translateBackButton")
        
        var translateClearButton = translateXAnimationFactory("translateClearButton", toValue: component_list["clearButton.layer.position.x"]!, animatedTarget: clearButton, bounce: 5.0, speed: 20.0)
        clearButton.pop_addAnimation(translateClearButton, forKey: "translateClearButton")
        
        tableViewContainer.hidden = false
        AnimationFactory.fadeToComponent(tableViewContainer, fadeTo: 1.0)

    }
    
    /*
        End Touch up inside
    */
    
    @IBAction func searchAreaTouchDown(sender: UIButton) {
        
        //println("Touch Down")
        var searchTextFieldAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:0.9, animatedTarget: searchTextField)
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        var searchButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:0.9, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        var menuButtonAnimation = AnimationFactory.touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:0.9, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
        
    }
    
    /*
        Search Controller processing
        Do this after finish tranformation
    */
    func searchControllerPreprocessing(showSearchView: Bool) {
        
        // Move to search controller
        //self.performSegueWithIdentifier("mainToSearchView", sender: self)
        if showSearchView {
            searchTextField.text = ""
            searchTextField.placeholder = "Search"
            searchTextField.textAlignment = NSTextAlignment.Left
            searchView.hidden = false
            searchTextField.textColor = Utility.colorWithHexString("#7D7D7D")
            self.searchTextField.becomeFirstResponder()
            
        }
        else {
            searchTextField.text = "Dictionary"
            searchTextField.placeholder = ""
            searchTextField.textAlignment = NSTextAlignment.Center
            searchView.hidden = true
            searchTextField.textColor = Utility.colorWithHexString("#FAFAFA")
            
        }
    }
    
    // MARK: - Menu Section
    
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
    
    // MARK: - Card Animation Factory
    
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

    func translateXAnimationFactory(name:String, toValue:CGFloat, animatedTarget:UIView, bounce:CGFloat, speed:CGFloat) -> POPAnimation? {
        var animationObject = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        if (animationObject != nil) {
            animationObject!.toValue = toValue
        }
        else {
            animationObject = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            animationObject!.toValue = toValue
            animationObject!.springBounciness = bounce
            animationObject!.springSpeed = speed
        }
        return animationObject
    }
    
    // MARK: - SearchView IBOUTLET
    
    @IBAction func onBackPressed(sender: UIButton) {
        //searchTextField.textColor = colorWithHexString("#2D8BCE")
        var searchTextFieldColor = searchTextField.pop_animationForKey("searchTextFieldColor") as? POPSpringAnimation
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
            searchTextField.pop_addAnimation(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        menuButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
        AnimationFactory.scaleToComponent(menuButton, scaleTo: 1.0)
        searchButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
        AnimationFactory.scaleToComponent(searchButton, scaleTo: 1.0)
        
        // Main view component fade in
        
        AnimationFactory.fadeToComponent(menuButton, fadeTo: 1.0)
        AnimationFactory.fadeToComponent(searchButton, fadeTo: 1.0)
        AnimationFactory.fadeToComponent(flashCardView, fadeTo: 1.0)
        
        // Search view component move in
        var translateBackButton = translateXAnimationFactory("translateBackButton", toValue: component_list["backButton.layer.position.x"]! - 80, animatedTarget: backButton, bounce: 5.0, speed: 20.0)
        backButton.pop_addAnimation(translateBackButton, forKey: "translateBackButton")
        
        var translateClearButton = translateXAnimationFactory("translateClearButton", toValue: component_list["clearButton.layer.position.x"]! + 80, animatedTarget: clearButton, bounce: 5.0, speed: 20.0)
        clearButton.pop_addAnimation(translateClearButton, forKey: "translateClearButton")
        
        var fadeAnimation = AnimationFactory.fadeAnimationFactory("fade", toValue: 0.0, animatedTarget: tableViewContainer)
        fadeAnimation.completionBlock = {
            (animation, finished) in
            self.tableViewContainer.hidden = true
        }
        tableViewContainer.pop_addAnimation(fadeAnimation, forKey: "fade")
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - SearchTextField Processing
    // ============================= Start Search Text field Section ============================= //
    var mem_Text = ""
    var ENTITY_KEY = "ENTITY_KEY"
    var INPUTTEXT_KEY = "INPUTTEXT_KEY"
    @IBAction func searchTextFieldEditingChanged(sender: UITextField) {
        
        var inputText:String = searchTextField.text
        if inputText == "" {
            return
        }
        
        if mem_Text == inputText {
            return
        }
        
        println("Search Input text is : \(inputText)")
        
        mem_Text = inputText
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            var result = self.searchProcessing(inputText)
            dispatch_async(dispatch_get_main_queue()) { // 2
                if result.valueForKey(self.INPUTTEXT_KEY) as! String == self.mem_Text {
                    self.cellsEntity = result.valueForKey(self.ENTITY_KEY) as! [DummyEntity]
                    println("Reload Data")

                    self.tableView.reloadData()
                    self.searchTableViewDelegate!.stack = 0.0
                }
            }
        }
        
    }
    
    func searchProcessing(inputText:String) -> NSMutableDictionary{
        var starttime = NSDate().timeIntervalSince1970
        var cells = DatabaseHelper.sharedInstance.queryTextInput(inputText)
        var endtime = NSDate().timeIntervalSince1970
        //println("searchProcessing Duration : \(endtime-starttime) Seconds")
        var dictionary = NSMutableDictionary()
        dictionary.setObject(cells, forKey: ENTITY_KEY)
        dictionary.setObject(inputText, forKey: INPUTTEXT_KEY)
        return dictionary
    }
    
    // On press search button
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        println("Resign call")
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func searchShowOnTouch(sender: UIButton) {
        searchTextField.becomeFirstResponder()
    }
    // ----------------------------- End Search Text field Section ----------------------------- //
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Push Data Here
        println("Prepare for Segue \(segue.identifier)")
    }
    
    // MARK: - Word delegate back
    
    @IBAction func sendDataFromChildToParent(segue: UIStoryboardSegue) {
        let childViewController:WordViewController = segue.sourceViewController as! WordViewController;
        println("Receive data from Child \(segue.identifier)")
    }
    
    
}

