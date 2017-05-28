//
// Created by RubinYeom on 2017. 3. 29..
// Copyright (c) 2017 UXInter. All rights reserved.
//

import Foundation
import UIKit

protocol View {

    var attr: [String: String] { get }

    func getId() -> String?
    func getRootView() -> ViewGroup
    func setAttribute(attr: [String: String])
    func getWrapWidth() -> CGFloat
    func getWrapHeight() -> CGFloat
    func getFrame() -> CGRect
}