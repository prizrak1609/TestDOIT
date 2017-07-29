//
//  Server.swift
//  TestDOIT
//
//  Created by Dima Gubatenko on 28.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias ServerLoginCompletion = (Result<String>) -> Void
typealias ServerRegisterCompletion = (Result<String>) -> Void
typealias ServerAllImagesCompletion = (Result<[ImageModel]>) -> Void
typealias ServerGifCompletion = (Result<GifModel>) -> Void
typealias ServerUploadImageCompletion = (Result<Void>) -> Void

final class Server {
    private let baseUrl = "http://api.doitserver.in.ua"

    func login(_ model: LoginParameterModel, _ completion: @escaping ServerLoginCompletion) {
        let url = "\(baseUrl)/login"
        var params = [String : String]()
        params["email"] = model.email.trimmed
        params["password"] = model.password.trimmed
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, method: .post, parameters: params).responseJSON { [weak self] response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let welf = self else { return }
            let result = welf.preParseJSON(response: response)
            if case .failure(var error as ServerError) = result {
                if error.errorString == nil, let json = error.json {
                    error.errorString = json["error"].string
                }
                completion(.failure(error))
                return
            }
            if case .success(let json) = result {
                completion(.success(json["token"].stringValue))
            }
        }
    }

    func register(_ model: RegisterParameterModel, _ completion: @escaping ServerRegisterCompletion) {
        let url = "\(baseUrl)/create"
        var params = [String : String]()
        params["username"] = model.userName?.trimmed
        params["email"] = model.email.trimmed
        params["password"] = model.password.trimmed
        let multipartDataClosure = { (multipart: MultipartFormData) -> Void in
            if let data = UIImageJPEGRepresentation(model.avatar, 1) {
                multipart.append(data, withName: "avatar", fileName: "avatar", mimeType: "image/jpg")
            } else {
                log("can't get jpeg data from image")
            }
            for (key, value) in params {
                if let data = value.data(using: .utf8) {
                    multipart.append(data, withName: key)
                }
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.upload(multipartFormData: multipartDataClosure, to: url) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if case .failure(let error) = result {
                completion(.failure(ServerError(fromError: error)))
                return
            }
            if case .success(let request, _, _) = result {
                request.responseJSON { [weak self] response in
                    guard let welf = self else { return }
                    let result = welf.preParseJSON(response: response)
                    if case .failure(var error as ServerError) = result {
                        if error.errorString == nil, let json = error.json {
                            let userNameErrors = json["children"]["username"]["errors"].arrayValue.map { $0.stringValue }
                            let emailErrors = json["children"]["email"]["errors"].arrayValue.map { $0.stringValue }
                            let passwordErrors = json["children"]["password"]["errors"].arrayValue.map { $0.stringValue }
                            let avatarErrors = json["children"]["avatar"]["errors"].arrayValue.map { $0.stringValue }
                            if !userNameErrors.isEmpty {
                                error.errorString = NSLocalizedString("user name errors: ", comment: "Server") + userNameErrors.joined(separator: "; ")
                            }
                            if !emailErrors.isEmpty {
                                error.errorString = NSLocalizedString("email errors: ", comment: "Server") + emailErrors.joined(separator: "; ")
                            }
                            if !passwordErrors.isEmpty {
                                error.errorString = NSLocalizedString("password errors: ", comment: "Server") + passwordErrors.joined(separator: "; ")
                            }
                            if !avatarErrors.isEmpty {
                                error.errorString = NSLocalizedString("avatar errors: ", comment: "Server") + avatarErrors.joined(separator: "; ")
                            }
                        }
                        completion(.failure(error))
                        return
                    }
                    if case .success(let json) = result {
                        completion(.success(json["token"].stringValue))
                    }
                }
            }
        }
    }

    func getAllImages(_ model: GetAllImagesParametersModel, _ completion: @escaping ServerAllImagesCompletion) {
        let url = "\(baseUrl)/all"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, method: .get, headers: ["token" : model.token]).responseJSON { [weak self] response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let welf = self else { return }
            let result = welf.preParseJSON(response: response)
            if case .failure(let error) = result {
                completion(.failure(error))
                return
            }
            if case .success(let json) = result {
                let images = json["images"].arrayValue.map { ImageModel(json: $0) }
                completion(.success(images))
            }
        }
    }

    func getGif(_ model: GetGifParametersModel, _ completion: @escaping ServerGifCompletion) {
        let url = "\(baseUrl)/gif"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, method: .get, headers: ["token" : model.token]).responseJSON { [weak self] response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let welf = self else { return }
            let result = welf.preParseJSON(response: response)
            if case .failure(let error) = result {
                completion(.failure(error))
                return
            }
            if case .success(let json) = result {
                completion(.success(GifModel(json: json)))
            }
        }
    }

    func uploadImage(_ model: UploadImageParametersModel, _ completion: @escaping ServerUploadImageCompletion) {
        let url = "\(baseUrl)/image"
        var params = [String : String]()
        params["description"] = model.description?.trimmed
        params["hashtag"] = model.hashtag?.trimmed
        params["latitude"] = model.latitude
        params["longitude"] = model.longitude
        let multipartDataClosure = { (multipart: MultipartFormData) -> Void in
            if let data = UIImageJPEGRepresentation(model.image, 1) {
                multipart.append(data, withName: "image", fileName: "image", mimeType: "image/jpg")
            } else {
                log("can't get jpeg data from image")
            }
            for (key, value) in params {
                if let data = value.data(using: .utf8) {
                    multipart.append(data, withName: key)
                }
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.upload(multipartFormData: multipartDataClosure, to: url, headers: ["token" : model.token]) { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if case .failure(let error) = result {
                completion(.failure(ServerError(fromError: error)))
                return
            }
            if case .success(let request, _, _) = result {
                request.responseJSON { [weak self] response in
                    guard let welf = self else { return }
                    let result = welf.preParseJSON(response: response)
                    if case .failure(var error as ServerError) = result {
                        if error.errorString == nil, let json = error.json {
                            let imageErrors = json["children"]["image"]["errors"].arrayValue.map { $0.stringValue }
                            let descriptionErrors = json["children"]["description"]["errors"].arrayValue.map { $0.stringValue }
                            let hashtagErrors = json["children"]["hashtag"]["errors"].arrayValue.map { $0.stringValue }
                            let latitudeErrors = json["children"]["latitude"]["errors"].arrayValue.map { $0.stringValue }
                            let longitudeErrors = json["children"]["longitude"]["errors"].arrayValue.map { $0.stringValue }
                            if !imageErrors.isEmpty {
                                error.errorString = NSLocalizedString("image errors: ", comment: "Server") + imageErrors.joined(separator: "; ")
                            }
                            if !descriptionErrors.isEmpty {
                                error.errorString = NSLocalizedString("description errors: ", comment: "Server") + descriptionErrors.joined(separator: "; ")
                            }
                            if !hashtagErrors.isEmpty {
                                error.errorString = NSLocalizedString("hashtag errors: ", comment: "Server") + hashtagErrors.joined(separator: "; ")
                            }
                            if !latitudeErrors.isEmpty {
                                error.errorString = NSLocalizedString("latitude errors: ", comment: "Server") + latitudeErrors.joined(separator: "; ")
                            }
                            if !longitudeErrors.isEmpty {
                                error.errorString = NSLocalizedString("longitude errors: ", comment: "Server") + longitudeErrors.joined(separator: "; ")
                            }
                        }
                        completion(.failure(error))
                        return
                    }
                    completion(.success())
                }
            }
        }
    }

    private func preParseJSON(response: DataResponse<Any>) -> Result<JSON> {
        guard let code = response.response?.statusCode else {
            return .failure(ServerError(errorString: NSLocalizedString("Can't get response status code", comment: "Server")))
        }
        if code != 200, code != 201 {
            if let data = response.result.value {
                return .failure(ServerError(json: JSON(data)))
            }
            switch code {
                case 400: return .failure(ServerError(errorString: NSLocalizedString("incorrect request data", comment: "Server")))
                case 403: return .failure(ServerError(errorString: NSLocalizedString("invalid access token", comment: "Server")))
                default: break
            }
            return .failure(ServerError(errorString: NSLocalizedString("can't get error data", comment: "Server")))
        }
        if let error = response.error ?? response.result.error {
            return .failure(ServerError(fromError: error))
        }
        if let data = response.result.value {
            return .success(JSON(data))
        }
        return .failure(ServerError(errorString: NSLocalizedString("failure to parse response", comment: "Server")))
    }
}
