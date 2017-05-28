//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class RootLayout: UIView, ViewGroup {

    var views: [View] = []
    var attr: [String: String]

    required init?(coder aDecoder: NSCoder) {
        self.attr = [:]
        super.init(coder: aDecoder)
    }

    required init() {
        self.attr = [:]
        super.init(frame: UIScreen.main.bounds)
    }

    required init(rootFrame: CGRect) {
        self.attr = [:]
        super.init(frame: rootFrame)
    }

    func addView(tag: String, attr: [String: String]) -> View? {
        var point = CGPoint(x: 0, y: 0)
        var view = ViewFromTagInfos(tag: tag, point: point, root: self, attr: attr)
        views.append(view)
        if let uiview = view as? UIView {
            addSubview(uiview)
        }
        return view
    }

    func removeView(view: View) {
    }

    func findViewById(id: String) -> View? {
        return findViewByIdInViews(views: views, id: id)
    }

    func getId() -> String? {
        return nil
    }

    func getRootView() -> ViewGroup {
        return self
    }

    func setAttribute(attr: [String: String]) {
    }

    func getWrapWidth() -> CGFloat {
        return frame.width
    }

    func getWrapHeight() -> CGFloat {
        return frame.height
    }

    func getMatchWidth() -> CGFloat {
        return frame.width
    }

    func getMatchHeight() -> CGFloat {
        return frame.height
    }

    func getFrame() -> CGRect {
        return frame
    }

    func setFrame(rootFrame: CGRect) {
        print("setFrame X : " + rootFrame.origin.x.description + ", Y : " + rootFrame.origin.y.description)
        print("setFrame Width : " + rootFrame.width.description + ", Height : " + rootFrame.height.description)
        frame = rootFrame
        for view in views {
            if let groupView = view as? ViewGroup {
                groupView.requestLayout()
            }
        }
    }

    func requestLayout() {
    }

    func RootFrameFromAttr(root: UIView, target: View, attr: [String: String], views: [View]) -> CGRect {
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
            frameWidth = target.getWrapWidth()
        } else {
            frameWidth = getCGFloatFromHorizontal(text: width)
        }
        if height == "match_parent" {
            frameHeight = root.frame.height
        } else if height == "wrap_content" {
            frameWidth = target.getWrapHeight()
        } else {
            frameHeight = getCGFloatFromVertical(text: height)
        }

        print("frameWidth : " + frameWidth.description + ", frameHeight : " + frameHeight.description)
        let frame = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
        print(frame)
        return frame
    }
}