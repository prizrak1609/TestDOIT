//
//  GifModel.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GifModel {
    let urlPath: String

    init(json: JSON) {
        urlPath = json["gif"].stringValue
    }
}
