//
//  ImageModel.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct ImageModel {
    let urlPath: String
    let weather: String
    let address: String

    init(json: JSON) {
        urlPath = json["smallImagePath"].stringValue
        let parameters = json["parameters"]
        weather = parameters["weather"].stringValue
        address = parameters["address"].stringValue
    }
}
