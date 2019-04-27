//
//  E1.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 16/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

class E1: Document {
    
    func generateTable(for id: String, in subDocument: String?) -> Table? {
        let subDoc = subDocument ?? "1"
        switch subDoc {
        case "1":
            let doc = E1.Document1()
            switch id {
            case "1": return doc.generateTable1()
            case "2": return doc.generateTable2()
            case "3": return doc.generateTable3()
            case "4": return doc.generateTable4()
            case "5": return doc.generateTable5()
            case "6": return doc.generateTable6()
            default: return nil
            }
            
        case "2":
            let doc = E1.Document2()
            switch id {
            case "1": return doc.generateTable1()
            case "2": return doc.generateTable2()
            case "3": return doc.generateTable3()
            case "4": return doc.generateTable4()
            case "5": return doc.generateTable5()
            case "6": return doc.generateTable6()
            case "7": return doc.generateTable7()
            default: return nil
            }
            
        default: return nil
        }
    }
    
    private class Document1 {
        
        fileprivate func generateTable1() -> Table {
            let coefficient = Atom(variable: Variable(name: "coefficientOfRunOff", unit: nil, value: nil), op: .equal)
            
            var table = Table(key: "t1")
            table.title = "Run-off Coefficients"
            table.refTypes = ["Paragraph"]
            table.refValues = ["2.0.1","2.1.1","2.1.3"]
            
            var ns = Atom(variable: Variable(name: "naturalSurface", unit: nil, value: nil), op: .equal)
            ns.rel = "type"
            
            let nsTypes = ["bareImpermeableClay", "bareUncultivatedSoil", "heavyClayPasture", "heavyClayBush", "heavyClayCultivated", "mediumSoakagePasture", "mediumSoakageBush", "mediumSoakageCultivated", "highSoakagePasture", "highSoakageBush", "highSoakageCultivated", "parksPlaygroundsAndReservesGrassed", "parksPlaygroundsAndReservesBush", "gardens"]
            let nsVals = [0.70,0.60,0.40,0.35,0.30,0.30,0.25,0.20,0.20,0.15,0.10,0.30,0.25,0.25]
            assert(nsTypes.count == nsVals.count)
            
            for (index, type) in nsTypes.enumerated() {
                var rule = Rule()
                rule.addIf(atom: ns.settingValue(val: type))
                rule.addThen(atom: coefficient.settingValue(val: String(nsVals[index])))
                table.addRule(rule: rule)
            }
            
            var ds = Atom(variable: Variable(name: "developedSurface", unit: nil, value: nil), op: .equal)
            ds.rel = "type"
            
            let dsTypes: [Any] = ["fullyRoofed", ["steel","nonAbsorbentRoof"], ["asphalt", "concretePaved"], ["nearFlat", "slightlyAbsorbentRoof"], "pavingPanelWithSealedJoints", "pavingPanelWithOpenJoints", "unsealedRoads", ["railway", "unsealedYard"]]
            let dsVals = [0.90,0.90,0.85,0.80,0.80,0.60,0.50,0.35]
            
            for (index, type) in dsTypes.enumerated() {
                var rule = Rule()
                if let typeString = type as? String {
                    rule.addIf(atom: ns.settingValue(val: typeString))
                } else if let typeArray = type as? [String] {
                    let atoms = typeArray.compactMap({ return ds.settingValue(val: $0)} )
                    rule.addIf(atom: BooleanedAtoms(atoms: atoms, bool: .and))
                }
                
                rule.addThen(atom: coefficient.settingValue(val: String(dsVals[index])))
                table.addRule(rule: rule)
            }
            
            var ls = Atom(variable: Variable(name: "landUse", unit: nil, value: nil), op: .equal)
            ls.rel = "type"
            
            var rule = Rule()
            let atoms = ["industrialArea", "commercialArea", "shoppingArea", "townHouseDevelopment"].compactMap({ return ls.settingValue(val: $0)} )
            rule.addIf(atom: BooleanedAtoms(atoms: atoms, bool: .and))
            rule.addThen(atom: coefficient.settingValue(val: "0.65"))
            table.addRule(rule: rule)
            
            let resArea = ls.settingValue(val: "residentialArea")
            
            var imperviousArea = Atom(variable: Variable(name: "imperviousArea", unit: nil, value: "x1"), op: .equal)
            imperviousArea.rel = "area"
            
            var grossArea = Atom(variable: Variable(name: "land", unit: nil, value: "y1"), op: .equal)
            grossArea.rel = "area"
            
            rule = Rule()
            rule.addIf(atom: resArea)
            rule.addIf(atom: imperviousArea)
            rule.addIf(atom: grossArea)
            rule.addIf(atom: FunctionAtom(function: "x1/y1", type: .ratio, value: "0.36", op: .lessThan))
            rule.addThen(atom: coefficient.settingValue(val: "0.45"))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: resArea)
            rule.addIf(atom: imperviousArea)
            rule.addIf(atom: grossArea)
            rule.addIf(atom: BooleanedAtoms(atoms: [
                FunctionAtom(function: "x1/y1", type: .ratio, value: "0.36", op: .greaterThanEqual),
                FunctionAtom(function: "x1/y1", type: .ratio, value: "0.50", op: .lessThan)], bool: .and))
            rule.addThen(atom: coefficient.settingValue(val: "0.55"))
            table.addRule(rule: rule)
            
            table.notes = ["Where the impervious area exceeds 50% of gross area, use method of Paragraph 2.1.2."]
            
            return table
        }
        
        fileprivate func generateTable2() -> Table {
            var table = Table(key: "t2")
            table.title = "Slope Correction for Run-off Coefficients"
            table.refTypes = ["Paragraph"]
            table.refValues = ["2.1.3"]
            
            let groundSlope = Variable(name: "groundSlope", unit: "%", value: nil)
            let op = Atom(variable: Variable(name: "slopeCorrectionOperator", unit: nil, value: nil), op: .equal)
            let val = Atom(variable: Variable(name: "slopeCorrection", unit: nil, value: nil), op: .equal)
            
            var rule = Rule()
            rule.addIf(atom: BooleanedAtoms(atoms: [Atom(variable: groundSlope.settingValue(val: "0"), op: .greaterThanEqual), Atom(variable: groundSlope.settingValue(val: "5"), op: .lessThan)], bool: .and))
            rule.addThen(atom: op.settingValue(val: "subtract"))
            rule.addThen(atom: val.settingValue(val: "0.05"))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: BooleanedAtoms(atoms: [Atom(variable: groundSlope.settingValue(val: "5"), op: .greaterThanEqual), Atom(variable: groundSlope.settingValue(val: "10"), op: .lessThan)], bool: .and))
            rule.addThen(atom: op.settingValue(val: "no adjustment"))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: BooleanedAtoms(atoms: [Atom(variable: groundSlope.settingValue(val: "10"), op: .greaterThanEqual), Atom(variable: groundSlope.settingValue(val: "20"), op: .lessThan)], bool: .and))
            rule.addThen(atom: op.settingValue(val: "add"))
            rule.addThen(atom: val.settingValue(val: "0.05"))
            table.addRule(rule: rule)
            
            rule = Rule()
            rule.addIf(atom: Atom(variable: groundSlope.settingValue(val: "20"), op: .greaterThanEqual))
            rule.addThen(atom: op.settingValue(val: "add"))
            rule.addThen(atom: val.settingValue(val: "0.10"))
            table.addRule(rule: rule)
            
            return table
        }
        
        fileprivate func generateTable3() -> Table {
            var table = Table(key: "t3")
            table.title = "Mannings ‘n’"
            table.refTypes = ["Paragraph"]
            table.refValues = ["2.3.4", "3.2.1", "4.1.6", "4.1.8", "4.1.11", "4.2.1"]
            
            let valN = Atom(variable: Variable(name: "n", unit: nil, value: nil), op: .equal)
            
            let drainType = Atom(variable: Variable(name: "drain", unit: nil, value: nil), op: .equal, rel: "type")
            
            do {
                let cPipes = Atom(variable: Variable(name: "material", unit: nil, value: nil), op: .equal)
                
                var rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: BooleanedAtoms(atoms: [cPipes.settingValue(val: "HDPE"), cPipes.settingValue(val: "uPVC")], bool: .or))
                rule.addThen(atom: valN.settingValue(val: "0.011"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: BooleanedAtoms(atoms: [cPipes.settingValue(val: "ceremic"), cPipes.settingValue(val: "concrete")], bool: .or))
                rule.addThen(atom: valN.settingValue(val: "0.013"))
                table.addRule(rule: rule)
            }
            
            do {
                let cul = Atom(variable: Variable(name: "material", unit: nil, value: nil), op: .equal)
                
                var rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "culvert"))
                rule.addIf(atom: cul.settingValue(val: "castInSituConcrete"))
                rule.addThen(atom: valN.settingValue(val: "0.015"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "culvert"))
                rule.addIf(atom: cul.settingValue(val: "corrugatedMetal"))
                rule.addThen(atom: valN.settingValue(val: "0.025"))
                table.addRule(rule: rule)
            }
            
            do {
                let roughness = ["verySmooth", "smooth", "mediumSmooth", "slightlyRough", "rough", "mediumRough", "veryRough"]
                
                let channelType = Atom(variable: Variable(name: "channel", unit: nil, value: nil), op: .equal, rel: "type")
                let roughnessAtom = Atom(variable: Variable(name: "channel", unit: nil, value: nil), op: .equal, rel: "surfaceRoughness")
                
                var rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: channelType.settingValue(val: "straightUniform"))
                rule.addIf(atom: roughnessAtom.settingValue(val: roughness[0]))
                rule.addThen(atom: valN.settingValue(val: "0.0225"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: channelType.settingValue(val: "unlined"))
                rule.addIf(atom: roughnessAtom.settingValue(val: roughness[1]))
                rule.addThen(atom: valN.settingValue(val: "0.025"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: channelType.settingValue(val: "roughStoneyBed"))
                rule.addIf(atom: roughnessAtom.settingValue(val: roughness[2]))
                rule.addThen(atom: valN.settingValue(val: "0.03"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: channelType.settingValue(val: "winding"))
                rule.addIf(atom: roughnessAtom.settingValue(val: roughness[3]))
                rule.addThen(atom: valN.settingValue(val: "0.035"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: BooleanedAtoms(atoms: [channelType.settingValue(val: "winding"), channelType.settingValue(val: "irregularCrossSection")], bool: .or))
                rule.addIf(atom: roughnessAtom.settingValue(val: roughness[4]))
                rule.addThen(atom: valN.settingValue(val: "0.045"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: channelType.settingValue(val: "irregular"))
                rule.addIf(atom: roughnessAtom.settingValue(val: roughness[5]))
                rule.addThen(atom: valN.settingValue(val: "0.06"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: drainType.settingValue(val: "channel"))
                rule.addIf(atom: channelType.settingValue(val: "irregularWinding"))
                rule.addIf(atom: roughnessAtom.settingValue(val: roughness[6]))
                rule.addThen(atom: valN.settingValue(val: "0.1"))
                table.addRule(rule: rule)
            }
            return table
        }
        
        fileprivate func generateTable4() -> Table {
            var table = Table(key: "t4")
            table.title = "Entrance Loss Coefficients"
            table.refTypes = ["Paragraph"]
            table.refValues = ["4.1.8"]
            
            let loss = Atom(variable: Variable(name: "ke", unit: nil, value: nil), op: .equal)
            
            let end = Atom(variable: Variable(name: "end", unit: nil, value: nil), op: .equal, rel: "type")
            
            do {
                let pipe = Atom(variable: Variable(name: "culvert", unit: nil, value: "pipe"), op: .equal, rel: "type")
                let type = Atom(variable: Variable(name: "entrance", unit: nil, value: nil), op: .equal, rel: "type")
                
                let ends = [end.settingValue(val: "squareCut"), end.settingValue(val: "socket")]
                
                var rule = Rule()
                rule.addIf(atom: pipe)
                rule.addIf(atom: type.settingValue(val: "projectingFromFill"))
                rule.addIf(atom: ends[0])
                rule.addThen(atom: loss.settingValue(val: "0.5"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: pipe)
                rule.addIf(atom: type.settingValue(val: "projectingFromFill"))
                rule.addIf(atom: ends[1])
                rule.addThen(atom: loss.settingValue(val: "0.2"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: pipe)
                rule.addIf(atom: type.settingValue(val: "headwall"))
                rule.addIf(atom: ends[0])
                rule.addThen(atom: loss.settingValue(val: "0.5"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: pipe)
                rule.addIf(atom: type.settingValue(val: "headwall"))
                rule.addIf(atom: ends[1])
                rule.addThen(atom: loss.settingValue(val: "0.2"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: pipe)
                rule.addIf(atom: BooleanedAtoms(atoms: [type.settingValue(val: "mitred"), Atom(variable: Variable(name: "slope", unit: nil, value: "fillSlope"), op: .equal, rel: "conform")], bool: .and))
                rule.addIf(atom: end.settingValue(val: "precastEnd"))
                rule.addThen(atom: loss.settingValue(val: "0.5"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: pipe)
                rule.addIf(atom: BooleanedAtoms(atoms: [type.settingValue(val: "mitred"), Atom(variable: Variable(name: "slope", unit: nil, value: "fillSlope"), op: .equal, rel: "conform")], bool: .and))
                rule.addIf(atom: end.settingValue(val: "fieldCutEnd"))
                rule.addThen(atom: loss.settingValue(val: "0.7"))
                table.addRule(rule: rule)
            }
            
            do {
                let box = Atom(variable: Variable(name: "culvert", unit: nil, value: "box"), op: .equal, rel: "type")
                let wingWalls = Variable(name: "wingWalls", unit: nil, value: nil)
                let edgeType = Atom(variable: Variable(name: "edge", unit: nil, value: nil), op: .equal, rel: "type")
                let edge = Atom(variable: Variable(name: "edge", unit: nil, value: nil), op: .equal)
                
                var rule = Rule()
                rule.addIf(atom: box)
                rule.addIf(atom: Atom(variable: wingWalls.settingValue(val: "unavailable"), op: .equal, rel: "availability"))
                rule.addIf(atom: edgeType.settingValue(val: "threeEdge"))
                rule.addIf(atom: edge.settingValue(val: "square"))
                rule.addThen(atom: loss.settingValue(val: "0.5"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: box)
                rule.addIf(atom: Atom(variable: wingWalls.settingValue(val: "unavailable"), op: .equal, rel: "availability"))
                rule.addIf(atom: edgeType.settingValue(val: "threeEdge"))
                rule.addIf(atom: edge.settingValue(val: "x1"))
                rule.addIf(atom: Atom(variable: Variable(name: "barrelDimension", unit: nil, value: "y1"), op: .equal))
                rule.addIf(atom: FunctionAtom(function: "x1/y1", type: .ratio, value: "0.0833", op: .equal))
                rule.addThen(atom: loss.settingValue(val: "0.2"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: box)
                rule.addIf(atom: BooleanedAtoms(atoms: [
                    Atom(variable: wingWalls.settingValue(val: "30°"), op: .greaterThanEqual),
                    Atom(variable: wingWalls.settingValue(val: "70°"), op: .lessThan)], bool: .and))
                rule.addIf(atom: edgeType.settingValue(val: "crown"))
                rule.addIf(atom: edge.settingValue(val: "square"))
                rule.addThen(atom: loss.settingValue(val: "0.4"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: box)
                rule.addIf(atom: BooleanedAtoms(atoms: [
                    Atom(variable: wingWalls.settingValue(val: "30°"), op: .greaterThanEqual),
                    Atom(variable: wingWalls.settingValue(val: "70°"), op: .lessThan)], bool: .and))
                rule.addIf(atom: edgeType.settingValue(val: "crown"))
                rule.addIf(atom: edge.settingValue(val: "x1"))
                rule.addIf(atom: Atom(variable: Variable(name: "culvertHeight", unit: nil, value: "y1"), op: .equal))
                rule.addIf(atom: FunctionAtom(function: "x1/y1", type: .ratio, value: "0.0833", op: .equal))
                rule.addThen(atom: loss.settingValue(val: "0.2"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: box)
                rule.addIf(atom: BooleanedAtoms(atoms: [
                    Atom(variable: wingWalls.settingValue(val: "10°"), op: .greaterThanEqual),
                    Atom(variable: wingWalls.settingValue(val: "30°"), op: .lessThan)], bool: .and))
                rule.addIf(atom: edgeType.settingValue(val: "crown"))
                rule.addIf(atom: edge.settingValue(val: "square"))
                rule.addThen(atom: loss.settingValue(val: "0.5"))
                table.addRule(rule: rule)
                
                rule = Rule()
                rule.addIf(atom: box)
                rule.addIf(atom: Atom(variable: wingWalls.settingValue(val: "parallel"), op: .equal))
                rule.addIf(atom: edgeType.settingValue(val: "crown"))
                rule.addIf(atom: edge.settingValue(val: "square"))
                rule.addThen(atom: loss.settingValue(val: "0.7"))
                table.addRule(rule: rule)
            }
            
            return table
        }
        
        fileprivate func generateTable5() -> Table {
            var table = Table(key: "t5")
            table.title = "Maximum Exit Velocities of Flow from Pipes and Culverts Discharging to Outfalls"
            table.refTypes = ["Paragraph"]
            table.refValues = ["7.0.1"]
            
            let velocity = Variable(name: "exitVelocity", unit: "m/s", value: nil)
            let material = Atom(variable: Variable(name: "outfall", unit: nil, value: nil), op: .equal, rel: "material")
            let size = Variable(name: "size", unit: "mm", value: nil)
            
            var materialAtoms: [AtomRepresentable] = []
            materialAtoms.append(BooleanedAtoms(atoms: [
                material.settingValue(val: "precastConcretePipe"),
                Atom(variable: Variable(name: "precastConcretePipe", unit: nil, value: "NZS 3107"), op: .equal, rel: "complyWith")], bool: .and))
            
            materialAtoms.append(material.settingValue(val: "precastConcreteCulvert"))
            materialAtoms.append(BooleanedAtoms(atoms: [
                material.settingValue(val: "inSituConcrete"),
                BooleanedAtoms(atoms: [material.settingValue(val: "hardPackRock"), Atom(variable: size.settingValue(val: "300"), op: .greaterThanEqual)], bool: .and)], bool: .or))
            
            materialAtoms.append(BooleanedAtoms(atoms: [
                BooleanedAtoms(atoms: [material.settingValue(val: "beaching"), Atom(variable: size.settingValue(val: "250"), op: .greaterThanEqual)], bool: .and),
                BooleanedAtoms(atoms: [material.settingValue(val: "boulder"), Atom(variable: size.settingValue(val: "250"), op: .greaterThanEqual)], bool: .and)
                ], bool: .or))
            
            materialAtoms.append(BooleanedAtoms(atoms: [material.settingValue(val: "stone"), Atom(variable: size.settingValue(val: "100"), op: .greaterThanEqual), Atom(variable: size.settingValue(val: "150"), op: .lessThanEqual)], bool: .and))
            
            materialAtoms.append(material.settingValue(val: "grassCoveredSurface"))
            materialAtoms.append(material.settingValue(val: "StiffSandyClay"))
            materialAtoms.append(material.settingValue(val: "coarseGravel"))
            materialAtoms.append(material.settingValue(val: "coarseSand"))
            materialAtoms.append(material.settingValue(val: "fineSand"))
            
            var velocityAtoms: [AtomRepresentable] = []
            velocityAtoms.append(Atom(variable: velocity.settingValue(val: "8.0"), op: .lessThanEqual))
            velocityAtoms.append(Atom(variable: velocity.settingValue(val: "8.0"), op: .lessThanEqual))
            velocityAtoms.append(Atom(variable: velocity.settingValue(val: "6.0"), op: .lessThanEqual))
            velocityAtoms.append(Atom(variable: velocity.settingValue(val: "5.0"), op: .lessThanEqual))
            
            velocityAtoms.append(BooleanedAtoms(atoms: [
                Atom(variable: velocity.settingValue(val: "2.5"), op: .greaterThanEqual),
                Atom(variable: velocity.settingValue(val: "6.0"), op: .lessThanEqual)], bool: .and))
            
            velocityAtoms.append(Atom(variable: velocity.settingValue(val: "1.8"), op: .lessThanEqual))
            
            velocityAtoms.append(BooleanedAtoms(atoms: [
                Atom(variable: velocity.settingValue(val: "1.3"), op: .greaterThanEqual),
                Atom(variable: velocity.settingValue(val: "1.5"), op: .lessThanEqual)], bool: .and))
            
            velocityAtoms.append(BooleanedAtoms(atoms: [
                Atom(variable: velocity.settingValue(val: "1.3"), op: .greaterThanEqual),
                Atom(variable: velocity.settingValue(val: "1.8"), op: .lessThanEqual)], bool: .and))
            
            velocityAtoms.append(BooleanedAtoms(atoms: [
                Atom(variable: velocity.settingValue(val: "0.5"), op: .greaterThanEqual),
                Atom(variable: velocity.settingValue(val: "0.7"), op: .lessThanEqual)], bool: .and))
            
            velocityAtoms.append(BooleanedAtoms(atoms: [
                Atom(variable: velocity.settingValue(val: "0.2"), op: .greaterThanEqual),
                Atom(variable: velocity.settingValue(val: "0.5"), op: .lessThanEqual)], bool: .and))
            
            assert(velocityAtoms.count == materialAtoms.count)
            
            for (index, materialAtom) in materialAtoms.enumerated() {
                var rule = Rule()
                rule.addIf(atom: materialAtom)
                rule.addThen(atom: velocityAtoms[index])
                table.addRule(rule: rule)
            }
            
            return table
        }
        
        fileprivate func generateTable6() -> Table {
            var table = Table(key: "t6")
            table.title = "Time For Pressure Drop Versus Internal Pipe Diameter"
            table.refTypes = ["Paragraph"]
            table.refValues = ["8.3.e"]
            
            let diameterLess = Atom(variable: Variable(name: "internalPipeDiameter", unit: "mm", value: nil), op: .lessThanEqual)
            let diameterGreater = Atom(variable: Variable(name: "internalPipeDiameter", unit: "mm", value: nil), op: .greaterThan)
            
            let time = Atom(variable: Variable(name: "timeForPermissablePressureDrop", unit: "minute", value: nil), op: .greaterThanEqual)
            
            let diamters = [90,100,150,225]
            let times = [3,3,4,6]
            
            for (index, diaVal) in diamters.enumerated() {
                var rule = Rule()
                rule.addIf(atom: diameterLess.settingValue(val: String(diaVal)))
                if index != 0 {
                    rule.addIf(atom: diameterGreater.settingValue(val: String(diamters[index - 1])))
                }
                
                rule.addThen(atom: time.settingValue(val: String(times[index])))
                table.addRule(rule: rule)
            }
            
            return table
        }
    }
    
    private class Document2 {
        
        fileprivate func generateTable1() -> Table {
            var table = Table(key: "t1")
            table.title = "Acceptable Pipe Materials"
            table.refTypes = ["Paragraph"]
            table.refValues = ["3.1.1", "3.9.2"]
            
            let material = Atom(variable: Variable(name: "pipeMaterial", unit: nil, value: nil), op: .equal)
            let standard = Atom(variable: Variable(name: "standard", unit: nil, value: nil), op: .equal)
            
            let materials = ["concrete", "vitrifiedClay", "steel", "ductileIron", "PVC-U", "polyethylene", "polypropylene"]
            
            var standards: [AtomRepresentable] = []
            standards.append(standard.settingValue(val: "AS/NZS 4058"))
            standards.append(standard.settingValue(val: "AS 1741"))
            standards.append(BooleanedAtoms(atoms: [standard.settingValue(val: "NZS 4442"), standard.settingValue(val: "AS 1579")], bool: .or))
            standards.append(standard.settingValue(val: "AS/NZS 2280"))
            standards.append(BooleanedAtoms(atoms: [standard.settingValue(val: "AS/NZS 1260"), standard.settingValue(val: "AS/NZS 1254")], bool: .or))
            standards.append(BooleanedAtoms(atoms: [standard.settingValue(val: "AS/NZS 4130"), standard.settingValue(val: "AS/NZS 2065")], bool: .or))
            standards.append(standard.settingValue(val: "AS/NZS 2065"))
            
            assert(standards.count == materials.count)
            
            for (index, matVal) in materials.enumerated() {
                var rule = Rule()
                rule.addIf(atom: material.settingValue(val: matVal))
                rule.addThen(atom: standards[index])
                table.addRule(rule: rule)
            }
            
            return table
        }
        
        fileprivate func generateTable2() -> Table {
            var table = Table(key: "t2")
            table.title = "Minimum Gradients"
            table.refTypes = ["Paragraph"]
            table.refValues = ["3.4.1"]
            
            let diameter = Variable(name: "drainInternalDiameter", unit: "mm", value: nil)
            let gradient = Atom(variable: Variable(name: "gradient", unit: nil, value: nil), op: .greaterThanEqual)
            
            let diamters = [85,100,150,225]
            let gradients = ["1/90", "1/120", "1/200", "1/350"]
            
            for (index, diaVal) in diamters.enumerated() {
                var rule = Rule()
                rule.addIf(atom: Atom(variable: diameter.settingValue(val: String(diaVal)), op: .lessThanEqual))
                
                if index != 0 {
                    rule.addIf(atom: Atom(variable: diameter.settingValue(val: String(diamters[index - 1])), op: .greaterThan))
                }
                
                rule.addThen(atom: gradient.settingValue(val: gradients[index]))
                table.addRule(rule: rule)
            }
            
            return table
        }
        
        fileprivate func generateTable3() -> Table {
            var table = Table(key: "t3")
            table.title = "Acceptable Jointing Methods"
            table.refTypes = ["Paragraph"]
            table.refValues = ["3.5.2"]
            
            let material = Atom(variable: Variable(name: "pipeMaterial", unit: nil, value: nil), op: .equal)
            let standard = Atom(variable: Variable(name: "standard", unit: nil, value: nil), op: .equal)
            let method = Atom(variable: Variable(name: "jointingMethod", unit: nil, value: nil), op: .equal)
            
            let mElas = method.settingValue(val: "elastomericRing")
            let mFla = method.settingValue(val: "flanged")
            
            let materials = ["concrete", "steel", "ductileIron", "PVC-U", "polyethylene", "polypropylene"]
            
            var methods: [AtomRepresentable] = []
            methods.append(mElas)
            methods.append(BooleanedAtoms(atoms: [mElas, method.settingValue(val: "welded"), mFla], bool: .or))
            methods.append(BooleanedAtoms(atoms: [mElas, mFla], bool: .or))
            methods.append(BooleanedAtoms(atoms: [mElas, method.settingValue(val: "solventWelded")], bool: .or))
            methods.append(BooleanedAtoms(atoms: [method.settingValue(val: "heatWelded"), mFla], bool: .or))
            
            var standards: [AtomRepresentable] = []
            standards.append(standard.settingValue(val: "AS 1646"))
            standards.append(BooleanedAtoms(atoms: [standard.settingValue(val: "NZS 4442"), standard.settingValue(val: "BS EN 1759.1")], bool: .or))
            standards.append(standard.settingValue(val: "AS/NZS 2280"))
            standards.append(BooleanedAtoms(atoms: [standard.settingValue(val: "AS 1646"), standard.settingValue(val: "AS/NZS 2032"), standard.settingValue(val: "AS/NZS 1254")], bool: .or))
            standards.append(standard.settingValue(val: "AS/NZS 2033"))
            standards.append(standard.settingValue(val: "AS/NZS 2566.2"))
            
            assert(standards.count == materials.count)
            
            for (index, matVal) in materials.enumerated() {
                var rule = Rule()
                rule.addIf(atom: material.settingValue(val: matVal))
                if methods.count > index {
                    rule.addThen(atom: methods[index])
                }
                
                rule.addThen(atom: standards[index])
                table.addRule(rule: rule)
            }
            
            return table
        }
        
        fileprivate func generateTable4() -> Table {
            var table = Table(key: "t4")
            table.title = "Acceptable Material Standards for Downpipes"
            table.refTypes = ["Paragraph"]
            table.refValues = ["4.1.1"]
            
            let material = Atom(variable: Variable(name: "downpipeMaterial", unit: nil, value: nil), op: .equal)
            let standard = Atom(variable: Variable(name: "standard", unit: nil, value: nil), op: .equal)
            
            let materials = ["PVC-U", "galvanisedSteel", "copper", "aluminium", "stainlessSteel", "zincAluminium"]
            
            var standards: [AtomRepresentable] = []
            standards.append(BooleanedAtoms(atoms: [standard.settingValue(val: "AS/NZS 1260"), standard.settingValue(val: "AS/NZS 1254")], bool: .or))
            standards.append(standard.settingValue(val: "AS 1397"))
            standards.append(standard.settingValue(val: "BS EN 1172"))
            standards.append(standard.settingValue(val: "AS/NZS 1734"))
            standards.append(standard.settingValue(val: "NZS/BS 970"))
            standards.append(standard.settingValue(val: "AS 1397"))
            
            assert(standards.count == materials.count)
            
            for (index, matVal) in materials.enumerated() {
                var rule = Rule()
                rule.addIf(atom: material.settingValue(val: matVal))
                rule.addThen(atom: standards[index])
                table.addRule(rule: rule)
            }
            
            return table
        }
        
        fileprivate func generateTable5() -> Table {
            var table = Table(key: "t5")
            table.title = "Downpipe Sizes for Given Roof Pitch and Area"
            table.refTypes = ["Paragraph"]
            table.refValues = ["4.2.1"]
            
            let roof = Variable(name: "roofPitch", unit: nil, value: nil)
            let pipeSize = Variable(name: "downpipeSize", unit: "mm", value: nil)
            let planArea = Atom(variable: Variable(name: "areaOfRoofServedByDownpipe", unit: "m^2", value: nil), op: .equal)
            
            let diameterType = Atom(variable: Variable(name: "pipeType", unit: nil, value: "diameter"), op: .equal)
            let rectType = Atom(variable: Variable(name: "pipeType", unit: nil, value: "rectangular"), op: .equal)
            
            let roofValues = [25,35,45,55]
            let diaValues = [63,74,100,150]
            let rectValues = ["65 x 50", "100 x 50", "75 x 75", "100 x 75"]
            
            let areaValues = [[60,50,40,35], [85,70,60,50], [155,130,110,90], [350,290,250,200], [60,50,40,35], [100,80,70,60], [110,90,80,65], [150,120,105,90]]
            
            for (areaIndex, areaVal) in areaValues.enumerated() {
                for (roofIndex, roofVal) in roofValues.enumerated() {
                    var rule = Rule()
                    if roofIndex == 0 {
                        rule.addIf(atom: Atom(variable: roof.settingValue(val: "0°"), op: .greaterThan))
                    } else {
                        rule.addIf(atom: Atom(variable: roof.settingValue(val: "\(roofValues[roofIndex - 1])°"), op: .greaterThan))
                    }
                    
                    rule.addIf(atom: Atom(variable: roof.settingValue(val: "\(roofVal)°"), op: .lessThanEqual))
                    
                    rule.addIf(atom: planArea.settingValue(val: String(areaVal[roofIndex])))
                    
                    if areaIndex < 4 {
                        rule.addIf(atom: diameterType)
                        rule.addThen(atom: Atom(variable: pipeSize.settingValue(val: String(diaValues[areaIndex])), op: .greaterThanEqual))
                    } else {
                        rule.addIf(atom: rectType)
                        let reVal = rectValues[areaIndex - 4]
                        rule.addThen(atom: Atom(variable: pipeSize.settingValue(val: String(reVal)), op: .greaterThanEqual))
                    }
                    
                    table.addRule(rule: rule)
                }
            }

            return table
        }
        
        fileprivate func generateTable6() -> Table {
            var table = Table(key: "t6")
            table.title = "Acceptable Material Standards for Roof Gutters"
            table.refTypes = ["Paragraph"]
            table.refValues = ["5.2.1"]
            
            let material = Atom(variable: Variable(name: "gutterMaterial", unit: nil, value: nil), op: .equal)
            let standard = Atom(variable: Variable(name: "standard", unit: nil, value: nil), op: .equal)
            
            let materials = ["PVC-U", "Galvanised Steel", "Copper", "Aluminium", "Stainless Steel", "Zinc Aluminium"]
            let standards = ["AS 1273", "AS 1397", "BS 2870", "AS/NZS 1734", "NZS/BS 970", "AS 1397"]
            
            for (index, materialVal) in materials.enumerated() {
                var rule = Rule()
                rule.addIf(atom: material.settingValue(val: materialVal))
                rule.addThen(atom: standard.settingValue(val: standards[index]))
                table.addRule(rule: rule)
            }
            
            return table
        }
        
        fileprivate func generateTable7() -> Table {
            var table = Table(key: "t7")
            table.title = "Thermal Expansion of 5 m length over 50°C"
            table.refTypes = ["Paragraph"]
            table.refValues = ["5.4.1"]
            
            let material = Atom(variable: Variable(name: "gutterMaterial", unit: nil, value: nil), op: .equal)
            let expansion = Atom(variable: Variable(name: "termalExpansion", unit: "mm", value: nil), op: .lessThanEqual)
            
            let materials = ["PVC-U", "Zinc", "Galvanised Steel", "Copper", "Aluminium", "Stainless Steel"]
            let expansionVals = [17.5,5.0,2.5,4.5,5.8,3.8]
            assert(materials.count == expansionVals.count)
            
            for (index, materialVal) in materials.enumerated() {
                var rule = Rule()
                rule.addIf(atom: material.settingValue(val: materialVal))
                rule.addThen(atom: expansion.settingValue(val: String(expansionVals[index])))
                table.addRule(rule: rule)
            }
            
            return table
        }
    }
}
