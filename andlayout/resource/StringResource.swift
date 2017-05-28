//
// Created by RubinYeom on 2017. 5. 13..
// Copyright (c) 2017 UXInter. All rights reserved.
//

final class StringResource {

    // Can't init is singleton
    private init() { }

    // MARK: Shared Instance

    static let shared = StringResource()

    // MARK: Local Variable

    var strings : [String: String] = [:]

}