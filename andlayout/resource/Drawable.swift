//
// Created by RubinYeom on 2017. 5. 13..
// Copyright (c) 2017 UXInter. All rights reserved.
//

final class Drawable {

    // Can't init is singleton
    private init() { }

    // MARK: Shared Instance

    static let shared = Drawable()

    // MARK: Local Variable

    var drawables : [String: String] = [:]
}