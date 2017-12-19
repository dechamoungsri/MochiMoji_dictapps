//
//  MeaningEntityView.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 6/6/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

extension String {
    subscript (index: Int) -> Character {
//        let charIndex = self.startIndex.advancedBy(index)
        let charIndex = self.index(self.startIndex, offsetBy:index)
        return self[charIndex]
    }
    
    subscript (range: Range<Int>) -> String {
//        let startIndex = self.startIndex.advancedBy(range.startIndex)
        let startIndex = self.index(self.startIndex, offsetBy:range.lowerBound)
//        let endIndex = startIndex.advancedBy(range.count)
        let endIndex = self.index(self.startIndex, offsetBy:range.count)
        
        return self[startIndex..<endIndex]
    }
}


class MeaningEntityView : UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var borderline: UIView!
    @IBOutlet weak var tableContainer: UIView!
    
    let screenWidth:CGFloat = UIScreen.main.bounds.size.width
    let screenHeight:CGFloat = UIScreen.main.bounds.size.height
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadTable(){
        // Table Cell initialization
        let nibCellName = UINib(nibName: "MeaningTableRowCell", bundle:nil)
        tableview.register(nibCellName, forCellReuseIdentifier: meaningCellIdentifier)

        tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    func setData(_ entity:Entity){
        // TODO: Check Before set
        let jmDict = entity as! JMDictEntity
        var senses = jmDict.englishEntityList
        
        var posTemp: [String]
        posTemp = senses[0][JMDictEntity.KEY.posKey.rawValue] as! [String]
        
        for i in 0  ..< senses.count  {
            let sense = senses[i]
            var pos = sense[JMDictEntity.KEY.posKey.rawValue] as! [String]
            if pos.count == 0 {
                pos = posTemp
            }
            else {
                posTemp = pos
            }
            
            let meanings = sense[JMDictEntity.KEY.glossKey.rawValue] as! [NSDictionary]
            //println(meanings)
            
            let dict = NSMutableDictionary()
            dict.setObject(pos, forKey: JMDictEntity.KEY.posKey.rawValue as NSCopying)
            dict.setObject(meanings, forKey: JMDictEntity.KEY.glossKey.rawValue as NSCopying)
            
            senseList.append(dict)
            
        }
        
    }
    
    func getHeight() -> CGFloat{
        
        var height:CGFloat = 16 + meaningLabel.frame.height + 16 + 16 + borderline.frame.height
        
        for i in 0  ..< senseList.count  {
            for j in 0 ..< (senseList[i][JMDictEntity.KEY.glossKey.rawValue]! as AnyObject).count  {
                height += getEstimatedHeightFromLabel(retrievedTextFromSensesList(i, row: j))
            }
        }
        
        height += (sectionHeight + footerHeight) * CGFloat(senseList.count)
       
        return CGFloat(height)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "estimatedHeightForRowAtIndexPath", text: "\(indexPath.section) \(indexPath.row)")
        
        return cellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return senseList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "numberOfRowsInSection", text: "\(dataList.count)")
        let a = JMDictEntity.KEY.glossKey.rawValue
        let d = senseList[section]
        return (d.object(forKey: a) as AnyObject).count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView.loadFromNibNamed("MeaningTableSectionCell") as! MeaningTableSectionCell
        sectionView.frame = CGRect(x: 0.0, y: 0.0, width: tableview.frame.width, height: sectionHeight)
        
        sectionView.partOfSpeechLabel.text = getPartOfSpeechList(section)
        
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "viewForHeaderInSection", text: "\(section)")
        
        return sectionView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "heightForRowAtIndexPath", text: "\(indexPath.section) \(indexPath.row)")
        
        let height:CGFloat = getEstimatedHeightFromLabel(retrievedTextFromSensesList(indexPath.section, row: indexPath.row)) //CGFloat(20 * (indexPath.section+1))
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: meaningCellIdentifier) as! MeaningTableRowCell

        // TODO: Force to be english
        cell.meaningLabel.text = retrievedTextFromSensesList(section, row: row)
        
         //dataList[row]
        
        Utility.debug_println(DEBUG_MeaningEntityView, swift_file: fileName, function: "cellForRowAtIndexPath", text: "\(indexPath.section) \(indexPath.row) \(cell.meaningLabel.text)")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableview.frame.width, height: footerHeight))
        sectionView.backgroundColor = UIColor.white
        return sectionView
    }
    
    // MARK: Factory section
    
    func getPartOfSpeechList(_ section:Int) -> String{
        
        var str = ""
        
        if let pos = (senseList[section][JMDictEntity.KEY.posKey.rawValue] as? [String]) {
            for i in 0  ..< pos.count  {
                str += pos[i] + ", "
            }
        }
        
//        return str[CountableRange<Int>(0 ..< str.characters.count-2)]
        let s = Int(str.characters.count)-2
        return str[0..<s]
        
    }
    
    func retrievedTextFromSensesList(_ section:Int, row:Int) -> String?{
        if let dict = (senseList[section][JMDictEntity.KEY.glossKey.rawValue] as? [NSDictionary]) {
            if let str = dict[row][JMDictEntity.KEY.meaningKey.rawValue] as? String {
                return str
            }
        }
        return nil
    }
    
    func getEstimatedHeightFromLabel(_ text:String?) -> CGFloat{

        if text == nil {
            return 0
        }
        
        let base_width = screenWidth
            - 32 - 16 // TableView Leading and trailing
            - 16 - 8 // Leading space plus default cell space
        
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 22)
        label.numberOfLines = 0
        label.text = text
        label.frame.size.width = base_width
        label.sizeToFit()
        
        return label.frame.size.height
        
    }
    
}
