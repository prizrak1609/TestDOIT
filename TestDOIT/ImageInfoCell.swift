//
//  ImageInfoCell.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import AlamofireImage

final class ImageInfoCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var weatherLabel: UILabel!
    @IBOutlet fileprivate weak var addressLabel: UILabel!

    var model: ImageModel? {
        didSet {
            guard let model = model else { return }
            if let url = URL(string: model.urlPath) {
                imageView.af_setImage(withURL: url)
            }
            weatherLabel.text = model.weather
            addressLabel.text = model.address
            addressLabel.sizeToFit()
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
        }
    }
}
