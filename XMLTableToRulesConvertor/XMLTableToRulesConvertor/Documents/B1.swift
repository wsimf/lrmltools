//
//  B1.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 25/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class B1: Document {
    
    func generateTable(for id: String, in subDocument: String?) -> Table? {
        switch subDocument {
        case "1", "2", "3", "4", "5": return nil
        case "6":
            let doc = Document6()
            switch id {
            case "1": return doc.generateTable1()
            default: return nil
            }
            
        default:
            return nil
        }
    }
    
    private class Document6 {
        
        fileprivate func generateTable1() -> Table {
            var table = Table(key: "t1")
            table.title = "Chimney Breast Openings and Lintels"
            table.refTypes = ["Paragraph", "Figure"]
            table.refValues = ["1.5.1", "4"]
            
            let widthmm = Variable(name: "openingWidth", unit: "mm", value: nil)
            let widthm = Variable(name: "openingWidth", unit: "m", value: nil)
            
            let material = Atom(variable: Variable(name: "chimneyBreastMaterial", unit: nil, value: nil), op: .equal)
            let linting = Atom(variable: Variable(name: "lintelReinforcing", unit: nil, value: nil), op: .equal, rel: "type")

            do {
                let metal = Atom(variable: Variable(name: "metal", unit: nil, value: nil), op: .equal, rel: "type")
                
                var rule = Rule()
                rule.addIf(atom: material.settingValue(val: "brick"))
                rule.addIf(atom: Atom(variable: widthm.settingValue(val: "1.0"), op: .lessThanEqual))
                
                var dimen1 = DimentionAtom(width: 65, depth: nil, tickness: 10)
                dimen1.setAllUnits(to: "mm")
                dimen1.otherAtoms = [linting.settingValue(val: "mildSteel"), metal.settingValue(val: "flat")]
                rule.addThen(atom: dimen1)
                
                var dimen2 = DimentionAtom(width: 80, depth: 60, tickness: 5)
                dimen2.setAllUnits(to: "mm")
                dimen2.otherAtoms = [linting.settingValue(val: "mildSteel"), metal.settingValue(val: "angle")]
                rule.addThen(atom: dimen2)
                
                rule.thenCombinationBool = .or
                table.addRule(rule: rule)
            }
            
            let upper = Atom(variable: Variable(name: "upperRod", unit: nil, value: nil), op: .equal)
            let lower = Atom(variable: Variable(name: "lowerRod", unit: nil, value: nil), op: .equal)
            
            var rule = Rule()
            rule.addIf(atom: material.settingValue(val: "concrete"))
            rule.addIf(atom: Atom(variable: widthmm.settingValue(val: "900"), op: .lessThanEqual))
            rule.addThen(atom: linting.settingValue(val: "rod"))
            rule.addThen(atom: BooleanedAtoms(atoms: [upper.settingValue(val: "D10"), lower.settingValue(val: "D10")], bool: .and))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: material.settingValue(val: "concrete"))
            rule.addIf(atom: BooleanedAtoms(atoms: [
                Atom(variable: widthmm.settingValue(val: "900"), op: .greaterThan),
                Atom(variable: widthmm.settingValue(val: "1500"), op: .lessThanEqual)], bool: .and))
            rule.addThen(atom: linting.settingValue(val: "rod"))
            rule.addThen(atom: BooleanedAtoms(atoms: [upper.settingValue(val: "D12"), lower.settingValue(val: "D16")], bool: .and))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: material.settingValue(val: "precastPumice"))
            rule.addIf(atom: Atom(variable: widthm.settingValue(val: "1.0"), op: .lessThanEqual))
            rule.addThen(atom: linting.settingValue(val: "rod"))
            rule.addThen(atom: BooleanedAtoms(atoms: [upper.settingValue(val: "D10"), lower.settingValue(val: "D10")], bool: .and))
            table.addRule(rule: rule)
            
            table.notes = ["Horizontal reinforcing rods to concrete and precast pumice are to be placed one above the other at a spacing of 75 mm, and have R6 ties at 150 mm maximum centres."]
            
            return table
        }
    }
    
    static func generateTable7() -> Table {
        var table = Table(key: "")
        table.title = ""
        table.refTypes = ["Paragraph"]
        table.refValues = ["8.3.e"]
        
        
        
        return table
    }
}
