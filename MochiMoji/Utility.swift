//
//  Utility.swift
//  MochiMoji
//
//  Created by Decha Moungsri on 4/12/2558 BE.
//  Copyright (c) 2558 Decha Moungsri. All rights reserved.
//

import Foundation

class Utility {

    enum ElementStatus {
        case null
        case dictionary
        case array
    }
    
    class func nsobjectToString(_ anyObject:AnyObject) -> String{
        var error :NSError?
        let jsData: Data?
        do {
            jsData = try JSONSerialization.data(withJSONObject: anyObject, options: JSONSerialization.WritingOptions())
        } catch let error1 as NSError {
            error = error1
            jsData = nil
        }
        let nsJson = NSString(data: jsData!, encoding: String.Encoding.utf8.rawValue) as! String
        return nsJson
    }

    class func getArrayForKey(_ dictionary:NSDictionary, keyString:String) -> [Any]? {
        switch Utility.statusDictionary(dictionary, key: keyString) {
        case .null:
            return nil
        case .dictionary:
            var d_array = [Any]()
            if let d = dictionary.object(forKey: keyString) as? NSDictionary {
                d_array.append(d)
            }
            else if let d = dictionary.object(forKey: keyString) as? NSString {
                d_array.append(d)
            }
            else {
                // DEBUG Must remove when release
                let d: AnyObject? = dictionary.object(forKey: keyString) as AnyObject?
                d_array.append(d)
            }
            return d_array
        case .array:
            let d = dictionary.object(forKey: keyString) as! NSArray
            var d_array = [Any]()
            for i in 0  ..< d.count  {
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
    
    class func statusDictionary(_ dictionary:NSDictionary, key:String) -> ElementStatus{
        if dictionary[key] != nil {
            
            if let _ = (dictionary as NSDictionary).object(forKey: key) as? NSArray {
                return ElementStatus.array
            }
            else {
                //let d:NSDictionary = dictionary.objectForKey(key) as NSDictionary!
                return ElementStatus.dictionary
            }
            
        }
        else {
            return ElementStatus.null
        }
    }
    
    class func hasPrefix(_ str:String, prefix:String) -> Bool{
        if let hasPrefix = str.hasPrefix(prefix) as Bool? {
            return hasPrefix
        }
        print("\(str) \(prefix) nil return")
        return false
    }
    
    class func colorWithHexString (_ hex:String) -> UIColor {
//        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercased()
        
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if cString.characters.count != 6 {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func debug_println(_ debug:Bool, swift_file:String, function:String, text:String){
        if debug {
            print("\n Debug\n\t Class : \(swift_file)\n\t Function : \(function)\n\t Text : \(text)\n")
        }
        
    }
    
}
