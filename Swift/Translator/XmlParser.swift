//
//  XmlParser.swift
//  Translator
//
//  Created by Adam Nagy on 09/11/2015.
//  Copyright © 2015 Adam Nagy. All rights reserved.
//

import Foundation

class XmlParser: NSXMLParser,
  NSXMLParserDelegate {
  
  var translationTag: Bool = false
  var translation: String = ""
  
  func parser( parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    if elementName == "translation" {
      translationTag = true
    }
  }
  
  func parser(parser: NSXMLParser, foundCharacters string: String) {
    if translationTag {
      translation = translation + string
    }
  }
  
  func parser(parser: NSXMLParser,
    didEndElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?) {
      if elementName == "translation" {
        translationTag = false
      }
  }
}


