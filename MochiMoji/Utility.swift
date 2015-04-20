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
        case NULL
        case DICTIONARY
        case ARRAY
    }
    
    class func nsobjectToString(anyObject:AnyObject) -> String{
        var error :NSError?
        let jsData = NSJSONSerialization.dataWithJSONObject(anyObject, options: NSJSONWritingOptions.allZeros, error: &error)
        let nsJson = NSString(data: jsData!, encoding: NSUTF8StringEncoding) as String
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
            var d = dictionary.objectForKey(keyString) as NSArray
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
            
            if let d = (dictionary as NSDictionary).objectForKey(key) as? NSArray {
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
    
}