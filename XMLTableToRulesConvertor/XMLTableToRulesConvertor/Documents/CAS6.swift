//
//  CAS6.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 12/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class CAS6: Document {
    
    func generateTable(for id: String, in subDocument: String? = nil) -> Table? {
        switch id {
        case "3.2": return self.generateTable32()
        case "5.1": return self.generateTable51()
        case "5.2": return self.generateTable52()
        case "5.3": return self.generateTable53()
        default: return nil
        }
    }
    
    private func generateTable32() -> Table {
        let deadEnd = Atom(variable: Variable(name: "deop", unit: "m", value: nil), op: .lessThanEqual)
        let total = Atom(variable: Variable(name: "top", unit: "m", value: nil), op: .lessThanEqual)
        
        let system = Atom(variable: Variable(name: "fireSafetySystem", unit: nil, value: nil), op: .equal)
        
        var ruleKey = Atom(variable: Variable(name: "rule", unit: nil, value: "nil"), op: .equal)
        ruleKey.rel = "key"
        
        var table = Table(key: "t3.2")
        table.title = "Travel distances on escape routes for risk group WS"
        
        var rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type6"))
        rule.addThen(atom: deadEnd.settingValue(val: "50"))
        rule.addThen(atom: total.settingValue(val: "120"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type7"))
        rule.addThen(atom: deadEnd.settingValue(val: "75"))
        rule.addThen(atom: total.settingValue(val: "180"))
        table.addRule(rule: rule)
        
        table.notes = ["If smoke detection systems are installed in order to extend permissible travel distance in accordance with this table and are not a requirement of Paragraph 2.2.1 then Fire Service connection is not required."]
        
        return table
    }
    
    private func generateTable51() -> Table {
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let area = Variable(name: "typeBArea", unit: "m^2", value: nil)
        
        let sprinkleredGlazingValues = [1.0,1.5,2.5,3.5,5.0,6.5,7.5,8.5,9.5,10.0,11.0,12.0,13.0,14.0,15.0]
        let sprinkleredValues = [0.0,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7]

        assert(sprinkleredValues.count == sprinkleredGlazingValues.count)
        
        var table = Table(key: "t5.1")
        table.title = "Permitted areas of fire resisting glazing"
        
        for (index, val) in sprinkleredValues.enumerated() {
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(sprinkleredValues[index - 1])), op: .greaterThan))
            }
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(sprinkleredGlazingValues[index])), op: .lessThanEqual))
            
            table.addRule(rule: rule)
        }
        
        return table
    }
    
    private func generateTable52() -> Table {
        let riskGroup = Atom(variable: Variable(name: "riskGroup", unit: nil, value: "WS"), op: .equal)
        
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let angle = Variable(name: "angleBetweenWallAndRelevantBoundary", unit: "degress", value: nil)
        let width = Variable(name: "widthOfFirecell", unit: "m", value: nil)
        let percentage = Variable(name: "percentageOfUnprotectedWallArea", unit: "%", value: nil)
        
        let distanceValues = [1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        var thenValues: [[Int]] = []
        
        thenValues.append([0,20,30,30,35,40,45,50,60,65,70,80,90,100])
        thenValues.append([0,20,25,30,35,40,40,50,55,60,65,70,80,85,95,100])
        thenValues.append([0,25,30,35,40,45,50,60,65,80,90,100])
        thenValues.append([0,20,30,30,35,40,45,50,60,65,75,80,90,100])
        thenValues.append([0,25,30,35,40,50,60,70,85,100])
        thenValues.append([0,20,25,30,35,40,50,60,65,75,90,100])
        
        thenValues.append([]) //90
        
        thenValues.append([0,25,30,35,40,50,60,70,85,100])
        thenValues.append([0,20,25,30,35,40,50,60,65,75,90,100])
        thenValues.append([0,25,30,35,40,45,50,60,65,80,90,100])
        thenValues.append([0,20,30,30,35,40,45,50,60,65,75,80,90,100])
        thenValues.append([0,20,30,30,35,40,45,50,60,65,70,80,90,100])
        thenValues.append([0,20,25,30,35,40,40,50,55,60,65,70,80,85,95,100])
        
        func angleAtom(for index: Int) -> AtomRepresentable {
            switch index {
            case 0,1:
                return Atom(variable: angle.settingValue(val: "45"), op: .lessThanEqual)
                
            case 2,3:
                let atom1 = Atom(variable: angle.settingValue(val: "46"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "60"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 4,5:
                let atom1 = Atom(variable: angle.settingValue(val: "61"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "89"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 6: //case 90
                return Atom(variable: angle.settingValue(val: "90"), op: .equal)
                
            case 7,8:
                let atom1 = Atom(variable: angle.settingValue(val: "91"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "120"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 9,10:
                let atom1 = Atom(variable: angle.settingValue(val: "121"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "135"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            case 11,12:
                let atom1 = Atom(variable: angle.settingValue(val: "136"), op: .greaterThanEqual)
                let atom2 = Atom(variable: angle.settingValue(val: "180"), op: .lessThanEqual)
                return BooleanedAtoms(atoms: [atom1, atom2], bool: .and)
                
            default: fatalError("Unknown index \(index)")
            }
        }
        
        func widthAtom(for index: Int) -> AtomRepresentable {
            if index % 2 == 0 {
                return Atom(variable: width.settingValue(val: "20"), op: .lessThanEqual)
            } else {
                return Atom(variable: width.settingValue(val: "20"), op: .greaterThan)
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
                rule.addIf(atom: widthAtom(for: colIndex))
                
                rule.addThen(atom: Atom(variable: percentage.settingValue(val: String(thenVal)), op: .lessThanEqual))
                
                table.addRule(rule: rule)
            }
        }
        
        return table
    }
    
    private func generateTable53() -> Table {
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let area = Variable(name: "largestPermittedSingleUnprotectedArea", unit: "m^2", value: nil)
        let distanceToAdjecent = Variable(name: "distanceToAdjacentUnprotectedArea", unit: "m", value: nil)
        
        let distances = [1,2,3,4,5]
        let sprinkledMaxValues = [15,35,60,96,139]
        let sprinkledMinValues = [1.5,2.5,3.5,4,4.5]
        
        var table = Table(key: "t5.3")
        table.title = "Maximum size of largest permitted single unprotected area in external walls"
        
        for (index, distanceVal) in distances.enumerated() {
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(distanceVal)), op: .greaterThanEqual))
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(sprinkledMaxValues[index])), op: .lessThanEqual))
            rule.addThen(atom: Atom(variable: distanceToAdjecent.settingValue(val: String(sprinkledMinValues[index])), op: .greaterThanEqual))
            
            table.addRule(rule: rule)
        }
        
        var rule = Rule()
        
        rule.addIf(atom: Atom(variable: distance.settingValue(val: String(6)), op: .greaterThanEqual))
        
        rule.addThen(atom: Atom(variable: area.settingValue(val: "No restriction"), op: .equal))
        rule.addThen(atom: Atom(variable: distanceToAdjecent.settingValue(val: "No restriction"), op: .greaterThanEqual))
        
        table.addRule(rule: rule)
        
        return table
    }
}
