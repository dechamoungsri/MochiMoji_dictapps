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
    
    let screenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    let screenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
    
    let DEBUG_MeaningEntityView = true
    let fileName = "MeaningEntityView"
    
    let meaningCellIdentifier = "meaningCellIdentifier"
    let meaningSectionIdentifier = "meaningSectionIdentifier"
    
//    let dataList = ["Hi I am handsome 1.","Hi I am handsome 2. Hi I am handsome 2.Hi I am handsome 2.Hi I am handsome 2.Hi I am handsome 2.Hi I am handsome 2.Hi I am handsome 2.","Hi I am handsome 3.","Hi I am handsome 4.","Hi I am handsome 5."]
//    
//    let sectionList = ["section 1.","section 2."]
//    let sectionListNumber = [2,3]
//    
    let cellHeight: CGFloat = 200
    let sectionHeight: CGFloat = 14
    let footerHeight: CGFloat = 8
    
    var senseList = [NSDictionary]() //Section
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadTable(){
        // Table Cell initialization
        let nibCellName = UINib(nibName: "MeaningTableRowCell", bundle:nil)
        tableview.registerNib(nibCellName, forCellReuseIdentifier: meaningCellIdentifier)

        tableview.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    func setData(entity:Entity){
        // TODO: Check Before set
        var jmDict = entity as! JMDictEntity
        var senses = jmDict.englishEntityList
        
        var posTemp: [String]
        posTemp = senses[0][JMDictEntity.KEY.posKey.rawValue] as! [String]
        
        for var i = 0 ; i < senses.count ; i++ {
            let sense = senses[i]
            var pos = sense[JMDictEntity.KEY.posKey.rawValue] as! [String]
            if pos.count == 0 {
                pos = posTemp
            }
            else {
                posTemp = pos
            }
            
            var meanings = sense[JMDictEntity.KEY.glossKey.rawValue] as! [NSDictionary]
            //println(meanings)
            
            var dict = NSMutableDictionary()
            dict.setObject(pos, forKey: JMDictEntity.KEY.posKey.rawValue)
            dict.setObject(meanings, forKey: JMDictEntity.KEY.glossKey.rawValue)
            
            senseList.append(dict)
            
        }
        
    }
    
    func getHeight() -> CGFloat{
        
        var height:CGFloat = 16 + meaningLabel.frame.height + 16 + 16 + borderline.frame.height
        
        for var i = 0 ; i < senseList.count ; i++ {
            for var j = 0 ; j < senseList[i][JMDictEntity.KEY.glossKey.rawValue]!.count ; j++ {
                height += getEstimatedHeightFromLabel(retrievedTextFromSensesList(i, row: j))
            }
        }
        
        height += (sectionHeight + footerHeight) * CGFloat(senseList.count)
       
        return CGFloat(height)
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "estimatedHeightForRowAtIndexPath", text: "\(indexPath.section) \(indexPath.row)")
        
        return cellHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return senseList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "numberOfRowsInSection", text: "\(dataList.count)")
        
        return senseList[section][JMDictEntity.KEY.glossKey.rawValue]!.count
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView.loadFromNibNamed("MeaningTableSectionCell") as! MeaningTableSectionCell
        sectionView.frame = CGRectMake(0.0, 0.0, tableview.frame.width, sectionHeight)
        
        sectionView.partOfSpeechLabel.text = getPartOfSpeechList(section)
        
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "viewForHeaderInSection", text: "\(section)")
        
        return sectionView
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "heightForRowAtIndexPath", text: "\(indexPath.section) \(indexPath.row)")
        
        var height:CGFloat = getEstimatedHeightFromLabel(retrievedTextFromSensesList(indexPath.section, row: indexPath.row)) //CGFloat(20 * (indexPath.section+1))
        
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier(meaningCellIdentifier) as! MeaningTableRowCell

        // TODO: Force to be english
        cell.meaningLabel.text = retrievedTextFromSensesList(section, row: row)
        
         //dataList[row]
        
        Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "cellForRowAtIndexPath", text: "\(indexPath.section) \(indexPath.row) \(cell.meaningLabel.text)")
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRectMake(0.0, 0.0, tableview.frame.width, footerHeight))
        sectionView.backgroundColor = UIColor.whiteColor()
        return sectionView
    }
    
    // MARK: Factory section
    
    func getPartOfSpeechList(section:Int) -> String{
        
        var str = ""
        
        if let pos = (senseList[section][JMDictEntity.KEY.posKey.rawValue] as? [String]) {
            for var i = 0 ; i < pos.count ; i++ {
                str += pos[i] + ", "
            }
        }
        
        return str[Range<Int>(start: 0, end: count(str)-2)]
        
    }
    
    func retrievedTextFromSensesList(section:Int, row:Int) -> String?{
        if let dict = (senseList[section][JMDictEntity.KEY.glossKey.rawValue] as? [NSDictionary]) {
            if let str = dict[row][JMDictEntity.KEY.meaningKey.rawValue] as? String {
                return str
            }
        }
        return nil
    }
    
    func getEstimatedHeightFromLabel(text:String?) -> CGFloat{

        if text == nil {
            return 0
        }
        
        let base_width = screenWidth - 2*32 - 24 - 8
        
        var label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 22)
        label.numberOfLines = 0
        label.text = text
        label.frame.size.width = base_width
        label.sizeToFit()
        
        return label.frame.size.height
        
    }
    
}