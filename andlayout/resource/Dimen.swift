//
// Created by RubinYeom on 2017. 5. 13..
// Copyright (c) 2017 UXInter. All rights reserved.
//

final class Dimen {

    // Can't init is singleton
    private init() { }

    // MARK: Shared Instance

    static let shared = Dimen()

    // MARK: Local Variable

    var dimens : [String: String] = [:]

}