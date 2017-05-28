//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class LinearLayout: UIView, ViewGroup {

    var rootView: ViewGroup
    var orientation: String
    var id: String?
    var attr: [String: String]

    var views: [View] = []

    required init?(coder aDecoder: NSCoder) {
        self.rootView = RootLayout()
        self.id = ""
        self.orientation = "vertical"
        self.attr = [:]
        super.init(coder: aDecoder)
    }

    required init(rootView: ViewGroup, attr: [String: String]) {
        self.rootView = rootView
        self.id = IdFromAttr(attr: attr)
        self.orientation = OrientationFromAttr(attr: attr)
        self.attr = attr
        super.init(frame: SizeFromAttr(root: rootView, attr: attr))
        BackgroundFromAttr(view: self, attr: attr)
        id = IdFromAttr(attr: attr)
    }

    func addView(tag: String, attr: [String: String]) -> View? {
        var lastView: UIView? = nil
        if self.views.count > 0 {
            lastView = self.views[self.views.count - 1] as? UIView
        }
        var point = measure(root: self, views: self.views)
        var view = ViewFromTagInfos(tag: tag, point: point, root: self, attr: attr)
        views.append(view)
        if let uiview = view as? UIView {
            addSubview(uiview)
        }
        if let viewgroup = view as? ViewGroup {
            return viewgroup
        }
        return view
    }

    func measure(root: UIView, views: [View]) -> CGPoint {
        var pointX: CGFloat = 0
        var pointY: CGFloat = 0

        if orientation == "horizontal" {
            if let view = views.last {
                pointX = view.getFrame().origin.x + view.getFrame().width
            }
        }
        if orientation == "vertical" {
            if let view = views.last {
                pointY = view.getFrame().origin.y + view.getFrame().height
            }
        }

        print("linear pointX : " + pointX.description + ", linear pointY : " + pointY.description)
        let point = CGPoint(x: pointX, y: pointY)
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
        for i in 0 ..< views.count {
            let frame = relocate(root: self, index: i, target: views[i], views: views)
            let lastX = frame.origin.x + frame.width
            let lastY = frame.origin.y + frame.height
            if maxWidth < lastX {
                maxWidth = lastX
            }
            if maxHeight < lastY {
                maxHeight = lastY
            }
        }

        if let width = attr["android:layout_width"] {
            if width == "wrap_content" {
                frame.size.width = maxWidth
            }
        }
        if let height = attr["android:layout_height"] {
            if height == "wrap_content" {
                frame.size.height = maxHeight
            }
        }
    }

    func relocate(root: UIView, index: Int, target: View, views: [View]) -> CGRect {
        print("relocate Linear")
        var frameX: CGFloat = target.getFrame().origin.x
        var frameY: CGFloat = target.getFrame().origin.y
        var frameWidth: CGFloat = target.getFrame().width
        var frameHeight: CGFloat = target.getFrame().height
        var attr = target.attr

        if(index > 0) {
            if orientation == "horizontal" {
                frameX = views[index - 1].getFrame().origin.x + views[index - 1].getFrame().width
            }
            if orientation == "vertical" {
                frameY = views[index - 1].getFrame().origin.y + views[index - 1].getFrame().height
            }
        }

        print("frameX : " + frameX.description + ", frameY : " + frameY.description + ", frameWidth : " + frameWidth.description + ", frameHeight : " + frameHeight.description)
        let frame = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
        if var targetView = target as? UIView {
            targetView.frame = frame
        }
        return frame
    }
}