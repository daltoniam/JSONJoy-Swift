//
//  JSONDecoder+Description.swift
//  JSONJoy
//
//  Created by Denis Chaschin on 05.01.17.
//

import Foundation

extension JSONDecoder: CustomStringConvertible {
    public var description: String {
        if let value = value {
            return String(describing: value)
        } else {
            return String(describing: value)
        }
    }
}

extension JSONDecoder: CustomDebugStringConvertible {
    public var debugDescription: String {
        if let value = value {
            return String(reflecting: value)
        } else {
            return String(reflecting: value)
        }
    }
}
