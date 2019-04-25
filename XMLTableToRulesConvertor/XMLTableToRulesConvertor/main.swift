//
//  main.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 8/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import AppKit
import Foundation

//func getInput(emptyError: String?) -> String {
//    repeat {
//        if let val = readLine(), !val.isEmpty {
//            return val
//        } else {
//            print(emptyError ?? "Empty Input. Try Again")
//        }
//    } while(true)
//}
//
//func getFileClass(from: String) -> Document.Type? {
//    switch from {
//    case "cas2", "cas 2": return CAS2.self
//    case "cas3", "cas 3": return CAS3.self
//    case "cas4", "cas 4": return CAS4.self
//    case "cas5", "cas 5": return CAS5.self
//    case "cas6", "cas 6": return CAS6.self
//    default: return nil
//    }
//}
//
//print("Enter File Name (CAS2): ")
//let fileName = getInput(emptyError: "Empty File Name. Try again.")
//
//guard let file = getFileClass(from: fileName) else {
//    print("No file found for \"\(fileName)\"")
//    exit(1)
//}
//
//let mirror = Mirror(reflecting: file)
//
//print("Enter Table Name for File \"\(fileName)\": ")
//let tableName = getInput(emptyError: "Empty table name. Try again.")

//let val = XMLConvertor(currentFileName: "NZBC-CAS3v4(text).xml")
//let rules = val.getRules(with: "5.2", in: val.getFileContent()!)

let table = E1().generateTable(for: "7", in: "2")!.description
print(table)

// automatically copy content ready to be pasted

NSPasteboard.general.clearContents()
NSPasteboard.general.setString(table, forType: .string)

