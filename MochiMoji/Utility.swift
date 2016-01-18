//
//  Utility.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/12/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}

class Utility {

    enum ElementStatus {
        case NULL
        case DICTIONARY
        case ARRAY
    }
    
    class func nsobjectToString(anyObject:AnyObject) -> String{
        var error :NSError?
        let jsData: NSData?
        do {
            jsData = try NSJSONSerialization.dataWithJSONObject(anyObject, options: NSJSONWritingOptions())
        } catch let error1 as NSError {
            error = error1
            jsData = nil
        }
        let nsJson = NSString(data: jsData!, encoding: NSUTF8StringEncoding) as! String
        return nsJson
    }

    class func getArrayForKey(dictionary:NSDictionary, keyString:String) -> [Any]? {
        switch Utility.statusDictionary(dictionary, key: keyString) {
        case .NULL:
            return nil
        case .DICTIONARY:
            var d_array = [Any]()
            if let d = dictionary.objectForKey(keyString) as? NSDictionary {
                d_array.append(d)
            }
            else if let d = dictionary.objectForKey(keyString) as? NSString {
                d_array.append(d)
            }
            else {
                // DEBUG Must remove when release
                let d: AnyObject? = dictionary.objectForKey(keyString)
                d_array.append(d)
            }
            return d_array
        case .ARRAY:
            let d = dictionary.objectForKey(keyString) as! NSArray
            var d_array = [Any]()
            for var i = 0 ; i < d.count ; i++ {
                if let dict = d[i] as? NSDictionary {
                    d_array.append(dict)
                }
                else if let str = d[i] as? NSString {
                    d_array.append(str)
                }
//                else {
//                    // DEBUG Must remove when release
//                    d_array.append(d[i])
//                }
            }
            return d_array
        }
    }
    
    class func statusDictionary(dictionary:NSDictionary, key:String) -> ElementStatus{
        if dictionary[key] != nil {
            
            if let _ = (dictionary as NSDictionary).objectForKey(key) as? NSArray {
                return ElementStatus.ARRAY
            }
            else {
                //let d:NSDictionary = dictionary.objectForKey(key) as NSDictionary!
                return ElementStatus.DICTIONARY
            }
            
        }
        else {
            return ElementStatus.NULL
        }
    }
    
    class func hasPrefix(str:String, prefix:String) -> Bool{
        if let hasPrefix = str.hasPrefix(prefix) as Bool? {
            return hasPrefix
        }
        print("\(str) \(prefix) nil return")
        return false
    }
    
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if cString.characters.count != 6 {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func debug_println(debug:Bool, swift_file:String, function:String, text:String){
        if debug {
            print("\n Debug\n\t Class : \(swift_file)\n\t Function : \(function)\n\t Text : \(text)\n")
        }
        
    }
    
}