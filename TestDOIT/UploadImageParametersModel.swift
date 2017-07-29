//
//  UploadImageParametersModel.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct UploadImageParametersModel {
    let image: UIImage
    let description: String?
    let hashtag: String?
    let latitude: String
    let longitude: String
    let token: String
}
