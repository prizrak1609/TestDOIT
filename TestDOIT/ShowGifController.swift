//
//  ShowGifController.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 29.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class ShowGifController: UIViewController {
    @IBOutlet fileprivate weak var gifViewImageView: UIImageView!

    fileprivate let server = Server()

    override func viewDidLoad() {
        super.viewDidLoad()
        server.getGif(GetGifParametersModel(token: Token.shared.userToken)) { [weak self] result in
            guard let welf = self else { return }
            if case .failure(let error as ServerError) = result {
                showText(error.localizedDescription)
                return
            }
            if case .success(let gifModel) = result, let url = URL(string: gifModel.urlPath) {
                welf.gifViewImageView.image = UIImage.animatedImage(withAnimatedGIFURL: url)
            }
        }
    }

    @IBAction func closeScreen(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
