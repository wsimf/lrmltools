//
//  Rule.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 8/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

struct Rule: CustomStringConvertible {
    
    private var ifs: [AtomRepresentable] = []
    private var thens: [AtomRepresentable] = []
    
    var ifCombinationBool: BooleanValue = .and
    var thenCombinationBool: BooleanValue = .and
    
    var deontic: Deontic = .obligation
    
    var key: String = ""
    
    mutating func addIf(atom: AtomRepresentable) {
        self.ifs.append(atom)
    }
    
    mutating func addThen(atom: AtomRepresentable) {
        self.thens.append(atom)
    }
    
    var description: String {
        var result = "<rule key=\"\(self.key)\">"
        result.append(self.createIf(atoms: BooleanedAtoms(atoms: self.ifs, bool: self.ifCombinationBool)))
        result.append(self.createThen(atoms: BooleanedAtoms(atoms: self.thens, bool: self.thenCombinationBool), deontic: self.deontic))
        result.append("</rule>")
        return result
    }
    
    private func createIf(atoms: BooleanedAtoms) -> String {
        var result = ""
        result.append("<if>")
        result.append(atoms.description)
        result.append("</if>")
        return result
    }
    
    private func createThen(atoms: BooleanedAtoms, deontic: Deontic) -> String {
        var result = ""
        result.append("<then>")
        result.append(deontic.start)
        result.append(atoms.description)
        result.append(deontic.end)
        result.append("</then>")
        return result
    }

}
