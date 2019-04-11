//
//  AtomRepresentable.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 8/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

protocol AtomRepresentable: CustomStringConvertible { }

/// Represents an atom with the optional operator
struct Atom: AtomRepresentable {
    var variable: Variable
    var rel: String? = nil
    var op: Operator?
    
    init(variable: Variable, op: Operator?) {
        self.variable = variable
        self.rel = nil
        self.op = op
    }
    
    var description: String {
        var result = ""
        if let op = self.op {
            result.append(op.start)
        }
        
        result.append("<atom>")
        if let rel = self.rel {
            result.append("<rel>")
            result.append(rel)
            result.append("</rel>")
        }
        
        result.append(variable.description)
        
        result.append("</atom>")
        
        if let op = self.op {
            result.append(op.end)
        }
        
        return result
    }
    
    func removingOp() -> Atom {
        var atom = self
        atom.op = nil
        return atom
    }
    
    func settingValue(val: String?) -> Atom {
        var atom = self
        atom.variable.value = val
        return atom
    }
}

/// Represents an array of atoms combined via a BooleanValue 
struct BooleanedAtoms: AtomRepresentable {
    
    var atoms: [AtomRepresentable]
    var bool: BooleanValue
    
    var description: String {
        var result = ""
        if atoms.count > 1 { result.append(bool.start) }
        
        atoms.forEach { (atom) in
            result.append(atom.description)
        }
        
        if atoms.count > 1 { result.append(bool.end) }
        return result
    }
}

struct NegatedAtom: AtomRepresentable {
    
    var atom: Atom
    
    var description: String {
        var result = "<not>"
        result.append(atom.description)
        result.append("</not>")
        return result
    }
}
