//
//  MeaningEntityView.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 6/6/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class MeaningEntityView : UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var borderline: UIView!
    @IBOutlet weak var tableContainer: UIView!
    
    let DEBUG_MeaningEntityView = true
    let fileName = "MeaningEntityView"
    
    let meaningCellIdentifier = "meaningCellIdentifier"
    
    let dataList = ["Hi I am handsome 1.","Hi I am handsome 2.","Hi I am handsome 3.","Hi I am handsome 4.","Hi I am handsome 5."]
    let sectionList = ["section 1.","section 2."]
    let sectionListNumber = [2,3]
    
    let cellHeight = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTableSize() {
        Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "setTableSize", text: "\(tableContainer.frame)")
        Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "setTableSize", text: "\(tableview.frame)")
        
    }
    
    func getHeight() -> CGFloat{
        
        var height = meaningLabel.frame.height + 16 + 16 + borderline.frame.height
        height += CGFloat(22*dataList.count)
        height += CGFloat(100 * sectionList.count)
       
        return CGFloat(height)
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 22
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "numberOfRowsInSection", text: "\(dataList.count)")
        
        return sectionListNumber[section]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        var cell = tableView.dequeueReusableCellWithIdentifier(meaningCellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: meaningCellIdentifier)
        }

        cell?.textLabel!.text = dataList[row]
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
}