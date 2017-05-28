//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

func ViewFromTagInfos(tag: String, point: CGPoint, root: ViewGroup, attr: [String: String]) -> View {
    // TODO: point to View
    var view: View
    switch tag {
    case "TextView":
        view = TextView(rootView: root, attr: attr)
    case "ImageView":
        view = ImageView(rootView: root, attr: attr)
    case "Button":
        view = Button(rootView: root, attr: attr)
    case "RelativeLayout":
        view = RelativeLayout(rootView: root, attr: attr)
    case "LinearLayout":
        view = LinearLayout(rootView: root, attr: attr)
    case "RecyclerView":
        view = RecyclerView(rootView: root, attr: attr)
    default:
        view = RelativeLayout(rootView: root, attr: attr)
    }
    return view
}

func IdFromAttr(attr: [String: String]?) -> String? {
    if let attr = attr {
        if let id = attr["android:id"] {
            if id.substring(to: 4) == "@+id" {
                if let index = id.index(of: "/") {
                    return id.substring(from: index + 1)
                }
            }
            if id.substring(to: 3) == "@id" {
                if let index = id.index(of: "/") {
                    return id.substring(from: index + 1)
                }
            }
        }
    }
    return nil
}

func DimenFromAttr(dimen: String) -> String {
    if dimen.characters.count < 6 {
        return "F"
    }
    if dimen.substring(to: 6) == "@dimen" {
        if let index = dimen.index(of: "/") {
            let name = dimen.substring(from: index + 1)
            let dimens = Dimen.shared
            if let value = dimens.dimens[name] {
                return value
            }
            print("dimen: Unexisted Name!!!")
        }
    }
    return "F"
}

func ColorFromAttr(color: String) -> String {
    if color.characters.count < 6 {
        return "F"
    }
    if color.substring(to: 6) == "@color" {
        if let index = color.index(of: "/") {
            let name = color.substring(from: index + 1)
            print("color name : " + name)
            let colors = Color.shared
            if let value = colors.colors[name] {
                return value
            }
            print("color: Unexisted Name!!!")
        }
    }
    return "F"
}

func DrawableFromAttr(drawable: String) -> String {
    if drawable.characters.count < 9 {
        return "F"
    }
    if drawable.substring(to: 9) == "@drawable" {
        if let index = drawable.index(of: "/") {
            let name = drawable.substring(from: index + 1)
            let drawables = Drawable.shared
            if let value = drawables.drawables[name] {
                if let path = Bundle.main.path(forResource: name, ofType: value, inDirectory: "android_drawable") {
                    return path
                }
            }
            print("drawable: Unexisted Name!!!")
        }
    }
    return "F"
}

func OrientationFromAttr(attr: [String: String]?) -> String {
    if let attr = attr {
        if let orientation = attr["android:orientation"] {
            switch orientation {
            case "horizontal":
                return orientation
            case "vertical":
                return orientation
            default:
                return "vertical"
            }
        }
    }
    return "vertical"
}

func SizeFromAttr(root: ViewGroup, attr: [String: String]?) -> CGRect {

    var frameWidth: CGFloat = 0
    var frameHeight: CGFloat = 0

    if let attr = attr {
        if let width = attr["android:layout_width"] {
            if width == "match_parent" {
                frameWidth = root.getMatchWidth()
            } else if width == "wrap_content" {
            } else {
                frameWidth = getCGFloatFromHorizontal(text: width)
            }
        }
        if let height = attr["android:layout_height"] {
            if height == "match_parent" {
                frameHeight = root.getMatchHeight()
            } else if height == "wrap_content" {
            } else {
                frameHeight = getCGFloatFromVertical(text: height)
            }
        }
    }
    return CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
}

func PaddingFromAttr(view: UIView, attr: [String: String]?) -> CGRect {

    var frameX = view.frame.origin.x
    var frameY = view.frame.origin.y
    var frameWidth = view.frame.width
    var frameHeight = view.frame.height

    if let attr = attr {
        if let paddingLeft = attr["android:paddingLeft"] {
            frameX += getCGFloatFromHorizontal(text: paddingLeft)
            frameWidth -= getCGFloatFromHorizontal(text: paddingLeft)
        }
        if let paddingRight = attr["android:paddingRight"] {
            frameWidth -= getCGFloatFromHorizontal(text: paddingRight)
        }
        if let paddingTop = attr["android:paddingTop"] {
            frameY += getCGFloatFromVertical(text: paddingTop)
            frameHeight -= getCGFloatFromHorizontal(text: paddingTop)
        }
        if let paddingBottom = attr["android:paddingBottom"] {
            frameHeight -= getCGFloatFromVertical(text: paddingBottom)
        }
    }
    var rect = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
    print("padding : " + rect.debugDescription)
    return CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
}

func findViewByIdInViews(views: [View], id: String) -> View? {
    var realId = id
    if id.substring(to: 4) == "@+id" || id.substring(to: 3) == "@id" {
        if let index = id.index(of: "/") {
            realId = id.substring(from: index + 1)
        }
    }
    for view in views {
        if let viewid = view.getId() {
            print("view.getId() : " + viewid + ", real : " + realId)
            if viewid == realId {
                return view
            }
        }
        if let v = view as? ViewGroup {
             if let finded = v.findViewById(id: id) as? View {
                 return finded
             }
        }

    }
    return nil
}

func getCGFloatFromHorizontal(text: String!) -> CGFloat {
    return getCGFloatFromString(text: text) * 360 / UIScreen.main.bounds.width
}

func getCGFloatFromVertical(text: String!) -> CGFloat {
    return getCGFloatFromString(text: text) * 640 / UIScreen.main.bounds.height
}

func getCGFloatFromString(text: String!) -> CGFloat {
    do {
        var dimen = DimenFromAttr(dimen: text)
        if dimen == "F" {
            dimen = text
        }
        let regex = try NSRegularExpression(pattern: "\\d+", options: [])
        let nsString = dimen as NSString
        let results = regex.matches(in: dimen, options: [], range: NSMakeRange(0, dimen.characters.count))
        let maps = results.map {
            nsString.substring(with: $0.range)
        }

        if let n = NumberFormatter().number(from: maps[0]) as? CGFloat {
            return n
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
    }
    return 0
}

func BackgroundFromAttr(view: UIView, attr: [String: String]) {
    if var color = attr["android:background"] {
        view.backgroundColor = getColorFromString(color: color)
    }
}

func getColorFromString(color: String) -> UIColor {
    var value = ColorFromAttr(color: color)
    if value == "F" {
        value = DrawableFromAttr(drawable: color)
        if value == "F" {
            value = color
        } else {
            value = "#00000000"
        }
    }
    print("color : " + value)
    return UIColor(hex: value)
}

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        if hex.characters.count == 9 {
            let scanner = Scanner(string: hex)
            scanner.scanLocation = 1  // skip #

            var rgb: UInt64 = 0
            scanner.scanHexInt64(&rgb)

            self.init(
                    red:   CGFloat((rgb &   0xFF0000) >> 16)/255.0,
                    green: CGFloat((rgb &     0xFF00) >>  8)/255.0,
                    blue:  CGFloat((rgb &       0xFF)      )/255.0,
                    alpha: CGFloat((rgb & 0xFF000000) >> 32)/255.0)
        } else if hex.characters.count == 4 {
            var first = hex.substring(with: 1..<2)
            var second = hex.substring(with: 2..<3)
            var third = hex.substring(with: 3..<4)
            var realHex = "#"
            realHex.append(first)
            realHex.append(first)
            realHex.append(second)
            realHex.append(second)
            realHex.append(third)
            realHex.append(third)

            let scanner = Scanner(string: realHex)
            scanner.scanLocation = 1  // skip #

            var rgb: UInt32 = 0
            scanner.scanHexInt32(&rgb)

            self.init(
                    red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
                    green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
                    blue:  CGFloat((rgb &     0xFF)      )/255.0,
                    alpha: alpha)
        } else {
            let scanner = Scanner(string: hex)
            scanner.scanLocation = 1  // skip #

            var rgb: UInt32 = 0
            scanner.scanHexInt32(&rgb)

            self.init(
                    red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
                    green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
                    blue:  CGFloat((rgb &     0xFF)      )/255.0,
                    alpha: alpha)
        }
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
                red: (rgb >> 16) & 0xFF,
                green: (rgb >> 8) & 0xFF,
                blue: rgb & 0xFF
        )
    }
}

extension String {
    func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}