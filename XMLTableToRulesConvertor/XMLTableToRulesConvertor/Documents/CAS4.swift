//
//  CAS4.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 10/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class CAS4: Document {
    
    func generateTable(for id: String, in subDocument: String? = nil) -> Table? {
        switch id {
        case "3.2": return self.generateTable32()
        case "5.1": return self.generateTable51()
        case "5.2": return self.generateTable52()
        case "5.3": return self.generateTable53()
        case "5.4": return self.generateTable54()
        case "7.1": return self.generateTable71()
        default: return nil
        }
    }
    
    private func generateTable32() -> Table {
        let deadEnd = Atom(variable: Variable(name: "deadEndOpenPath", unit: "m", value: nil), op: .lessThanEqual)
        let total = Atom(variable: Variable(name: "totalOpenPath", unit: "m", value: nil), op: .lessThanEqual)
        
        let system = Atom(variable: Variable(name: "fireSafetySystem", unit: nil, value: nil), op: .equal)
        
        var ruleKey = Atom(variable: Variable(name: "rule", unit: nil, value: "nil"), op: .equal)
        ruleKey.rel = "key"
        
        var table = Table(key: "t3.2")
        table.title = "Travel distances on escape routes for risk group CA"
        
        var rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [system.settingValue(val: "none"), system.settingValue(val: "type2")], bool: .or))
        rule.addThen(atom: deadEnd.settingValue(val: "20"))
        rule.addThen(atom: total.settingValue(val: "50"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type4"))
        rule.addThen(atom: deadEnd.settingValue(val: "40"))
        rule.addThen(atom: total.settingValue(val: "100"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type6"))
        rule.addThen(atom: deadEnd.settingValue(val: "40"))
        rule.addThen(atom: total.settingValue(val: "100"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type7"))
        rule.addThen(atom: deadEnd.settingValue(val: "50"))
        rule.addThen(atom: total.settingValue(val: "120"))
        table.addRule(rule: rule)
        
        table.notes = ["If open path length increases for smoke detectors are being applied, where Acceptable Solution F7/AS1 allows heat detectors to be substituted for smoke detectors, not less than 70% of the firecell shall be protected with smoke detectors. Heat detectors cannot be substituted for smoke detectors in exitways.", "If smoke and heat detection systems are installed in order to extend permissible travel distance in accordance with this table and are not a requirement of Paragraph 2.2.1 then Fire Service connection is not required."]
        
        return table
    }
    
    private func generateTable51() -> Table {
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let area = Variable(name: "typeBArea", unit: "m^2", value: nil)
        let firecell = Variable(name: "firecellProtection", unit: nil, value: nil)
        
        let unsprinkleredGlazingArea = [1.0,1.5,2.0,3.0,3.5,4.5,5.5,7.0,8.0,8.5,9.5,10.0,11.0,12.0,13.0,14.0,15.0]
        let unsprinkleredValues = [0.0,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.9,2.0,2.1,2.2,2.3]
        
        let sprinkleredGlazingValues = [5.0,6.5,7.5,9.0,10.0,11.0,13.0,14.0,15.0]
        let sprinkleredValues = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8]
        
        assert(unsprinkleredGlazingArea.count == unsprinkleredValues.count)
        assert(sprinkleredValues.count == sprinkleredGlazingValues.count)
        
        var table = Table(key: "t5.1")
        
        for (index, val) in unsprinkleredValues.enumerated() {
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(unsprinkleredValues[index - 1])), op: .greaterThan))
            }
            
            rule.addIf(atom: Atom(variable: firecell.settingValue(val: "unsprinklered"), op: .equal))
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(unsprinkleredGlazingArea[index])), op: .lessThanEqual))
            
            table.addRule(rule: rule)
        }
        
        for (index, val) in sprinkleredValues.enumerated() {
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(sprinkleredValues[index - 1])), op: .greaterThan))
            }
            
            rule.addIf(atom: Atom(variable: firecell.settingValue(val: "sprinklered"), op: .equal))
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(sprinkleredGlazingValues[index])), op: .lessThanEqual))
            
            
            table.addRule(rule: rule)
        }
        
        return table
    }
    
    private func generateTable52() -> Table {
        let riskGroup = Atom(variable: Variable(name: "riskGroup", unit: nil, value: "CA"), op: .equal)
        
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let angle = Variable(name: "angleBetweenWallAndRelevantBoundary", unit: "degress", value: nil)
        let firecell = Variable(name: "firecellProtection", unit: nil, value: nil)
        let width = Variable(name: "widthOfFirecell", unit: "m", value: nil)
        let percentage = Variable(name: "percentageOfUnprotectedWallArea", unit: "%", value: nil)
        
        let distanceValues = [1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
        var thenValues: [[Int]] = []
        
        thenValues.append([0,20,22,25,30,40,45,55,65,75,90,100])
        thenValues.append([0,20,20,25,30,30,35,40,45,50,55,65,70,80,90,95,100])
        thenValues.append([0,40,44,50,60,80,90,100])
        thenValues.append([0,40,40,50,60,60,70,80,90,100])
        thenValues.append([0,20,25,30,40,50,60,70,85,95,100])
        thenValues.append([0,20,20,25,30,30,40,45,50,55,65,75,85,95,100])
        thenValues.append([0,40,50,60,80,100])
        thenValues.append([0,40,40,60,60,60,80,90,100])
        thenValues.append([0,23,30,39,50,64,79,90,100])
        thenValues.append([0,20,22,25,30,40,45,55,65,75,90,100])
        thenValues.append([0,46,60,78,100])
        thenValues.append([0,40,44,50,60,80,90,100])
        
        thenValues.append([]) //90
        
        thenValues.append([0,23,30,39,50,64,79,90,100])
        thenValues.append([0,20,22,25,30,40,45,55,65,75,90,100])
        thenValues.append([0,46,60,78,100])
        thenValues.append([0,40,44,50,60,80,90,100])
        thenValues.append([0,20,25,30,40,50,60,70,85,95,100])
        thenValues.append([0,20,20,25,30,30,40,45,50,55,65,75,85,95,100])
        thenValues.append([0,40,50,60,80,100])
        thenValues.append([0,40,40,60,60,60,80,90,100])
        thenValues.append([0,20,22,25,30,40,45,55,65,76,90,100])
        thenValues.append([0,20,20,25,30,30,35,40,45,50,55,65,70,80,90,95,100])
        thenValues.append([0,40,44,50,60,80,90,100])
        thenValues.append([0,40,40,50,60,60,70,80,90,100])
        
        func angleAtom(for index: Int) -> AtomRepresentable {
            switch index {
            case 0,1,2,3:
                return Atom(variable: angle.settingValue(val: "45"), op: .lessThanEqual)
                
            case 4,5,6,7:
                let atom1 = Atom(variable: angle.settingValue(val: "46"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "60"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 8,9,10,11:
                let atom1 = Atom(variable: angle.settingValue(val: "61"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "89"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 12: //case 90
                return Atom(variable: angle.settingValue(val: "90"), op: .equal)
                
            case 13,14,15,16:
                let atom1 = Atom(variable: angle.settingValue(val: "91"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "120"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 17,18,19,20:
                let atom1 = Atom(variable: angle.settingValue(val: "121"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "135"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 21,22,23,24:
                let atom1 = Atom(variable: angle.settingValue(val: "136"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "180"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            default: fatalError("Unknown index \(index)")
            }
        }
        
        func firecellAtom(for index: Int) -> AtomRepresentable {
            switch index {
            case 0,1,4,5,8,9,15,16,19,20,23,24:
                return Atom(variable: firecell.settingValue(val: "unsprinklered"), op: .equal)
                
            default:
                return Atom(variable: firecell.settingValue(val: "sprinklered"), op: .equal)
            }
        }
        
        func widthAtom(for index: Int) -> AtomRepresentable {
            if index % 2 == 0 {
                return Atom(variable: width.settingValue(val: "10"), op: .lessThanEqual)
            } else {
                return Atom(variable: width.settingValue(val: "10"), op: .greaterThan)
            }
        }
        
        var table = Table(key: "t5.2")
        table.title = "Maximum percentage of unprotected area for external walls"
        
        for (colIndex, val) in thenValues.enumerated() {
            for (rowIndex, thenVal) in val.enumerated() {
                var rule = Rule()
                rule.addIf(atom: riskGroup)
                
                let distanceVal = distanceValues[rowIndex]
                if rowIndex == 0 {
                    rule.addIf(atom: Atom(variable: distance.settingValue(val: String(distanceVal)), op: .lessThan))
                } else if rowIndex == val.count - 1 {
                    rule.addIf(atom: Atom(variable: distance.settingValue(val: String(distanceVal)), op: .greaterThanEqual))
                } else {
                    let distance1 = Atom(variable: distance.settingValue(val: String(distanceVal)), op: .greaterThanEqual)
                    let distance2 = Atom(variable: distance.settingValue(val: String(distanceValues[rowIndex + 1])), op: .lessThanEqual)
                    rule.addIf(atom: BooleanedAtoms(atoms: [distance1, distance2], bool: .and))
                }
                
                rule.addIf(atom: angleAtom(for: colIndex))
                rule.addIf(atom: firecellAtom(for: colIndex))
                rule.addIf(atom: widthAtom(for: colIndex))
                
                rule.addThen(atom: Atom(variable: percentage.settingValue(val: String(thenVal)), op: .lessThanEqual))
                
                table.addRule(rule: rule)
            }
        }
        
        return table
    }
    
    private func generateTable53() -> Table {
        let firecell = Variable(name: "firecellProtection", unit: nil, value: nil)
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let area = Variable(name: "largestPermittedSingleUnprotectedArea", unit: "m^2", value: nil)
        let distanceToAdjecent = Variable(name: "distanceToAdjacentUnprotectedArea", unit: "m", value: nil)
        
        let distances = [1,2,3,4,5,6,7,8,9,10]
        let unsprinkledMaxValues = [1,4,10,16,23,31,40,51,64,77]
        let unsprinkledMinValues = [0.5,1,5,7,8,8.5,9.5,11,13,13.5]
        
        let sprinkledMaxValues = [15,35,60,96,139]
        let sprinkledMinValues = [1.5,2.5,3.5,4,4.5]
        
        var table = Table(key: "t5.3")
        table.title = "Maximum size of largest permitted single unprotected area in external walls"
        
        for (index, distanceVal) in distances.enumerated() {
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: firecell.settingValue(val: "unsprinklered"), op: .equal))
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(distanceVal)), op: .greaterThanEqual))
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(unsprinkledMaxValues[index])), op: .lessThanEqual))
            rule.addThen(atom: Atom(variable: distanceToAdjecent.settingValue(val: String(unsprinkledMinValues[index])), op: .greaterThanEqual))
            
            table.addRule(rule: rule)
        }
        
        for (index, distanceVal) in distances.enumerated() {
            if index >= 5 {
                break
            }
            
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: firecell.settingValue(val: "sprinklered"), op: .equal))
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(distanceVal)), op: .greaterThanEqual))
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(sprinkledMaxValues[index])), op: .lessThanEqual))
            rule.addThen(atom: Atom(variable: distanceToAdjecent.settingValue(val: String(sprinkledMinValues[index])), op: .greaterThanEqual))
            
            table.addRule(rule: rule)
        }
        
        var rule = Rule()
        
        rule.addIf(atom: Atom(variable: firecell.settingValue(val: "sprinklered"), op: .equal))
        rule.addIf(atom: Atom(variable: distance.settingValue(val: String(6)), op: .greaterThanEqual))
        
        rule.addThen(atom: Atom(variable: area.settingValue(val: "No Requirement"), op: .equal))
        rule.addThen(atom: Atom(variable: distanceToAdjecent.settingValue(val: "No Requirement"), op: .greaterThanEqual))
        
        table.addRule(rule: rule)
        
        return table
    }
    
    private func generateTable54() -> Table {
        let apron = Variable(name: "apronProjection", unit: "m", value: nil)
        let height = Variable(name: "spandrelHeight", unit: "m", value: nil)
        
        var table = Table(key: "t5.4")
        table.title = "Combinations of aprons and spandrels"
        
        var rule = Rule()
        rule.addIf(atom: Atom(variable: apron.settingValue(val: "0.3"), op: .lessThan))
        rule.addThen(atom: Atom(variable: height.settingValue(val: "1.5"), op: .greaterThanEqual))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: Atom(variable: apron.settingValue(val: "0.3"), op: .greaterThanEqual))
        rule.addIf(atom: Atom(variable: apron.settingValue(val: "0.45"), op: .lessThan))
        rule.addThen(atom: Atom(variable: height.settingValue(val: "1"), op: .greaterThanEqual))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: Atom(variable: apron.settingValue(val: "0.45"), op: .greaterThanEqual))
        rule.addIf(atom: Atom(variable: apron.settingValue(val: "0.6"), op: .lessThan))
        rule.addThen(atom: Atom(variable: height.settingValue(val: "0.5"), op: .greaterThanEqual))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.deontic = .permission
        rule.addIf(atom: Atom(variable: apron.settingValue(val: "0.6"), op: .greaterThanEqual))
        rule.addThen(atom: Atom(variable: height.settingValue(val: "0"), op: .equal))
        table.addRule(rule: rule)
        
        return table
    }
    
    private func generateTable71() -> Table {
        let construction = Variable(name: "chimneyConstruction", unit: nil, value: nil)
        let jambTicknessEx = Variable(name: "chimneyJambThicknessExcludingFillingAndFlueLiner", unit: "mm", value: nil)
        let backTicknessEx = Variable(name: "chimneyBackThicknessExcludingFillingAndFlueLiner", unit: "mm", value: nil)
        let jambTicknessIn = Variable(name: "chimneyJambThicknessIncludingFillingAndFlueLiner", unit: "mm", value: nil)
        let backTicknessIn = Variable(name: "chimneyBackThicknessIncludingFillingAndFlueLiner", unit: "mm", value: nil)
        
        let breast = Variable(name: "chimneyBreast", unit: "mm", value: nil)
        let side = Variable(name: "chimneySideGathering", unit: "mm", value: nil)
        
        let constructionValues = ["concrete", "brickwork", "precastPumiceConcrete"]
        var exValues = [170,155,85]
        var inValues = [255,230,170]
        
        var breastValues = [170,155,85]
        
        var table = Table(key: "t7.1")
        table.title = "Minimum acceptable dimensions of chimneys"
        
        for (index, val) in constructionValues.enumerated() {
            var rule = Rule()
            rule.addIf(atom: Atom(variable: construction.settingValue(val: val), op: .equal))
            
            rule.addThen(atom: Atom(variable: jambTicknessEx.settingValue(val: String(exValues[index])), op: .lessThanEqual))
            rule.addThen(atom: Atom(variable: backTicknessEx.settingValue(val: String(exValues[index])), op: .lessThanEqual))
            
            rule.addThen(atom: Atom(variable: jambTicknessIn.settingValue(val: String(inValues[index])), op: .lessThanEqual))
            rule.addThen(atom: Atom(variable: backTicknessIn.settingValue(val: String(inValues[index])), op: .lessThanEqual))
            
            rule.addThen(atom: Atom(variable: breast.settingValue(val: String(breastValues[index])), op: .lessThanEqual))
            rule.addThen(atom: Atom(variable: side.settingValue(val: String(breastValues[index])), op: .lessThanEqual))
            
            table.addRule(rule: rule)
        }
        
        return table
    }
}
