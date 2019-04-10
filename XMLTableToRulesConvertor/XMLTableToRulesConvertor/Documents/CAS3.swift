//
//  CAS3.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 10/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class CAS3 {
    
    static func generateTable52() -> Table {
        let riskGroup = Atom(variable: Variable(name: "riskGroup", unit: nil, value: "CA"), op: .equal)
        
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let angle = Variable(name: "angleBetweenWallAndRelevantBoundary", unit: "degress", value: nil)
        let width = Variable(name: "widthOfFirecell", unit: "m", value: nil)
        let percentage = Variable(name: "maximumPercentageOfUnprotectedWallArea", unit: "%", value: nil)
        
        let distanceValues = [1,1,2,3]
        var thenValues: [[Int]] = []
        
        thenValues.append([0,80,100])
        thenValues.append([0,60,80,100])
        thenValues.append([0,90,100])
        thenValues.append([0,66,90,100])
        thenValues.append([0,100])
        thenValues.append([0,70,100])
        
        thenValues.append([]) //90
        
        thenValues.append([0,100])
        thenValues.append([0,70,100])
        thenValues.append([0,90,100])
        thenValues.append([0,66,90,100])
        thenValues.append([0,80,100])
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
                
                rule.addThen(atom: Atom(variable: percentage.settingValue(val: String(thenVal)), op: .equal))
                
                table.addRule(rule: rule)
            }
        }
        
        return table
    }
    
    static func generateTable53() -> Table {
        let distance = Variable(name: "distanceToRelevantBoundary", unit: "m", value: nil)
        let area = Variable(name: "largestPermittedSingleUnprotectedArea", unit: "m^2", value: nil)
        let distanceToAdjecent = Variable(name: "distanceToAdjacentUnprotectedArea", unit: "m", value: nil)
        
        let distances = [1,2,3]
        
        let maxValues = [15,35,60]
        let minValues = [1.5,2.5,3.5]
        
        var table = Table(key: "t5.3")
        table.title = "Maximum size of largest permitted single unprotected area in external walls"
        
        for (index, distanceVal) in distances.enumerated() {
            var rule: Rule = Rule()
            
            rule.addIf(atom: Atom(variable: distance.settingValue(val: String(distanceVal)), op: .greaterThanEqual))
            
            rule.addThen(atom: Atom(variable: area.settingValue(val: String(maxValues[index])), op: .lessThanEqual))
            rule.addThen(atom: Atom(variable: distanceToAdjecent.settingValue(val: String(minValues[index])), op: .greaterThanEqual))
            
            table.addRule(rule: rule)
        }
                
        return table
    }
    
    static func generateTable71() -> Table {
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
