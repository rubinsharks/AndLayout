//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

class RelativeLayout: UIView, ViewGroup {

    var rootView: ViewGroup
    var id: String?
    var attr: [String: String]

    var views: [View] = []

    var wrapWidth: CGFloat = 0
    var wrapHeight: CGFloat = 0

    required init?(coder aDecoder: NSCoder) {
        self.rootView = RootLayout()
        self.id = ""
        self.attr = [:]
        super.init(coder: aDecoder)
    }

    required init(rootView: ViewGroup, attr: [String: String]) {
        self.rootView = rootView
        self.attr = attr
        self.id = IdFromAttr(attr: attr)
        super.init(frame: SizeFromAttr(root: rootView, attr: attr))
        BackgroundFromAttr(view: self, attr: attr)
        id = IdFromAttr(attr: attr)
    }

    func addView(tag: String, attr: [String: String]) -> View? {
        var point = measure(root: self, attr: attr, views: self.views)
        var view = ViewFromTagInfos(tag: tag, point: point, root: self, attr: attr)
        views.append(view)
        if let uiview = view as? UIView {
            addSubview(uiview)
        }
        return view
    }

    func measure(root: UIView, attr: [String: String], views: [View]) -> CGPoint {
        var pointX: CGFloat = 0
        var pointY: CGFloat = 0

        if let x = attr["android:layout_below"] {
            if let view = findViewByIdInViews(views: views, id: x) as? UIView {
                pointY = view.frame.origin.y + view.frame.height
            }
        }
        if let x = attr["android:layout_toRightOf"] {
            if let view = findViewByIdInViews(views: views, id: x) as? UIView {
                pointX = view.frame.origin.x + view.frame.width
            }
        }

        print("pointX : " + pointX.description + ", pointY : " + pointY.description)
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
        return 0
    }

    func getWrapHeight() -> CGFloat {
        return 0
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
        for view in views {
            let frame = relocate(root: self, target: view, views: views)
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

    func relocate(root: UIView, target: View, views: [View]) -> CGRect {
        print("relocate Relative")
        var frameX: CGFloat = target.getFrame().origin.x
        var frameY: CGFloat = target.getFrame().origin.y
        var frameWidth: CGFloat = target.getFrame().width
        var frameHeight: CGFloat = target.getFrame().height
        var attr = target.attr

        // get x & y
        if let x = attr["android:layout_alignParentBottom"] {
            frameY = root.frame.origin.y + root.frame.height - frameHeight
        }
        if let x = attr["android:layout_alignParentTop"] {
            frameY = root.frame.origin.y
        }
        if let x = attr["android:layout_alignParentLeft"] {
            frameX = root.frame.origin.x
        }
        if let x = attr["android:layout_alignParentRight"] {
            frameX = root.frame.origin.x + root.frame.width - frameWidth
        }

        if let x = attr["android:layout_below"] {
            if let view = findViewByIdInViews(views: views, id: x) as? UIView {
                frameY = view.frame.origin.y + view.frame.height
            }
        }
        if let x = attr["android:layout_above"] {
            if let view = findViewByIdInViews(views: views, id: x) as? UIView {
                print("view.frame.origin.y : " + view.frame.origin.y.description + ", frameHeight : " + frameHeight.description)
                frameY = view.frame.origin.y - frameHeight
                if frameY < root.frame.origin.y {
                    frameHeight -= root.frame.origin.y - frameY
                    frameY = root.frame.origin.y
                }
            }
        }
        if let x = attr["android:layout_toLeftOf"] {
            if let view = findViewByIdInViews(views: views, id: x) as? UIView {
                frameX = view.frame.origin.x - frameWidth
            }
        }
        if let x = attr["android:layout_toRightOf"] {
            if let view = findViewByIdInViews(views: views, id: x) as? UIView {
                frameX = view.frame.origin.x + view.frame.width
            }
        }

        if let x = attr["android:layout_centerInParent"] {
            frameX = (root.frame.origin.x + (root.frame.width / 2)) - (frameWidth / 2)
            frameY = (root.frame.origin.y + (root.frame.height / 2)) - (frameHeight / 2)
        }
        if let x = attr["android:layout_centerHorizontal"] {
            frameX = (root.frame.origin.x + (root.frame.width / 2)) - (frameWidth / 2)
        }
        if let x = attr["android:layout_centerVertical"] {
            frameY = (root.frame.origin.y + (root.frame.height / 2)) - (frameHeight / 2)
        }

        print("frameX : " + frameX.description + ", frameY : " + frameY.description + ", frameWidth : " + frameWidth.description + ", frameHeight : " + frameHeight.description)
        let frame = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
        if var targetView = target as? UIView {
            targetView.frame = frame
        }
        return frame
    }
}
