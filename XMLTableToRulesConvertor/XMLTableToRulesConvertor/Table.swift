//
//  Table.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 8/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

struct Table: CustomStringConvertible {
    
    var rules: [Rule] = []
    var notes: [String]? = nil
    
    var key: String
    var title: String? = nil
    
    var refValues: [String]? = nil
    var refTypes: [String]? = nil
    
    init(key: String) {
        self.key = key
    }
    
    mutating func addRule(rule: Rule) {
        var rule = rule
        rule.key = "\(self.key).\(self.rules.count + 1)"
        self.rules.append(rule)
    }
    
    var description: String {
        let attributes: [String : String] = {
            var result: [String : String] = [:]
            result["key"] = self.key
            if let title = self.title {
                result["title"] = title
            }
            
            if let refValues = self.refValues {
                result["keyRef"] = refValues.joined(separator: ",")
            }
            
            if let refTypes = self.refTypes {
                result["type"] = refTypes.joined(separator: ",")
            }
            return result
        }()
        
        let attributesSort = attributes.sorted { (lhs, rhs) -> Bool in
            if lhs.key == "key" { return true }
            if lhs.key == "title" { return true }
            return false
        }
        
        var result = "<rules"
        attributesSort.forEach { (val) in
            result.append(" \(val.key)=\"\(val.value)\"")
        }
        
        result.append(">")
        
        
        self.rules.forEach { (rule) in
            result.append(rule.description)
        }
        
        if let notes = self.notes {
            result.append("<notes>")
            for (index, note) in notes.enumerated() {
                result.append("<note key=\"\(self.key).\(index + 1)\">")
                result.append(note)
                result.append("</note>")
            }
            
            result.append("</notes>")
        }
        
        result.append("</rules>")
        
        return result
    }
}
