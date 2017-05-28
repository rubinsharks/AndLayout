//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class TKLayoutParser: NSObject, XMLParserDelegate {

    var rootView: ViewGroup?
    var detailIndexView: View?
    var groupIndexView: ViewGroup?

    init(frame: CGRect) {
        rootView = RootLayout(rootFrame: frame)
        groupIndexView = rootView
        detailIndexView = rootView
    }

    func getViewFromXML(fromXML fileName: String) -> ViewGroup? {
        if let path = Bundle.main.url(forResource: fileName, withExtension: "xml", subdirectory: "android_layout") {
            do {
                print(path)
                if let parser = XMLParser(contentsOf: path) {
                    parser.delegate = self
                    parser.parse()
                    return rootView
                }
            } catch _ as NSError {
            }
        }
        return nil
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        print(elementName)
        if let group = groupIndexView {
            if let detail = group.addView(tag: elementName, attr: attributeDict) {
                self.detailIndexView = detail
                if let dgroup = detail as? ViewGroup {
                    self.groupIndexView = dgroup
                }
            }
        }
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("/" + elementName)
        if let detail = self.detailIndexView {
            self.groupIndexView = detail.getRootView()
            self.detailIndexView = nil
        } else {
            if let group = groupIndexView {
                group.requestLayout()
                groupIndexView = group.getRootView()
            }
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
    }

}