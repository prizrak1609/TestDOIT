//
//  MainScreen.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "ImageInfoCell"

final class MainScreen: UICollectionViewController {

    fileprivate var models = [ImageModel]()
    fileprivate let server = Server()

    override func viewDidLoad() {
        super.viewDidLoad()
        // init collection view
        if let collectionView = collectionView, let flowLayout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout) {
            collectionView.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
            let width = collectionView.bounds.width
            let sectionInsets = flowLayout.sectionInset
            let minSpacing = flowLayout.minimumLineSpacing
            let cellWidth = (width - sectionInsets.right - sectionInsets.left - minSpacing) / 2
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            let refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(reloadData(_:)), for: .valueChanged)
            collectionView.refreshControl = refresh
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataFromServer()
    }

    func getDataFromServer(_ completion: (() -> Void)? = nil) {
        server.getAllImages(GetAllImagesParametersModel(token: Token.shared.userToken)) { [weak self] result in
            guard let welf = self else { return }
            if case .failure(let error as ServerError) = result {
                showText(error.localizedDescription)
                return
            }
            if case .success(let models) = result {
                welf.models = models
                welf.collectionView?.reloadData()
                completion?()
            }
        }
    }

    func reloadData(_ refreshControl: UIRefreshControl) {
        getDataFromServer {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension MainScreen {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? ImageInfoCell else { return UICollectionViewCell() }
        cell.model = models[indexPath.item]
        return cell
    }

     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return false
     }
}
