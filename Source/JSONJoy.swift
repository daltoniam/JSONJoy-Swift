//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  JSONJoy.swift
//
//  Created by Dalton Cherry on 9/17/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public enum JSONError: Error {
    case wrongType
}

open class JSONDecoder {
    var value: Any?
    
    ///return the value raw
    open var rawValue: Any? {
        return value
    }
    ///print the description of the JSONDecoder
    open var description: String {
        return self.print()
    }
    ///convert the value to a String
    open var string: String? {
        return value as? String
    }

    ///convert the value to an Int
    open var integer: Int? {
        return value as? Int
    }
    ///convert the value to an UInt
    open var unsigned: UInt? {
        return value as? UInt
    }
    ///convert the value to a Double
    open var double: Double? {
        return value as? Double
    }
    ///convert the value to a float
    open var float: Float? {
        return value as? Float
    }
    ///convert the value to an NSNumber
    open var number: NSNumber? {
        return value as? NSNumber
    }
    ///treat the value as a bool
    open var bool: Bool {
        if let val = self.rawValue as? Bool {
            return val
        } else if let str = self.string {
            let lower = str.lowercased()
            if lower == "true" || Int(lower) ?? 0 > 0 {
                return true
            }
        } else if let num = self.integer {
            return num > 0
        } else if let num = self.double {
            return num > 0.99
        } else if let num = self.float {
            return num > 0.99
        }
        return false
    }
    //get  the value if it is an error
    open var error: NSError? {
        return value as? NSError
    }
    //get  the value if it is a dictionary
    open var dictionary: Dictionary<String,JSONDecoder>? {
        return value as? Dictionary<String,JSONDecoder>
    }
    //get  the value if it is an array
    open var array: Array<JSONDecoder>? {
        return value as? Array<JSONDecoder>
    }
    
    //get the string and have it throw if it doesn't work
    open func getString() throws -> String {
        guard let str = string else {throw JSONError.wrongType}
        return str
    }
    
    //get the int and have it throw if it doesn't work
    open func getInt() throws -> Int {
        guard let i = integer else {throw JSONError.wrongType}
        return i
    }
    
    //get the unsigned and have it throw if it doesn't work
    open func getUnsigned() throws -> UInt {
        guard let i = unsigned else {throw JSONError.wrongType}
        return i
    }
    
    //get the double and have it throw if it doesn't work
    open func getDouble() throws -> Double {
        guard let i = double else {throw JSONError.wrongType}
        return i
    }
    
    //get the Float and have it throw if it doesn't work
    open func getFloat() throws -> Float {
        guard let i = float else {throw JSONError.wrongType}
        return i
    }
    
    //get the number and have it throw if it doesn't work
    open func getFloat() throws -> NSNumber {
        guard let i = number else {throw JSONError.wrongType}
        return i
    }
    
    //get the bool and have it throw if it doesn't work
    open func getBool() throws -> Bool {
        if let _ = value as? NSNull {
            throw JSONError.wrongType
        }
        return bool
    }
    
    //pull the raw values out of an array
    open func getArray<T>(_ collect: inout Array<T>?) {
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
    ///pull the raw values out of a dictionary.
    open func getDictionary<T>(_ collect: inout Dictionary<String,T>?) {
        if let dictionary = value as? Dictionary<String,JSONDecoder> {
            if collect == nil {
                collect = Dictionary<String,T>()
            }
            for (key,decoder) in dictionary {
                if let obj = decoder.value as? T {
                    collect?[key] = obj
                }
            }
        }
    }
    //get the unsigned and have it return nil it doesn't work
    open func getUnsigned() -> UInt? {
        return getAsOptional { () throws -> UInt in
            return try getUnsigned()
        }
    }
    //get the string and have it return nil it doesn't work
    open func getString() -> String? {
        return getAsOptional { () throws -> String in
            return try getString()
        }
    }
    //get the double and have it return nil it doesn't work
    open func getDouble() -> Double? {
        return getAsOptional { () throws -> Double in
            return try getDouble()
        }
    }
    //get the float and have it return nil it doesn't work
    open func getFloat() -> Float? {
        return getAsOptional { () throws -> Float in
            return try getFloat()
        }
    }
    //get the NSNumber and have it return nil it doesn't work
    open func getFloat() -> NSNumber? {
        return getAsOptional { () throws -> NSNumber in
            return try getFloat()
        }
    }
    //get the bool and have it return nil it doesn't work
    open func getBool() -> Bool? {
        return getAsOptional { () throws -> Bool in
            return try getBool()
        }
    }
    //get the int and have it return nil it doesn't work
    open func getInt() -> Int? {
        return getAsOptional { () throws -> Int in
            return try getInt()
        }
    }
    //function used to transform throw -> optional
    private func getAsOptional<T> (l : () throws -> T) -> T? {
        do { return try l() }
        catch { return nil }
    }
    
    ///the init that converts everything to something nice
    public init(_ raw: Any, isSub: Bool = false) {
        var rawObject: Any = raw
        if let str = rawObject as? String , !isSub {
            rawObject = str.data(using: String.Encoding.utf8)! as Any
        }
        if let data = rawObject as? Data {
            var response: Any?
            do {
                try response = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                rawObject = response!
            }
            catch let error as NSError {
                value = error
                return
            }
        }
        if let array = rawObject as? NSArray {
            var collect = [JSONDecoder]()
            for val: Any in array {
                collect.append(JSONDecoder(val, isSub: true))
            }
            value = collect as Any?
        } else if let dict = rawObject as? NSDictionary {
            var collect = Dictionary<String,JSONDecoder>()
            for (key,val) in dict {
                collect[key as! String] = JSONDecoder(val as AnyObject, isSub: true)
            }
            value = collect as Any?
        } else {
            value = rawObject
        }
    }
    ///Array access support
    open subscript(index: Int) -> JSONDecoder {
        get {
            if let array = self.value as? NSArray {
                if array.count > index {
                    return array[index] as! JSONDecoder
                }
            }
            return JSONDecoder(createError("index: \(index) is greater than array or this is not an Array type."))
        }
    }
    ///Dictionary access support
    open subscript(key: String) -> JSONDecoder {
        get {
            if let dict = self.value as? NSDictionary {
                if let value: Any = dict[key] {
                    return value as! JSONDecoder
                }
            }
            return JSONDecoder(createError("key: \(key) does not exist or this is not a Dictionary type"))
        }
    }
    ///private method to create an error
    func createError(_ text: String) -> NSError {
        return NSError(domain: "JSONJoy", code: 1002, userInfo: [NSLocalizedDescriptionKey: text]);
    }
    
    ///print the decoder in a JSON format. Helpful for debugging.
    open func print() -> String {
        if let arr = self.array {
            var str = "["
            for decoder in arr {
                str += decoder.print() + ","
            }
            str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))
            return str + "]"
        } else if let dict = self.dictionary {
            var str = "{"
            for (key, decoder) in dict {
                str += "\"\(key)\": \(decoder.print()),"
            }
            str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))
            return str + "}"
        }
        if let v = value {
            if let s = self.string {
                return "\"\(s)\""
            } else if let _ = value as? NSNull {
                return "null"
            }
            return "\(v)"
        }
        return ""
    }
}

///Implement this protocol on all objects you want to use JSONJoy with
public protocol JSONJoy {
    init(_ decoder: JSONDecoder) throws
}
