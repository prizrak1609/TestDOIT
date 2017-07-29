//
//  StringExt.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation

extension String {

    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var trimmed: String {
        return trimmingCharacters(in: .whitespaces)
    }
}
