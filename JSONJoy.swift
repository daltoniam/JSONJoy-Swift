//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  JSONJoy.swift
//
//  Created by Dalton Cherry on 9/17/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

public class JSONDecoder {
    var value: AnyObject?
    
    //convert the value to a String
    public var string: String? {
        return value as? String
    }
    //convert the value to an Int
    public var integer: Int? {
        return value as? Int
    }
    //convert the value to a Double
    public var double: Double? {
        return value as? Double
    }
    //convert the value to a float
    public var float: Float? {
        return value as? Float
    }
    //get  the value if it is an error
    public var error: NSError? {
        return value as? NSError
    }
    //get  the value if it is a dictonary
    public var dictonary: Dictionary<String,JSONDecoder>? {
        return value as? Dictionary<String,JSONDecoder>
    }
    //get  the value if it is an array
    public var array: Array<JSONDecoder>? {
        return value as? Array<JSONDecoder>
    }
    //pull the raw values out of an array
    public func getArray<T>(inout collect: Array<T>?) {
        if let array = value as? Array<JSONDecoder> {
            if collect == nil {
                collect = Array<T>()
            }
            for decoder in array {
                if let obj = decoder.value as? T {
                    collect?.append(obj)
                }
            }
        }
    }
    //pull the raw values out of a dictonary.
    public func getDictonary<T>(inout collect: Dictionary<String,T>?) {
        if let dictonary = value as? Dictionary<String,JSONDecoder> {
            if collect == nil {
                collect = Dictionary<String,T>()
            }
            for (key,decoder) in dictonary {
                if let obj = decoder.value as? T {
                    collect?[key] = obj
                }
            }
        }
    }
    //the init that converts everything to something nice
    public init(_ raw: AnyObject) {
        var rawObject: AnyObject = raw
        if let data = rawObject as? NSData {
            var error: NSError?
            var response: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
            if error != nil || response == nil {
                value = error
                return
            }
            rawObject = response!
        }
        if let array = rawObject as? NSArray {
            var collect = [JSONDecoder]()
            for val: AnyObject in array {
                collect.append(JSONDecoder(val))
            }
            value = collect
        } else if let dict = rawObject as? NSDictionary {
            var collect = Dictionary<String,JSONDecoder>()
            for (key,val: AnyObject) in dict {
                collect[key as String] = JSONDecoder(val)
            }
            value = collect
        } else {
            value = rawObject
        }
    }
    //Array access support
    public subscript(index: Int) -> JSONDecoder {
        get {
            if let array = self.value as? NSArray {
                if array.count > index {
                    return array[index] as JSONDecoder
                }
            }
            return JSONDecoder(createError("index: \(index) is greater than array or this is not an Array type."))
        }
    }
    //Dictionary access support
    public subscript(key: String) -> JSONDecoder {
        get {
            if let dict = self.value as? NSDictionary {
                if let value: AnyObject = dict[key] {
                    return value as JSONDecoder
                }
            }
            return JSONDecoder(createError("key: \(key) does not exist or this is not a Dictionary type"))
        }
    }
    func createError(text: String) -> NSError {
        return NSError(domain: "JSONJoy", code: 1002, userInfo: [NSLocalizedDescriptionKey: text]);
    }
}

//Implement this protocol on all objects you want to use JSONJoy with
public protocol JSONJoy {
    init(_ decoder: JSONDecoder)
}
