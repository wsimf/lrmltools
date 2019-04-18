//
//  XMLConvertor.swift
//  XMLTableToRulesConvertor
//
//  Created by Sudara Fernando on 18/04/19.
//  Copyright © 2019 Sudara Fernando. All rights reserved.
//

import AppKit
import Foundation

class XMLConvertor {
    
    let folderPath = "/Users/Sudara/Projects/lrml/xml"
    
    var currentFileName: String
    
    init(currentFileName: String) {
        self.currentFileName = currentFileName
    }
    
    func getFileContent() -> XMLDocument? {
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: self.folderPath) else {
            print("Unable to read files in the path \(self.folderPath)")
            return nil
        }
        
        guard files.contains(self.currentFileName) else {
            print("Unable to find the file \(self.currentFileName) in the path \(self.folderPath)")
            return nil
        }
        
        let url = URL(fileURLWithPath: self.currentFileName, isDirectory: false, relativeTo: URL(fileURLWithPath: self.folderPath, isDirectory: true))
        
        let options = XMLNode.Options()
        guard let document = try? XMLDocument(contentsOf: url, options: options) else {
            print("Unable to read XML data from the file at \(url.absoluteString)")
            return nil
        }
        
        return document
    }

    func getRules(with key: String, in document: XMLDocument, and documentId: Int = 0) -> XMLElement? {
        var key = key
        if !key.starts(with: "t") {
            key = "t\(key)"
        }
        
        let rules = try! document.nodes(forXPath: "//rules")
        let matches = rules.compactMap { (node) -> XMLElement? in
            guard let element = node as? XMLElement else { return nil }
            guard let keyAttribute = element.attribute(forName: "key") else { return nil}
            guard let keyValue = keyAttribute.objectValue as? String else { return nil}
            if keyValue == key {
                return element
            } else {
                return nil
            }
        }
        
        guard matches.count > documentId else { return nil }
        return matches[documentId]
    }
    
    private func getDocument(with documentId: Int = 0) -> XMLElement? {
        guard let document = self.getFileContent()?.rootElement() else {
            print("Unable to get document from empty file")
            return nil
        }
        
        let result = document.elements(forName: "document")
        guard result.count > documentId else {
            print("Unable to find document id \(documentId). Total documents read : \(result.count)")
            return nil
        }
        
        return result[documentId]
    }
    
    private func getPart(with id: Int, in document: XMLElement) -> XMLElement? {
        let parts = document.elements(forName: "part")
        guard parts.count > (id - 1) else {
            print("Unable to find part with id \(id). Total parts found: \(parts.count)")
            return nil
        }
        
        return parts[id - 1]
    }
}
