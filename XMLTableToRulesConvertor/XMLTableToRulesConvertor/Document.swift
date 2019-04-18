//
//  Document.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 17/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import Foundation

protocol Document {
    
    func generateTable(for id: String, in subDocument: String?) -> Table?
}
