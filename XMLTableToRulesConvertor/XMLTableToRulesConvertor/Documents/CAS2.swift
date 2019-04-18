//
//  CAS2.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 12/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class CAS2: Document {
    
    func generateTable(for id: String, in subDocument: String? = nil) -> Table? {
        switch id {
        case "2.0": return self.generateTable20()
        case "3.2": return self.generateTable32()
        case "5.1": return self.generateTable51()
        case "5.2": return self.generateTable52()
        case "5.3": return self.generateTable53()
        case "5.4": return self.generateTable54()
        default: return nil
        }
    }
    
    private func generateTable20() -> Table {
        let category = Variable(name: "category", unit: nil, value: nil)
        let height = Variable(name: "escapteHeight", unit: "m", value: nil)
        
        let varAlarmType = Variable(name: "alarmType", unit: nil, value: nil)
        let alarmType = Atom(variable: varAlarmType, op: .equal)
        
        let perCategory = Atom(variable: category.settingValue(val: "permanentAcccommodation"), op: .equal)
        let tempCategory = Atom(variable: category.settingValue(val: "temporaryAccommodation"), op: .equal)
        let eduCategory = Atom(variable: category.settingValue(val: "educationAccommodation"), op: .equal)
        
        var table = Table(key: "t2.0")
        table.title = "Alarm types for various accommodation types and escape heights"
        
        var rule = Rule()
        rule.addIf(atom: perCategory)
        rule.addIf(atom: Atom(variable: height.settingValue(val: "10"), op: .lessThanEqual))
        rule.addThen(atom: BooleanedAtoms(atoms: [alarmType.settingValue(val: "type1"), Atom(variable: varAlarmType.settingValue(val: "type2", noteRefs: ["t2.0.4","t2.0.5"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: perCategory)
        rule.addIf(atom: BooleanedAtoms(atoms: [Atom(variable: height.settingValue(val: "10"), op: .greaterThan), Atom(variable: height.settingValue(val: "25"), op: .lessThanEqual)], bool: .and))
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: varAlarmType.settingValue(val: "type5", noteRefs: ["t2.0.5","t2.0.6"]), op: .equal),
            Atom(variable: varAlarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: tempCategory)
        rule.addIf(atom: Atom(variable: height.settingValue(val: "25"), op: .lessThanEqual))
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: varAlarmType.settingValue(val: "type5", noteRefs: ["t2.0.5","t2.0.6"]), op: .equal),
            Atom(variable: varAlarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: perCategory)
        rule.addIf(atom: Atom(variable: height.settingValue(val: "25"), op: .greaterThan))
        rule.addThen(atom: BooleanedAtoms(atoms: [alarmType.settingValue(val: "type5"), alarmType.settingValue(val: "type7"), alarmType.settingValue(val: "type9"), alarmType.settingValue(val: "type18")], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: tempCategory)
        rule.addIf(atom: Atom(variable: height.settingValue(val: "25"), op: .greaterThan))
        rule.addThen(atom: BooleanedAtoms(atoms: [alarmType.settingValue(val: "type5"), alarmType.settingValue(val: "type7"), alarmType.settingValue(val: "type9"), alarmType.settingValue(val: "type18")], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: eduCategory)
        rule.addThen(atom: BooleanedAtoms(atoms: [alarmType.settingValue(val: "type5"), alarmType.settingValue(val: "type7"), alarmType.settingValue(val: "type9"), alarmType.settingValue(val: "type18")], bool: .or))
        table.addRule(rule: rule)
        
        table.notes = ["See Paragraph 2.2.1 for exceptions where not required.","See Paragraph 2.2.1 for circumstances that Type 3 or Type 6 may be substituted.","See Paragraph 2.2.1 for conditions where Type 6 may be installed.","Direct connection to the Fire Service is not required where a phone is available at all times.","See Paragraph 2.2.1 for circumstances where this system is not required.","Where not required each unit to be provided with Type 1.","See Paragraph 2.2.1 for circumstances where direct connection to Fire Service is not required.","See Paragraph 2.2.1 for circumstances where direct connection to Fire Service is not required and a Type 3 may be substituted."]
        
        return table
    }
    
    private func generateTable32() -> Table {
        let deadEnd = Atom(variable: Variable(name: "deop", unit: "m", value: nil), op: .lessThanEqual)
        let total = Atom(variable: Variable(name: "top", unit: "m", value: nil), op: .lessThanEqual)
        
        let system = Atom(variable: Variable(name: "fireSafetySystem", unit: nil, value: nil), op: .equal)
        
        var ruleKey = Atom(variable: Variable(name: "rule", unit: nil, value: "nil"), op: .equal)
        ruleKey.rel = "key"
        
        var table = Table(key: "t3.2")
        table.title = "Travel distances on escape routes for risk group SM"
        
        var rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [system.settingValue(val: "none"), system.settingValue(val: "type2")], bool: .or))
        rule.addThen(atom: deadEnd.settingValue(val: "20"))
        rule.addThen(atom: total.settingValue(val: "50"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [system.settingValue(val: "type4"), system.settingValue(val: "type5")], bool: .or))
        rule.addThen(atom: deadEnd.settingValue(val: "30"))
        rule.addThen(atom: total.settingValue(val: "75"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type6"))
        rule.addThen(atom: deadEnd.settingValue(val: "30"))
        rule.addThen(atom: total.settingValue(val: "75"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type7"))
        rule.addThen(atom: deadEnd.settingValue(val: "40"))
        rule.addThen(atom: total.settingValue(val: "100"))
        table.addRule(rule: rule)
        
        table.notes = ["If open path length increases for smoke detectors are being applied, where Acceptable Solution F7/AS1 allows heat detectors to be substituted for smoke detectors, not less than 70% of the firecell shall be protected with smoke detectors. Heat detectors cannot be substituted for smoke detectors in exitways.", "If smoke and heat detection systems are installed in order to extend permissible travel distance in accordance with this table and are not a requirement of Paragraph 2.2.1 then Fire Service connection is not required."]
        
        return table
    }
    
    private func generateTable51() -> Table {
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let area = Variable(name: "typeBArea", unit: "m^2", value: nil)
        
        let glazingValues = [1.0,1.5,2.0,3.0,3.5,5.0,6.0,7.5,8.5,10.0,12.0,13.0,14.0,15.0]
        let values = [0.0,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7]
        
        assert(values.count == glazingValues.count)
        
        var table = Table(key: "t5.1")
        table.title = "Permitted areas of fire resisting glazing in unsprinklered firecells"
        
        for (index, val) in values.enumerated() {
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(values[index - 1])), op: .greaterThan))
            }
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(glazingValues[index])), op: .lessThanEqual))
            
            table.addRule(rule: rule)
        }
        
        var rule = Rule()
        rule.addIf(atom: Atom(variable: distance.settingValue(val: "1.7"), op: .greaterThan))
        rule.addThen(atom: Atom(variable: area.settingValue(val: "unlimited"), op: .equal))
        table.addRule(rule: rule)
        
        table.notes = ["Sprinklered firecells have no limit on the area of fire resisting glazing allowed."]
        
        return table
    }
    
    private func generateTable52() -> Table {
        let riskGroup = Atom(variable: Variable(name: "riskGroup", unit: nil, value: "SM"), op: .equal)
        let firecell = Variable(name: "firecellProtection", unit: nil, value: nil)
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let angle = Variable(name: "angleBetweenWallAndRelevantBoundary", unit: "degress", value: nil)
        let width = Variable(name: "widthOfFirecell", unit: "m", value: nil)
        let percentage = Variable(name: "percentageOfUnprotectedWallArea", unit: "%", value: nil)
        
        let distanceValues = [1,1,2,3,4,5,6]
        var thenValues: [[Int]] = []
        
        thenValues.append([0,35,55,80,100])
        thenValues.append([0,30,40,55,70,90,100])
        thenValues.append([0,70,100])
        thenValues.append([0,60,80,100])
        thenValues.append([0,45,70,95,100])
        thenValues.append([0,33,45,65,90,100])
        thenValues.append([0,90,100])
        thenValues.append([0,66,90,100])
        thenValues.append([0,55,85,100])
        thenValues.append([0,35,55,80,100])
        thenValues.append([0,100])
        thenValues.append([0,70,100])
        
        thenValues.append([])
        
        thenValues.append([0,55,85,100])
        thenValues.append([0,35,55,80,100])
        thenValues.append([0,100])
        thenValues.append([0,70,100])
        thenValues.append([0,45,70,95,100])
        thenValues.append([0,33,45,65,90,100])
        thenValues.append([0,90,100])
        thenValues.append([0,66,90,100])
        thenValues.append([0,35,55,80,100])
        thenValues.append([0,30,40,55,70,90,100])
        thenValues.append([0,70,100])
        thenValues.append([0,60,80,100])
        
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
        
        func widthAtom(for index: Int) -> AtomRepresentable {
            if index % 2 == 0 {
                return Atom(variable: width.settingValue(val: "5"), op: .lessThanEqual)
            } else {
                return Atom(variable: width.settingValue(val: "5"), op: .greaterThan)
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
        
        let distances = [1,2,3,4,5,6]
        let unsprinkledMaxValues = [1,6,13,20,29,40]
        let unsprinkledMinValues = [1,1.5,4.5,5.5,6.5,7.5]
        
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
}
