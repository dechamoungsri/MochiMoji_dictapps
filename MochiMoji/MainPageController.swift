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

class MainPageController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

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

    var isMenuButtonPressed : Bool = false
    var isFliped : Bool = false
    var flashCardCenter : CGPoint!
    
    var screenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    
    let entityCellIdentifier = "searchResultEntittyCellidentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        var paddingView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.searchTextField.leftView = paddingView
        self.searchTextField.leftViewMode = UITextFieldViewMode.Always
        
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
        
        // Search View initialization
        let nibName = UINib(nibName: "SearchResultEntityCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: entityCellIdentifier)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //println("viewWillAppear")
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
        var searchTextFieldAnimation = touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField)
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        var searchButtonAnimation = touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        var menuButtonAnimation = touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
    }
    
    // MARK: - Search Area Touch
    
    /*
        Search area touchup indeside 
        Animation tranform to search view
    */
    var component_list = Dictionary<String, CGFloat>()
//    var finish_check_list:[Bool] = []
//    let max_anim = 4
    @IBAction func searchAreaTouchUpInside(sender: UIButton) {
        //println("Touch Up")
        //finish_check_list = []
        
        // Dictionary Textfield Scale Up animation
        var searchTextFieldAnimation = touchDownPopSpringAnimationGenerate("searchTextFieldScaleTouch", toValue:1.0, animatedTarget: searchTextField)
        searchTextFieldAnimation.completionBlock = {
            (animation, finished) in
            self.searchControllerPreprocessing(true)
        }
        searchTextField.pop_addAnimation(searchTextFieldAnimation, forKey: "searchTextFieldScaleTouch")
        
        // Search Button and Menu button Scale Up
        var searchButtonAnimation = touchDownPopSpringAnimationGenerate("searchButtonScaleTouch", toValue:1.0, animatedTarget: searchButton)
        searchButton.pop_addAnimation(searchButtonAnimation, forKey: "searchButtonScaleTouch")
        
        var menuButtonAnimation = touchDownPopSpringAnimationGenerate("menuButtonScaleTouch", toValue:1.0, animatedTarget: menuButton)
        menuButton.pop_addAnimation(menuButtonAnimation, forKey: "menuButtonScaleTouch")
        
        // Main view component fade away
        fadeToComponent(menuButton, fadeTo: 0.0)
        fadeToComponent(searchButton, fadeTo: 0.0)
        fadeToComponent(flashCardView, fadeTo: 0.0)
        
        // Change Dictionary Color
        var searchTextFieldColor = searchTextField.pop_animationForKey("searchTextFieldColor") as? POPSpringAnimation
        if (searchTextFieldColor != nil) {
            searchTextFieldColor!.toValue = colorWithHexString("#FAFAFA")
        }
        else {
            
            searchTextFieldColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            searchTextFieldColor!.toValue = colorWithHexString("#FAFAFA")
            searchTextField.pop_addAnimation(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        // Search view component move in
        var translateBackButton = backButton.pop_animationForKey("translateBackButton") as? POPSpringAnimation
        if (translateBackButton != nil) {
            translateBackButton!.toValue = component_list["backButton.layer.position.x"]
        }
        else {
            translateBackButton = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            translateBackButton!.toValue = component_list["backButton.layer.position.x"]
            translateBackButton!.springBounciness = 5.0
            translateBackButton!.springSpeed = 20.0
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
            clearButton.pop_addAnimation(translateClearButton, forKey: "translateClearButton")
        }
        
        tableViewContainer.hidden = false
        fadeToComponent(tableViewContainer, fadeTo: 1.0)

    }
    
    /*
        End Touch up inside
    */
    
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
            scaleXY!.springBounciness = 10.0
            scaleXY!.springSpeed = 20.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return scaleXY!
    }

//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//        println("dog")
//        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController)
//    }
    
    
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
            searchTextField.textColor = colorWithHexString("#7D7D7D")
            self.searchTextField.becomeFirstResponder()
            
        }
        else {
            searchTextField.text = "Dictionary"
            searchTextField.placeholder = ""
            searchTextField.textAlignment = NSTextAlignment.Center
            searchView.hidden = true
            searchTextField.textColor = colorWithHexString("#FAFAFA")
            
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

    /*
        Search View section
    */
    
    // MARK: - SearchView
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewContainer: UIView!
    
    @IBAction func onBackPressed(sender: UIButton) {
        //searchTextField.textColor = colorWithHexString("#2D8BCE")
        var searchTextFieldColor = searchTextField.pop_animationForKey("searchTextFieldColor") as? POPSpringAnimation
        if (searchTextFieldColor != nil) {
            searchTextFieldColor!.toValue = colorWithHexString("#2D8BCE")
        }
        else {
            searchTextFieldColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            searchTextFieldColor!.toValue = colorWithHexString("#2D8BCE")
            searchTextFieldColor!.completionBlock = {
                (animation, finished) in
                self.searchControllerPreprocessing(false)
            }
            searchTextField.pop_addAnimation(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        menuButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
        scaleToComponent(menuButton, scaleTo: 1.0)
        searchButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
        scaleToComponent(searchButton, scaleTo: 1.0)
        
        // Main view component fade in
        
        fadeToComponent(menuButton, fadeTo: 1.0)
        fadeToComponent(searchButton, fadeTo: 1.0)
        fadeToComponent(flashCardView, fadeTo: 1.0)
        
        // Search view component move in
        var translateBackButton = backButton.pop_animationForKey("translateBackButton") as? POPSpringAnimation
        if (translateBackButton != nil) {
            translateBackButton!.toValue = component_list["backButton.layer.position.x"]! - 80
        }
        else {
            translateBackButton = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            translateBackButton!.toValue = component_list["backButton.layer.position.x"]! - 80
            translateBackButton!.springBounciness = 5.0
            translateBackButton!.springSpeed = 20.0
            backButton.pop_addAnimation(translateBackButton, forKey: "translateBackButton")
        }
        
        var translateClearButton = backButton.pop_animationForKey("translateClearButton") as? POPSpringAnimation
        if (translateClearButton != nil) {
            translateClearButton!.toValue = component_list["clearButton.layer.position.x"]! + 80
        }
        else {
            translateClearButton = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            translateClearButton!.toValue = component_list["clearButton.layer.position.x"]! + 80
            translateClearButton!.springBounciness = 5.0
            translateClearButton!.springSpeed = 20.0
            clearButton.pop_addAnimation(translateClearButton, forKey: "translateClearButton")
        }
        
        var fadeAnimation = fadeAnimationFactory("fade", toValue: 0.0, animatedTarget: tableViewContainer)
        fadeAnimation.completionBlock = {
            (animation, finished) in
            self.tableViewContainer.hidden = true
        }
        tableViewContainer.pop_addAnimation(fadeAnimation, forKey: "fade")
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - Animation Factory
    
    func scaleToComponent(component:UIView, scaleTo:CGFloat){
        var scaleAnimation = scaleAnimaionFactory("scaleAnimation", toValue:scaleTo, animatedTarget: component)
        component.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
    }
    
    func scaleAnimaionFactory(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
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
    
    func fadeToComponent(component:UIView, fadeTo:CGFloat){
        var fadeAnimation = fadeAnimationFactory("fade", toValue: fadeTo, animatedTarget: component)
        component.pop_addAnimation(fadeAnimation, forKey: "fade")
    }
    
    func fadeAnimationFactory(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
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
    
    // MARK: - UITableView
    // ============================= Start Table Sectionnnnnnnnn ============================= //
    
    var cellsEntity = [DummyEntity]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("numberOfRowsInSection")
        return cellsEntity.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 76
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(entityCellIdentifier, forIndexPath: indexPath) as SearchResultEntityCell
        
        let row = indexPath.row
        cell.cellEntityFromDummyEntity(cellsEntity[row], text: searchTextField.text)

        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        println("View Appear \(row)")
        //cell.contentView.layer.anchorPoint = CGPointMake(cell.center.x, 0)
        //cell.contentView.transform = CGAffineTransformMakeScale(1, 0.5)
        (cell as SearchResultEntityCell).viewContainer.transform = CGAffineTransformMakeScale(1, 0.5)
        //setCellHeight(cell.contentView, scaleTo: 76.0)
        
    }
    
    func endUpdates() {
        println("endUpdates")
    }
    
    // MARK: - Table Cell Animation Factory
    func setCellHeight(component:UIView, scaleTo:CGFloat){
        var scaleAnimation = scaleYAnimaionFactory("scaleYAnimation", toValue:scaleTo, animatedTarget: component)
        component.pop_addAnimation(scaleAnimation, forKey: "scaleYAnimation")
    }
    
    func scaleYAnimaionFactory(name:String, toValue:CGFloat, animatedTarget:UIView) -> POPSpringAnimation {
        var scaleY: POPSpringAnimation? = animatedTarget.pop_animationForKey(name) as? POPSpringAnimation
        
        if (scaleY != nil) {
            //println("Not new \(toValue)")
            scaleY!.toValue = NSValue(CGRect: CGRectMake(0, 0, 375, toValue ))
        }
        else {
            //println("New \(toValue)")
            scaleY = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
            scaleY!.toValue = NSValue(CGRect: CGRectMake(0, 0, 375, toValue ))
            scaleY!.springBounciness = 10.0
            scaleY!.springSpeed = 1.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return scaleY!
    }
    
    // ----------------------------- End Table Sectionnnnnnnnn ----------------------------- //
    
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
        
        println("Search Input text is : \(inputText)")
        
        mem_Text = inputText
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            var result = self.searchProcessing(inputText)
            dispatch_async(dispatch_get_main_queue()) { // 2
                if result.valueForKey(self.INPUTTEXT_KEY) as String == self.mem_Text {
                    self.cellsEntity = result.valueForKey(self.ENTITY_KEY) as [DummyEntity]
                    println("Reload Data")
                    self.tableView.reloadData()
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
    
}

