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
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var topview_dummy: UIView!
    @IBOutlet weak var cellAnimatingView: UIView!
    @IBOutlet weak var maskView: UIView!

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewContainer: UIView!
    
    @IBOutlet weak var ui_flashCardViewContainer: UIView!
    
    var ui_flashCardView: UICardView?
    
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
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
    
    var searchAreaController : SearchAreaController?
    var menuAreaController: MenuAreaController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        searchAreaController = SearchAreaController(controller: self)
        menuAreaController = MenuAreaController(controller: self)
        
        let paddingView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.searchTextField.leftView = paddingView
        self.searchTextField.leftViewMode = UITextFieldViewMode.Always
        
        dummyCell_animator = UIDynamicAnimator(referenceView: view)
        
        ui_flashCardView = UIView.loadFromNibNamed("UICardView") as? UICardView
        ui_flashCardView?.frame = CGRectMake(0, 0, ui_flashCardViewContainer.bounds.width, ui_flashCardViewContainer.bounds.height)
        ui_flashCardViewContainer.addSubview(ui_flashCardView!)
        ui_flashCardView?.initial()
        
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
        print("Stack Size : \(stackSize)")
        
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
        ui_flashCardView?.viewDidAppear()
    }
    
    @IBAction func searchAreaTouchUpOutside(sender: UIButton) {
        self.searchAreaController!.searchAreaTouchUpOutside()
    }
    
    // MARK: - Search Area Touch
    
    /*
        Search area touchup indeside 
        Animation tranform to search view
    */
    @IBAction func searchAreaTouchUpInside(sender: UIButton) {
        self.searchAreaController!.searchAreaTouchUpInside()
    }
    /*
        End Touch up inside
    */
    @IBAction func searchAreaTouchDown(sender: UIButton) {
        self.searchAreaController!.searchAreaTouchDown()
    }
    
    @IBAction func onBackPressed(sender: UIButton) {
        self.searchAreaController!.onBackPressed()
    }
    
    // MARK: - Menu Section
    @IBAction func menuPressAction(sender: AnyObject) {
        self.menuAreaController!.menuPressAction()
    }

    // MARK: - Flashcard Section
    @IBAction func tabOnFlashcard(sender: AnyObject) {
        ui_flashCardView?.flipFlashcard()
    }

    @IBAction func handleGesture(sender: AnyObject) {
        ui_flashCardView?.handleGesture(sender)
    }
    
    // MARK: - SearchTextField Processing
    // ============================= Start Search Text field Section ============================= //
    var mem_Text = ""
    var ENTITY_KEY = "ENTITY_KEY"
    var INPUTTEXT_KEY = "INPUTTEXT_KEY"
    @IBAction func searchTextFieldEditingChanged(sender: UITextField) {
        
        let inputText:String = searchTextField.text!
        if inputText == "" {
            return
        }
        
        if mem_Text == inputText {
            return
        }
        
        print("Search Input text is : \(inputText)")
        
        mem_Text = inputText
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            let result = self.searchProcessing(inputText)
            dispatch_async(dispatch_get_main_queue()) { // 2
                if result.valueForKey(self.INPUTTEXT_KEY) as! String == self.mem_Text {
                    self.cellsEntity = result.valueForKey(self.ENTITY_KEY) as! [DummyEntity]
                    print("Reload Data")

                    self.tableView.reloadData()
                    self.searchTableViewDelegate!.stack = 0.0
                }
            }
        }
        
    }
    
    // Get query result
    func searchProcessing(inputText:String) -> NSMutableDictionary{
//        var starttime = NSDate().timeIntervalSince1970
        let cells = DatabaseHelper.sharedInstance.queryTextInput(inputText)
//        var endtime = NSDate().timeIntervalSince1970
        //println("searchProcessing Duration : \(endtime-starttime) Seconds")
        let dictionary = NSMutableDictionary()
        dictionary.setObject(cells, forKey: ENTITY_KEY)
        dictionary.setObject(inputText, forKey: INPUTTEXT_KEY)
        return dictionary
    }
    
    // On press search button
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        print("Resign call")
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func searchShowOnTouch(sender: UIButton) {
        searchTextField.becomeFirstResponder()
    }
    // ----------------------------- End Search Text field Section ----------------------------- //
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Push Data Here
        print("Prepare for Segue \(segue.identifier)")
    }
    
    // MARK: - Word delegate back
    
    @IBAction func sendDataFromChildToParent(segue: UIStoryboardSegue) {
//        let childViewController:WordViewController = segue.sourceViewController as! WordViewController;
        print("Receive data from Child \(segue.identifier)")
    }
    
    
}

