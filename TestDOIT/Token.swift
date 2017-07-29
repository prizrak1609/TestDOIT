//
//  Token.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation

final class Token {

    var userToken = ""

    static let shared = Token()

    private init() {}
}
