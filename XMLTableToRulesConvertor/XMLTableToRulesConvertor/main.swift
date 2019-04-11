//
//  main.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 8/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import AppKit
import Foundation

let table = CAS5.generateTable32().description
print(table)

// automatically copy content ready to be pasted

NSPasteboard.general.clearContents()
NSPasteboard.general.setString(table, forType: .string)
