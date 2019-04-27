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
            case "2": return doc.generateTable2()
            default: return nil
            }
            
        case "7":
            let doc = Document7()
            switch id {
            case "1": return doc.generateTable1()
            case "2": return doc.generateTable2()
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
        
        fileprivate func generateTable2() -> Table {
            var table = Table(key: "t2")
            table.title = "Bracing Units Required for Each Chimney Connection to Resist Earthquake Loadings"
            table.refTypes = ["Paragraph"]
            table.refValues = ["1.9.1.c", "1.9.3"]
            
            let construction = Atom(variable: Variable(name: "chimneyConstruction", unit: nil, value: nil), op: .equal)
            let type = Atom(variable: Variable(name: "chimneyType", unit: nil, value: nil), op: .equal)
            
            let eqZone = Atom(variable: Variable(name: "earthquakeZone", unit: nil, value: nil), op: .equal)
            
            let stack = Atom(variable: Variable(name: "chimneyStackSize", unit: nil, value: nil), op: .equal)
            let base = Atom(variable: Variable(name: "chimneyBaseSize", unit: nil, value: nil), op: .equal)
            let braceUnits = Atom(variable: Variable(name: "braceUnit", unit: nil, value: nil), op: .equal, rel: "count")
            
            let consVals = ["precastPumiceStandard", "precastPumiceLarge", "brickSingleSkin", "brickDoubleSkin", "brick", "concrete", "concrete"]
            let types = [1,2,3,4,5,6,7]
            let stacks = ["500 x 400", "1100 x 400", "500 x 500", "590 x 590", "1200 x 680", "590 x 590", "1200 x 700"]
            let bases = ["1600 x 1050", "1600 x 1050", "1200 x 1050", "1200 x 1050", "1200 x 1050", "1200 x 1050", "1200 x 1050"]

            assert(consVals.count == types.count && stacks.count == bases.count && stacks.count == consVals.count)
            
            let zoneAvals = [60,110,90,130,240,210,390]
            let zoneBvals = [50,90,70,100,200,170,320]
            let zoneCvals = [40,70,60,80,160,140,260]
            assert(zoneAvals.count == zoneBvals.count && zoneAvals.count == zoneCvals.count)
            
            let allVals = [zoneAvals, zoneBvals, zoneCvals]
            for (zoneIndex, zoneVals) in allVals.enumerated() {
                for (zoneValueIndex, zoneVal) in zoneVals.enumerated() {
                    var rule = Rule()
                    rule.addIf(atom: construction.settingValue(val: consVals[zoneValueIndex]))
                    rule.addIf(atom: type.settingValue(val: String(types[zoneValueIndex])))
                    rule.addIf(atom: stack.settingValue(val: stacks[zoneValueIndex]))
                    rule.addIf(atom: base.settingValue(val: bases[zoneValueIndex]))
                    
                    switch zoneIndex {
                    case 0: rule.addIf(atom: eqZone.settingValue(val: "ZoneA"))
                    case 1: rule.addIf(atom: eqZone.settingValue(val: "ZoneB"))
                    case 2: rule.addIf(atom: eqZone.settingValue(val: "ZoneC"))
                    default: break
                    }
                    
                    rule.addThen(atom: braceUnits.settingValue(val: String(zoneVal)))
                    
                    table.addRule(rule: rule)
                }
            }
            
            table.notes = ["The number of bracing units required at floor connections other than the ground floor shall be taken as 60% of the value given in the table."]
            
            return table
        }
    }
    
    private class Document7 {
        
        fileprivate func generateTable1() -> Table {
            var table = Table(key: "t1")
            table.title = "Strength Reduction Factors for Shallow Foundation Design"
            table.refTypes = ["Paragraph"]
            table.refValues = ["3.5.1"]
            
            let strengthLower = Atom(variable: Variable(name: "strengthReductionFactor", unit: nil, value: nil), op: .greaterThanEqual)
            let strengthUpper = Atom(variable: Variable(name: "strengthReductionFactor", unit: nil, value: nil), op: .lessThanEqual)
            
            let earthPressure = Atom(variable: Variable(name: "earthPressure", unit: nil, value: nil), op: .equal, rel: "type")
            
            let loadCombination = Atom(variable: Variable(name: "loadCombination", unit: nil, value: "earthquakeOverstrength"), op: .equal)
            
            var rule = Rule()
            rule.addIf(atom: BooleanedAtoms(atoms: [earthPressure.settingValue(val: "bearing"), earthPressure.settingValue(val: "passive")], bool: .or))
            rule.addIf(atom: loadCombination)
            rule.addThen(atom: strengthLower.settingValue(val: "0.80"))
            rule.addThen(atom: strengthUpper.settingValue(val: "0.90"))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: BooleanedAtoms(atoms: [earthPressure.settingValue(val: "bearing"), earthPressure.settingValue(val: "passive")], bool: .or))
            rule.addIf(atom: NegatedAtom(atom: loadCombination))
            rule.addThen(atom: strengthLower.settingValue(val: "0.45"))
            rule.addThen(atom: strengthUpper.settingValue(val: "0.60"))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: earthPressure.settingValue(val: "sliding"))
            rule.addIf(atom: BooleanedAtoms(atoms: [loadCombination, NegatedAtom(atom: loadCombination)], bool: .or))
            rule.addThen(atom: strengthLower.settingValue(val: "0.80"))
            rule.addThen(atom: strengthUpper.settingValue(val: "0.90"))
            table.addRule(rule: rule)
            
            return table
        }
        
        fileprivate func generateTable2() -> Table {
            var table = Table(key: "t2")
            table.title = "Values of δI and Ks for Pile Shafts"
            table.refTypes = ["Paragraph"]
            table.refValues = ["4.1.1", "4.1.4.b", "4.1.4.c"]
            
            let pile = Atom(variable: Variable(name: "pileMaterial", unit: nil, value: nil), op: .equal)
            let delta = Atom(variable: Variable(name: "δI", unit: nil, value: nil), op: .equal)
            let rdLower = Atom(variable: Variable(name: "Rd", unit: nil, value: "40%"), op: .lessThan)
            let rdUpper = Atom(variable: Variable(name: "Rd", unit: nil, value: "40%"), op: .greaterThanEqual)
            
            let ks = Atom(variable: Variable(name: "Ks", unit: nil, value: nil), op: .equal)
            
            let pipes = ["steel", "concrete", "timber"]
            let deltaVals = ["20°", "3φI/4", "2φI/3"]
            let rdLowVals = [0.5,1.0,1.5]
            let rdUpperVals = [1.0,2.0,4.0]
            
            for (index, pipeVal) in pipes.enumerated() {
                var rule = Rule()
                rule.addIf(atom: pile.settingValue(val: pipeVal))
                rule.addIf(atom: delta.settingValue(val: deltaVals[index]))
                rule.addIf(atom: rdLower)
                rule.addThen(atom: ks.settingValue(val: String(rdLowVals[index])))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: pile.settingValue(val: pipeVal))
                rule.addIf(atom: delta.settingValue(val: deltaVals[index]))
                rule.addIf(atom: rdUpper)
                rule.addThen(atom: ks.settingValue(val: String(rdUpperVals[index])))
                table.addRule(rule: rule)
            }
            
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
