//
//  Components.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 8/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

protocol XMLStartEndRepresentable {
    var start: String { get }
    var end: String { get }
}

enum Deontic: String, XMLStartEndRepresentable {
    case obligation = "obligation"
    case prohibition = "prohibition"
    case permission = "permission"
    
    var start: String { return "<\(self.rawValue)>"}
    var end: String { return "</\(self.rawValue)>"}
}

enum BooleanValue: String, XMLStartEndRepresentable {
    case and = "and"
    case or = "or"
    
    var start: String { return "<\(self.rawValue)>"}
    var end: String { return "</\(self.rawValue)>"}
}

enum Operator: String, XMLStartEndRepresentable {
    case equal = "equal"
    case lessThanEqual = "lessThanEqual"
    case lessThan = "lessThan"
    case greaterThanEqual = "greaterThanEqual"
    case greaterThan = "greaterThan"
    
    var start: String { return "<\(self.rawValue)>"}
    var end: String { return "</\(self.rawValue)>"}
}

struct Variable: CustomStringConvertible {
    var name: String
    var unit: String? = nil
    var value: String? = nil
    
    var description: String {
        var result = ""
        
        result.append("<var>")
        result.append(self.name)
        result.append("</var>")
        
        if let value = self.value {
            result.append("<val>")
            result.append(value)
            if let unit = self.unit {
                result.append(" \(unit)")
            }
            
            result.append("</val>")
        }
        
        return result
    }
    
    func settingValue(val: String) -> Variable {
        var atom = self
        atom.value = val
        return atom
    }
}


