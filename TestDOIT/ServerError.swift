//
//  ServerError.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ServerError : Error {
    var errorString: String?
    var json: JSON?

    var localizedDescription: String {
        return errorString ?? "\(String(describing: json))"
    }

    init(fromError error: Error) {
        errorString = error.localizedDescription
    }

    init(errorString: String) {
        self.errorString = errorString
    }

    init(json: JSON) {
        self.json = json
    }
}
