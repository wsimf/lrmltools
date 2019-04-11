//
//  CAS5.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 11/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class CAS5 {
    
    static func generateTable20() -> Table {
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
    
    static func generateTable32() -> Table {
        let deadEnd = Atom(variable: Variable(name: "escapeRoute", unit: nil, value: "deadEndOpenPath"), op: .equal)
        let total = Atom(variable: Variable(name: "escapeRoute", unit: nil, value: "totalOpenPath"), op: .equal)
        
        let system = Atom(variable: Variable(name: "system", unit: nil, value: nil), op: .equal)
        
        let distance = Atom(variable: Variable(name: "travelDistance", unit: "m", value: nil), op: .equal)
        
        var table = Table(key: "t3.2")
        table.title = "Travel distances on escape routes for risk group WB"
        
        var rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [system.settingValue(val: "none"), system.settingValue(val: "type2")], bool: .or))
        rule.addIf(atom: deadEnd)
        rule.addThen(atom: distance.settingValue(val: "25"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: BooleanedAtoms(atoms: [system.settingValue(val: "none"), system.settingValue(val: "type2")], bool: .or))
        rule.addIf(atom: total)
        rule.addThen(atom: system.settingValue(val: "60"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type4"))
        rule.addIf(atom: deadEnd)
        rule.addThen(atom: distance.settingValue(val: "50"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type4"))
        rule.addIf(atom: total)
        rule.addThen(atom: distance.settingValue(val: "120"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type6"))
        rule.addIf(atom: deadEnd)
        rule.addThen(atom: distance.settingValue(val: "50"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type6"))
        rule.addIf(atom: total)
        rule.addThen(atom: distance.settingValue(val: "120"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type7"))
        rule.addIf(atom: deadEnd)
        rule.addThen(atom: distance.settingValue(val: "75"))
        table.addRule(rule: rule)
        
        rule = Rule()
        rule.addIf(atom: system.settingValue(val: "type7"))
        rule.addIf(atom: total)
        rule.addThen(atom: distance.settingValue(val: "150"))
        table.addRule(rule: rule)
        
        table.notes = ["If open path length increases for smoke detectors are being applied, where Acceptable Solution F7/AS1 allows heat detectors to be substituted for smoke detectors, not less than 70% of the firecell shall be protected with smoke detectors. Heat detectors cannot be substituted for smoke detectors in exitways.", "If smoke and heat detection systems are installed in order to extend permissible travel distance in accordance with this table and are not a requirement of Paragraph 2.2.1 then Fire Service connection is not required."]
        
        return table
    }
}
