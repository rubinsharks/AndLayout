//
// Created by RubinYeom on 2017. 5. 9..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class FrameLayout: UIView, ViewGroup {

    var rootView: ViewGroup
    var id: String?
    var attr: [String: String]

    var views: [View] = []

    required init?(coder aDecoder: NSCoder) {
        self.rootView = RootLayout()
        self.id = ""
        self.attr = [:]
        super.init(coder: aDecoder)
    }

    required init(rootView: ViewGroup, attr: [String: String]) {
        self.rootView = rootView
        self.id = IdFromAttr(attr: attr)
        self.attr = attr
        super.init(frame: SizeFromAttr(root: rootView, attr: attr))
        BackgroundFromAttr(view: self, attr: attr)
        id = IdFromAttr(attr: attr)
    }

    func addView(tag: String, attr: [String: String]) -> View? {
        var point = measure(root: self, attr: attr, views: self.views)
        var view = ViewFromTagInfos(tag: tag, point: point, root: self, attr: attr)
        print("Frame : " + tag)
        if let v = view as? UIView {
            print("R class : " + v.theClassName)
        }
        views.append(view)
        if let uiview = view as? UIView {
            addSubview(uiview)
        }
        return view
    }

    func measure(root: UIView, attr: [String: String], views: [View]) -> CGPoint {
        var pointX: CGFloat = 0
        var pointY: CGFloat = 0

        print("pointX : " + pointX.description + ", pointY : " + pointY.description)
        let point = CGPoint(x: pointX, y: pointY)
        print(point)
        return point
    }

    func removeView(view: View) {
    }

    func findViewById(id: String) -> View? {
        return findViewByIdInViews(views: views, id: id)
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

    func getMatchWidth() -> CGFloat {
        if var width = attr["android:layout_width"] {
            if width == "match_parent" || width == "wrap_content" {
                return rootView.getMatchWidth()
            } else {
                return self.frame.width
            }
        }
        return 0
    }

    func getMatchHeight() -> CGFloat {
        if var height = attr["android:layout_height"] {
            if height == "match_parent" || height == "wrap_content" {
                return rootView.getMatchHeight()
            } else {
                return self.frame.height
            }
        }
        return 0
    }

    func getFrame() -> CGRect {
        return frame
    }

    func requestLayout() {
        var maxWidth:CGFloat = 0;
        var maxHeight:CGFloat = 0;
        self.frame = SizeFromAttr(root: rootView, attr: attr)
    }

    func FrameFrameFromAttr(root: UIView, attr: [String: String], views: [View]) -> CGRect {
        let width = attr["android:layout_width"]
        let height = attr["android:layout_height"]
        var frameX: CGFloat = 0
        var frameY: CGFloat = 0
        var frameWidth: CGFloat = 0
        var frameHeight: CGFloat = 0
        print("width : " + width! + ", height : " + height!)

        // get width & height
        if width == "match_parent" {
            frameWidth = root.frame.width
        } else if width == "wrap_content" {
        } else {
            frameWidth = getCGFloatFromString(text: width) * 640 / UIScreen.main.bounds.width
        }
        if height == "match_parent" {
            frameHeight = root.frame.height
        } else if height == "wrap_content" {
        } else {
            frameHeight = getCGFloatFromString(text: height) * 640 / UIScreen.main.bounds.height
        }

        print("frameWidth : " + frameWidth.description + ", frameHeight : " + frameHeight.description)
        let frame = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
        print(frame)
        return frame
    }
}