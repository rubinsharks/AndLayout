//
// Created by RubinYeom on 2017. 5. 13..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation

class ResourceInflater: NSObject, XMLParserDelegate {

    var dimen: Dimen
    var color: Color
    var string: StringResource
    var drawable: Drawable
    var name: String
    var elementName: String

    override init() {
        dimen = Dimen.shared
        color = Color.shared
        string = StringResource.shared
        drawable = Drawable.shared
        name = ""
        elementName = ""
        super.init()
    }

    func drawablesFromFile(type: String) {
        let files = Bundle.main.paths(forResourcesOfType: type, inDirectory: "android_drawable")
        for file in files {
            let fileName = (file as NSString).lastPathComponent
            let fileNotExtension = (fileName as NSString).deletingPathExtension
            let fileExtension = (fileName as NSString).pathExtension
            drawable.drawables[fileNotExtension] = fileExtension
            if fileExtension == "svg" {

            }
        }
    }

    func dimensFromXML() {
        if let path = Bundle.main.url(forResource: "dimens", withExtension: "xml", subdirectory: "android_values") {
            do {
                print(path)
                if let parser = XMLParser(contentsOf: path) {
                    parser.delegate = self
                    parser.parse()
                    print(dimen.dimens.description)
                }
            } catch _ as NSError {
            }
        }
    }

    func colorsFromXML() {
        if let path = Bundle.main.url(forResource: "colors", withExtension: "xml", subdirectory: "android_values") {
            do {
                print(path)
                if let parser = XMLParser(contentsOf: path) {
                    parser.delegate = self
                    parser.parse()
                    print(color.colors.description)
                }
            } catch _ as NSError {
            }
        }
    }

    func stringsFromXML() {
        if let path = Bundle.main.url(forResource: "strings", withExtension: "xml", subdirectory: "android_values") {
            do {
                print(path)
                if let parser = XMLParser(contentsOf: path) {
                    parser.delegate = self
                    parser.parse()
                    print(color.colors.description)
                }
            } catch _ as NSError {
            }
        }
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        if elementName == "dimen" {
            if let name = attributeDict["name"] {
                self.name = name
                self.elementName = elementName
                dimen.dimens[name] = "0dp"
            }
        }
        if elementName == "color" {
            if let name = attributeDict["name"] {
                self.name = name
                self.elementName = elementName
                color.colors[name] = ""
            }
        }
        if elementName == "string" {
            if let name = attributeDict["name"] {
                self.name = name
                self.elementName = elementName
                string.strings["@string/" + name] = ""
            }
        }
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.elementName = ""
        self.name = ""
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if elementName == "dimen" {
            if string.contains("dp") {
                dimen.dimens[self.name] = string
            }
        } else if elementName == "color" {
            color.colors[self.name] = string
        } else if elementName == "string" {
            self.string.strings["@string/" + self.name] = string
        }
    }

}