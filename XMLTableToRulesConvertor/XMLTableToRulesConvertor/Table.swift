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
    
    init(key: String) {
        self.key = key
    }
    
    mutating func addRule(rule: Rule) {
        var rule = rule
        rule.key = "\(self.key).\(self.rules.count + 1)"
        self.rules.append(rule)
    }
    
    var description: String {
        var result = ""
        if let title = self.title {
            result.append("<rules key=\"\(self.key)\" title=\"\(title)\">")
        } else {
            result.append("<rules key=\"\(self.key)\">")
        }
        
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
