//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class ImageView: UIView, View {

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
        id = IdFromAttr(attr: attr)
        imageFromAttr(attr: attr)
    }

    func imageFromAttr(attr: [String: String]) {
        if var image = attr["app:srcCompat"] {
            let path = DrawableFromAttr(drawable: image)
            if path == "F"{
                return
            }
        }
        if var image = attr["android:src"] {
        }
        if var image = attr["android:scaleType"] {
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