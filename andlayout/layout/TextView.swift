//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class TextView: UILabel, View {

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
        if attr["android:layout_width"] == "wrap_content" {
            frame.size.width = intrinsicContentSize.width
        }
        if attr["android:layout_height"] == "wrap_content" {
            frame.size.height = intrinsicContentSize.height
        }
        print("frameWidth : " + frame.size.width.description)
    }

    func textFromAttr(attr: [String: String]) {
        if var text = attr["android:text"] {
            if let value = StringResource.shared.strings[text] {
                self.text = value;
            } else {
                self.text = text
            }
        }
        if var textSize = attr["android:textSize"] {
            self.font = self.font.withSize(getCGFloatFromString(text: textSize))
        }
        if var color = attr["android:textColor"] {
            self.textColor = getColorFromString(color: color)
        }
        if var gravity = attr["android:gravity"] {
            if gravity == "center" {
                self.textAlignment = .center
            } else if gravity == "center_vertical" {
                baselineAdjustment = .alignCenters
            } else if gravity == "left" {
                textAlignment = .left
            } else if gravity == "right" {
                textAlignment = .right
            } else if gravity == "right|center_vertical" {
                textAlignment = .right
                baselineAdjustment = .alignCenters
            }
        }
    }

    func setText(text: String) {
        self.text = text
        if attr["android:layout_width"] == "wrap_content" {
            frame.size.width = intrinsicContentSize.width
        }
        if attr["android:layout_height"] == "wrap_content" {
            frame.size.height = intrinsicContentSize.height
        }
        rootView.requestLayout()
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