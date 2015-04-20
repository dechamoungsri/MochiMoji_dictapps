//
//  SearchViewController.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 1/26/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
            { _ in completion() }
    }
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let entityCellIdentifier = "searchResultEntittyCellidentifier"
    var cellsEntity = [Entity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var paddingView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.searchTextField.leftView = paddingView
        self.searchTextField.leftViewMode = UITextFieldViewMode.Always
        self.searchTextField.becomeFirstResponder()
        menuButton.transform = CGAffineTransformMakeScale(0.001, 0.001)
        searchButton.transform = CGAffineTransformMakeScale(0.001, 0.001)
        
        // Intitial cell view
        //self.tableView.registerClass(SearchResultEntityCell.self, forCellReuseIdentifier: entityCellIdentifier)
        let nibName = UINib(nibName: "SearchResultEntityCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: entityCellIdentifier)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        menuButton.layer.setAffineTransform(CGAffineTransformMakeScale(0.5, 0.5))

    }
    
    // ============================= Start Table Sectionnnnnnnnn ============================= //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("numberOfRowsInSection")
        return 0//cellsEntity.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(entityCellIdentifier, forIndexPath: indexPath) as SearchResultEntityCell
        
        let row = indexPath.row
        //println(row)
        cell.setComponentExample("\(row)")
        
        return cell
    }
    
    func endUpdates() {
        println("endUpdates")
    }
    
    // ----------------------------- End Table Sectionnnnnnnnn ----------------------------- //
    
    // ============================= Start Search Text field Section ============================= //
    
    @IBAction func searchTextFieldEditingChanged(sender: UITextField) {
        
        var inputText:String = searchTextField.text
        if inputText == "" {
            return
        }
        
        println("Search Input text is : \(inputText)")
        searchProcessing(inputText)
        
    }
    
    func searchProcessing(inputText:String){
        var starttime = NSDate().timeIntervalSince1970
        cellsEntity = DatabaseHelper.sharedInstance.queryTextInput(inputText)
        tableView.reloadData()
        var endtime = NSDate().timeIntervalSince1970
        println("searchProcessing Duration : \(endtime-starttime) Seconds")
    }
    
    // On press search button
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        println("Resign call")
        textField.resignFirstResponder()
        return true
    }
    
    // ----------------------------- End Search Text field Section ----------------------------- //
    
    var finish_check_list:[Bool] = []
    let max_anim = 1
    @IBAction func backPressed(sender: UIButton) {
        
        searchTextField.textColor = colorWithHexString("#2D8BCE")
        var searchTextFieldColor = searchTextField.pop_animationForKey("searchTextFieldColor") as? POPSpringAnimation
        if (searchTextFieldColor != nil) {
            searchTextFieldColor!.toValue = colorWithHexString("#2D8BCE")
        }
        else {
            searchTextFieldColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
            searchTextFieldColor!.toValue = colorWithHexString("#2D8BCE")
            searchTextFieldColor!.completionBlock = {
                (animation, finished) in
                self.finish_check_list.append(finished)
                if (self.finish_check_list.count == self.max_anim) {
                    self.moveToMainPage()
                }
            }
            searchTextField.pop_addAnimation(searchTextFieldColor, forKey: "searchTextFieldColor")
        }
        
        scaleToComponent(backButton, scaleTo: 0.0001)
        scaleToComponent(cancelButton, scaleTo: 0.0001)
        scaleToComponent(menuButton, scaleTo: 1)
        scaleToComponent(searchButton, scaleTo: 1)
    }
    
    func moveToMainPage(){
        self.performSegueWithIdentifier("backToMain", sender: self)
    }
    
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
            scaleXY!.springBounciness = 5.0
            scaleXY!.springSpeed = 20.0
            //view.pop_addAnimation(scaleXY, forKey: name)
        }
        
        return scaleXY!
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
