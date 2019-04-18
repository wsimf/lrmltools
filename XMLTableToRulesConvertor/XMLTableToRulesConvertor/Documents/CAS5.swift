//
//  CAS5.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 11/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class CAS5: Document {
    
    func generateTable(for id: String, in subDocument: String? = nil) -> Table? {
        switch id {
        case "2.0": return self.generateTable20()
        case "3.2": return self.generateTable32()
        case "5.1": return self.generateTable51()
        case "5.2.1": return self.generateTable521()
        case "5.2.2": return self.generateTable522()
        default: return nil
        }
    }
    
    private func generateTable20() -> Table {
        let occupant = Variable(name: "occupantLoad", unit: nil, value: nil)
        let height = Variable(name: "escapteHeight", unit: "m", value: nil)
        let alarmType = Variable(name: "alarmType", unit: nil, value: nil)
        let apexHeight = Variable(name: "apexHeight", unit: nil, value: nil)
        let floorArea = Variable(name: "floorArea", unit: "m^2", value: nil)
        let storageHeight = Variable(name: "capableOfStorageHeight", unit: nil, value: nil)
        
        var table = Table(key: "t2.0")
        table.title = "Alarm types for various occupant loads, storage heights and escape heights"
        
        var rule = Rule()
        rule.addIf(atom: Atom(variable: occupant.settingValue(val: "100"), op: .lessThan))
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: storageHeight.settingValue(val: "0"), op: .greaterThanEqual),
            Atom(variable: storageHeight.settingValue(val: "3"), op: .lessThan)], bool: .and))
        
        rule.addIf(atom: Atom(variable: height.settingValue(val: "4.0"), op: .lessThanEqual))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type2", noteRefs: ["t2.0.2", "t2.0.4", "t2.0.5"]), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: Atom(variable: occupant.settingValue(val: "100"), op: .lessThan))
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: storageHeight.settingValue(val: "3"), op: .greaterThanEqual),
            Atom(variable: storageHeight.settingValue(val: "5"), op: .lessThanEqual)], bool: .and))
        
        rule.addIf(atom: Atom(variable: height.settingValue(val: "4.0"), op: .lessThanEqual))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type3", noteRefs: ["t2.0.4"]), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: Atom(variable: occupant.settingValue(val: "100"), op: .lessThan))
        rule.addIf(atom: Atom(variable: storageHeight.settingValue(val: "5"), op: .greaterThan))
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: apexHeight.settingValue(val: "8"), op: .lessThanEqual),
            Atom(variable: floorArea.settingValue(val: "4200"), op: .lessThan)], bool: .and))
        rule.addIf(atom: Atom(variable: height.settingValue(val: "4.0"), op: .lessThanEqual))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type3", noteRefs: ["t2.0.4"]), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: occupant.settingValue(val: "100"), op: .greaterThanEqual),
            Atom(variable: occupant.settingValue(val: "1000"), op: .lessThanEqual)], bool: .and))
        rule.addIf(atom: Atom(variable: storageHeight.settingValue(val: "0"), op: .equal))
        rule.addIf(atom: Atom(variable: height.settingValue(val: "4.0"), op: .lessThanEqual))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type4", noteRefs: ["t2.0.2", "t2.0.3"]), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type9"), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: occupant.settingValue(val: "100"), op: .greaterThanEqual),
            Atom(variable: occupant.settingValue(val: "1000"), op: .lessThanEqual)], bool: .and))
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: storageHeight.settingValue(val: "3"), op: .greaterThanEqual),
            Atom(variable: storageHeight.settingValue(val: "5"), op: .lessThanEqual)], bool: .and))
        
        rule.addIf(atom: Atom(variable: height.settingValue(val: "4.0"), op: .lessThanEqual))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type3", noteRefs: ["t2.0.4"]), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: occupant.settingValue(val: "100"), op: .greaterThanEqual),
            Atom(variable: occupant.settingValue(val: "1000"), op: .lessThanEqual)], bool: .and))
        rule.addIf(atom: Atom(variable: storageHeight.settingValue(val: "5"), op: .greaterThan))
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: apexHeight.settingValue(val: "8"), op: .lessThanEqual),
            Atom(variable: floorArea.settingValue(val: "4200"), op: .lessThan)], bool: .and))
        rule.addIf(atom: Atom(variable: height.settingValue(val: "4.0"), op: .lessThanEqual))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type3", noteRefs: ["t2.0.4"]), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: Atom(variable: occupant.settingValue(val: "1000"), op: .lessThanEqual))
        rule.addIf(atom: BooleanedAtoms(atoms: [
            Atom(variable: height.settingValue(val: "4.0"), op: .greaterThan),
            Atom(variable: height.settingValue(val: "25"), op: .lessThanEqual)], bool: .and))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type4", noteRefs: ["t2.0.2", "t2.0.3"]), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type9"), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: Atom(variable: occupant.settingValue(val: "1000"), op: .lessThanEqual))
        rule.addIf(atom: Atom(variable: height.settingValue(val: "25"), op: .greaterThan))
        
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type7"), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type9"), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: Atom(variable: occupant.settingValue(val: "1000"), op: .greaterThan))
        rule.addThen(atom: BooleanedAtoms(atoms: [
            Atom(variable: alarmType.settingValue(val: "type7"), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type9"), op: .equal),
            Atom(variable: alarmType.settingValue(val: "type18", noteRefs: ["t2.0.1"]), op: .equal)], bool: .or))
        table.addRule(rule: rule)
        
        return table
    }
    
    private func generateTable32() -> Table {
        let deadEnd = Atom(variable: Variable(name: "deadEndOpenPath", unit: "m", value: nil), op: .lessThanEqual)
        let total = Atom(variable: Variable(name: "totalOpenPath", unit: "m", value: nil), op: .lessThanEqual)
        
        let system = Atom(variable: Variable(name: "fireSafetySystem", unit: nil, value: nil), op: .equal)
        
        var ruleKey = Atom(variable: Variable(name: "rule", unit: nil, value: "nil"), op: .equal)
        ruleKey.rel = "key"
        
        var table = Table(key: "t3.2")
        table.title = "Travel distances on escape routes for risk group WB"
        
        var rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [system.settingValue(val: "none"), system.settingValue(val: "type2")], bool: .or))
        rule.addThen(atom: deadEnd.settingValue(val: "25"))
        rule.addThen(atom: total.settingValue(val: "60"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [system.settingValue(val: "type3"), ruleKey.settingValue(val: "t2.0.2")], bool: .and))
        rule.addThen(atom: deadEnd.settingValue(val: "35"))
        rule.addThen(atom: total.settingValue(val: "75"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type4"))
        rule.addThen(atom: deadEnd.settingValue(val: "50"))
        rule.addThen(atom: total.settingValue(val: "120"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type6"))
        rule.addThen(atom: deadEnd.settingValue(val: "50"))
        rule.addThen(atom: total.settingValue(val: "120"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type7"))
        rule.addThen(atom: deadEnd.settingValue(val: "75"))
        rule.addThen(atom: total.settingValue(val: "150"))
        table.addRule(rule: rule)
                
        table.notes = ["If open path length increases for smoke detectors are being applied, where Acceptable Solution F7/AS1 allows heat detectors to be substituted for smoke detectors, not less than 70% of the firecell shall be protected with smoke detectors. Heat detectors cannot be substituted for smoke detectors in exitways.", "If smoke and heat detection systems are installed in order to extend permissible travel distance in accordance with this table and are not a requirement of Paragraph 2.2.1 then Fire Service connection is not required."]
        
        return table
    }
    
    private func generateTable51() -> Table {
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        
        let firecell = Atom(variable: Variable(name: "firecellProtection", unit: nil, value: nil), op: .equal)
        
        let wareHouseType = Atom(variable: Variable(name: "buildingType", unit: nil, value: "warehouse"), op: .equal)
        
        let storageHeight = Variable(name: "storageHeight", unit: "m", value: nil)
        let storageHeightRequirement = BooleanedAtoms(atoms: [
            Atom(variable: storageHeight.settingValue(val: "3.0"), op: .greaterThan),
            Atom(variable: storageHeight.settingValue(val: "5.0"), op: .lessThan)], bool: .and)
        
        let area = Variable(name: "typeBArea", unit: "m^2", value: nil)
        
        var table = Table(key: "t5.1")
        table.title = "Permitted areas of fire resisting glazing"
        
        let unspNotWarehouseVal = [0.0,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.9,2.0,2.1,2.2,2.3]
        let unspNotWaGAreaVal = [1.0,1.5,2.0,2.5,3.5,4.0,5.5,7.0,8.0,8.5,9.5,10.0,11.0,12.0,13.0,14.0,15.0]
        assert(unspNotWarehouseVal.count == unspNotWaGAreaVal.count)
        
        for (index, val) in unspNotWarehouseVal.enumerated() {
            var rule = Rule()
            
            rule.addIf(atom: NegatedAtom(atom: wareHouseType))
            rule.addIf(atom: storageHeightRequirement)
            rule.addIf(atom: firecell.settingValue(val: "unsprinklered"))
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(unspNotWarehouseVal[index - 1])), op: .greaterThan))
            }
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(unspNotWaGAreaVal[index])), op: .lessThanEqual))
            table.addRule(rule: rule)
        }
        
        let spNotWarehouseVal = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8]
        let spNotWaGAreaVal = [5.0,6.0,7.5,9.0,10.0,11.0,13.0,14.0,15.0]
        assert(spNotWarehouseVal.count == spNotWaGAreaVal.count)
        
        for (index, val) in spNotWarehouseVal.enumerated() {
            var rule = Rule()
            
            rule.addIf(atom: NegatedAtom(atom: wareHouseType))
            rule.addIf(atom: storageHeightRequirement)
            rule.addIf(atom: firecell.settingValue(val: "sprinklered"))
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(spNotWarehouseVal[index - 1])), op: .greaterThan))
            }
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(spNotWaGAreaVal[index])), op: .lessThanEqual))
            table.addRule(rule: rule)
        }
        
        let unspWarehouseVal = [0.0,0.9,1.1,1.2,1.4,1.5,1.6,1.7,1.8,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.9,3.1,3.2,3.4]
        let unspWaGAreaVal = [1.0,1.5,2.0,2.5,3.5,4.0,5.0,5.5,6.0,7.0,7.5,8.0,8.5,9.0,9.5,10.0,11.0,12.0,13.0,14.0,15.0]
        assert(unspWarehouseVal.count == unspWaGAreaVal.count)
        
        for (index, val) in unspWarehouseVal.enumerated() {
            var rule = Rule()
            
            rule.addIf(atom: wareHouseType)
            rule.addIf(atom: storageHeightRequirement)
            rule.addIf(atom: firecell.settingValue(val: "unsprinklered"))
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(unspWarehouseVal[index - 1])), op: .greaterThan))
            }
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(unspWaGAreaVal[index])), op: .lessThanEqual))
            table.addRule(rule: rule)
        }
        
        let spWarehouseVal = [0.0,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7]
        let spWaGAreaVal = [1.0,1.5,2.5,3.5,5.0,6.0,7.5,8.5,9.5,10.0,11.0,12.0,13.0,14.0,15.0]
        assert(spWarehouseVal.count == spWaGAreaVal.count)
        
        for (index, val) in spWarehouseVal.enumerated() {
            var rule = Rule()
            
            rule.addIf(atom: wareHouseType)
            rule.addIf(atom: storageHeightRequirement)
            rule.addIf(atom: firecell.settingValue(val: "sprinklered"))
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(val)), op: .lessThanEqual))
            if index != 0 {
                rule.addIf(atom: Atom(variable: distance.settingValue(val: String(spWarehouseVal[index - 1])), op: .greaterThan))
            }
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(spWaGAreaVal[index])), op: .lessThanEqual))
            table.addRule(rule: rule)
        }
        
        return table
    }
    
    private func generateTable521() -> Table {
        let riskGroup = Atom(variable: Variable(name: "riskGroup", unit: nil, value: "WB"), op: .equal)
        
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let angle = Variable(name: "angleBetweenWallAndRelevantBoundary", unit: "degress", value: nil)
        let firecell = Variable(name: "firecellProtection", unit: nil, value: nil)
        let width = Variable(name: "widthOfFirecell", unit: "m", value: nil)
        let percentage = Variable(name: "percentageOfUnprotectedWallArea", unit: "%", value: nil)
        
        let storageHeight = Variable(name: "storageHeight", unit: "m", value: nil)
        let storageHeightRequirement = BooleanedAtoms(atoms: [
            Atom(variable: storageHeight.settingValue(val: "3.0"), op: .greaterThan),
            Atom(variable: storageHeight.settingValue(val: "5.0"), op: .lessThan)], bool: .and)
        
        let buildingTypeRequirement = NegatedAtom(atom: Atom(variable: Variable(name: "buildingType", unit: nil, value: "warehouse"), op: .equal))
        
        let distanceValues = [1,1,2,3,4,5,6,7,8,9,10,11,12]
        var thenValues: [[Int]] = []
        
        thenValues.append([0,20,25,30,40,50,60,75,90,100])
        thenValues.append([0,20,25,30,35,40,50,55,60,70,80,90,100])
        thenValues.append([0,40,50,60,80,100])
        thenValues.append([0,40,50,60,70,80,100])
        thenValues.append([0,20,30,40,50,65,80,90,100])
        thenValues.append([0,20,25,30,35,40,50,60,70,80,90,100])
        thenValues.append([0,40,60,80,100])
        thenValues.append([0,40,50,60,70,80,100])
        thenValues.append([0,25,35,40,50,60,75,90,100])
        thenValues.append([0,20,25,30,40,50,60,75,90,100])
        thenValues.append([0,50,70,80,100])
        thenValues.append([0,40,50,60,80,100])
        
        thenValues.append([]) //90
        
        thenValues.append([0,25,35,40,50,60,75,90,100])
        thenValues.append([0,20,25,30,40,50,60,75,90,100])
        thenValues.append([0,50,70,80,100])
        thenValues.append([0,40,50,60,80,100])
        thenValues.append([0,20,30,40,50,65,80,90,100])
        thenValues.append([0,20,25,30,35,40,50,60,70,80,90,100])
        thenValues.append([0,40,60,80,100])
        thenValues.append([0,40,50,60,70,80,100])
        thenValues.append([0,20,25,30,40,50,60,75,90,100])
        thenValues.append([0,20,25,30,35,40,50,55,60,70,80,90,100])
        thenValues.append([0,40,50,60,80,100])
        thenValues.append([0,40,50,60,70,80,100])
        
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
        
        var table = Table(key: "t5.2/1")
        table.title = "Maximum percentage of unprotected area for external walls"
        
        for (colIndex, val) in thenValues.enumerated() {
            for (rowIndex, thenVal) in val.enumerated() {
                var rule = Rule()
                rule.addIf(atom: riskGroup)
                rule.addIf(atom: buildingTypeRequirement)
                rule.addIf(atom: storageHeightRequirement)
                
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
    
    private func generateTable522() -> Table {
        let riskGroup = Atom(variable: Variable(name: "riskGroup", unit: nil, value: "WB"), op: .equal)
        
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let angle = Variable(name: "angleBetweenWallAndRelevantBoundary", unit: "degress", value: nil)
        let firecell = Variable(name: "firecellProtection", unit: nil, value: nil)
        let percentage = Variable(name: "percentageOfUnprotectedWallArea", unit: "%", value: nil)
        
        let storageHeight = Variable(name: "storageHeight", unit: "m", value: nil)
        let storageHeightRequirement = BooleanedAtoms(atoms: [
            Atom(variable: storageHeight.settingValue(val: "3.0"), op: .greaterThan),
            Atom(variable: storageHeight.settingValue(val: "5.0"), op: .lessThan)], bool: .and)
        
        let buildingTypeRequirement = Atom(variable: Variable(name: "buildingType", unit: nil, value: "warehouse"), op: .equal)
        
        var paragraphAtom = Atom(variable: Variable(name: "paragraph", unit: nil, value: "2.2.1"), op: .equal)
        paragraphAtom.rel = "key"
        
        let distanceValues = [1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        var thenValues: [[Int]] = []
        
        thenValues.append([0,10,15,20,20,25,30,35,40,40,45,50,60,65,70,100])
        thenValues.append([0,20,30,40,45,50,60,70,80,85,90,100])
        thenValues.append([0,15,15,20,25,25,30,35,45,50,55,60,70,80,85,100])
        thenValues.append([0,30,35,40,50,55,60,70,90,100])
        thenValues.append([0,15,15,20,25,30,35,40,50,55,65,70,80,90,100])
        thenValues.append([0,30,35,40,50,60,70,80,100])
        
        thenValues.append([]) //90
        
        thenValues.append([0,15,15,20,25,30,35,40,50,55,65,70,80,90,100])
        thenValues.append([0,30,35,40,50,60,70,80,100])
        thenValues.append([0,15,15,20,25,25,30,35,45,50,55,60,70,80,85,100])
        thenValues.append([0,30,35,40,50,55,60,70,90,100])
        thenValues.append([0,10,15,20,20,25,30,35,40,40,45,50,60,65,70,100])
        thenValues.append([0,20,30,40,45,50,60,70,80,85,90,100])
        
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
        
        func firecellAtom(for index: Int) -> AtomRepresentable {
            switch index {
            case 0,2,4,8,10,12:
                return Atom(variable: firecell.settingValue(val: "unsprinklered"), op: .equal)
                
            default:
                return Atom(variable: firecell.settingValue(val: "sprinklered"), op: .equal)
            }
        }
        
        var table = Table(key: "t5.2/2")
        table.title = "Maximum percentage of wall area allowed to be unprotected"
        
        for (colIndex, val) in thenValues.enumerated() {
            for (rowIndex, thenVal) in val.enumerated() {
                var rule = Rule()
                rule.addIf(atom: riskGroup)
                rule.addIf(atom: buildingTypeRequirement)
                rule.addIf(atom: BooleanedAtoms(atoms: [storageHeightRequirement, paragraphAtom], bool: .or))
                
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
                
                rule.addThen(atom: Atom(variable: percentage.settingValue(val: String(thenVal)), op: .lessThanEqual))
                
                table.addRule(rule: rule)
            }
        }
        
        table.notes = ["For warehouses with storage height 5.0 m or greater, see Acceptable Solution C/AS6 for risk group WS."]
        
        return table
    }
}
