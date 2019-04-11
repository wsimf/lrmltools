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
    var noteRefs: [String]? = nil
    
    init(name: String, unit: String?, value: String?) {
        self.name = name
        self.unit = unit
        self.value = value
    }
    
    var description: String {
        var result = ""
        
        result.append("<var>")
        result.append(self.name)
        result.append("</var>")
        
        if let value = self.value {
            if let noteRefs = self.noteRefs {
                let noteRefString = noteRefs.joined(separator: ",")
                result.append("<val noteRef=\"\(noteRefString)\">")
            } else {
                result.append("<val>")
            }
            
            result.append(value)
            if let unit = self.unit {
                result.append(" \(unit)")
            }
            
            result.append("</val>")
        }
        
        return result
    }
    
    func settingValue(val: String, noteRefs: [String]? = nil) -> Variable {
        var atom = self
        atom.value = val
        atom.noteRefs = noteRefs
        return atom
    }

}


