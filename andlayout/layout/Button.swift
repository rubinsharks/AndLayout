//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton, View {

    let rootView: ViewGroup
    var id: String?
    var attr: [String: String]

    required init?(coder aDecoder: NSCoder) {
        self.rootView = RootLayout()
        self.attr = [:]
        super.init(coder: aDecoder)
    }

    required init(rootView: ViewGroup, attr: [String: String]) {
        self.rootView = rootView
        self.attr = attr
        super.init(frame: SizeFromAttr(root: rootView, attr: attr))
        BackgroundFromAttr(view: self, attr: attr)
        textFromAttr(attr: attr)
        id = IdFromAttr(attr: attr)
    }

    func textFromAttr(attr: [String: String]) {
        if var text = attr["android:text"] {
            if let value = StringResource.shared.strings[text] {
                self.setTitle(value, for: UIControlState.normal)
            } else {
                self.setTitle(text, for: UIControlState.normal)
            }
        }
        if var color = attr["android:textColor"] {
            self.setTitleColor(getColorFromString(color: color), for: UIControlState.normal)
        }
    }

    func getId() -> String? {
        return self.id
    }

    func getRootView() -> ViewGroup {
        return rootView
    }

    func setAttribute(attr: [String: String]) {
    }

    func getWrapWidth() -> CGFloat {
        return intrinsicContentSize.width
    }

    func getWrapHeight() -> CGFloat {
        return intrinsicContentSize.height
    }

    func getFrame() -> CGRect {
        return frame
    }
}