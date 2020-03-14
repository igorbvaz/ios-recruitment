//
//  Service.swift
//  GitHubUsers
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import Alamofire
import RxSwift

class Service {
    func request<T: Decodable>(url: URL?, method: HTTPMethod, parameters: Parameters?) -> Observable<Result<T>> {
        return Observable.create { (observer) -> Disposable in

            let headers = HTTPHeaders(["Authorization":"Bearer \(Keys.authorization)", "Accept":"application/vnd.github.v3+json"])

            print("Request to: \(url?.absoluteString ?? "")")
            AF.request(url?.absoluteString ?? "", method: method, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: T.self) { (response) in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    observer.onNext(.success(value: value))
                case let .failure(error):
                    observer.onNext(.failure(error: error))
                }
                observer.onCompleted()
            }
            return Disposables.create()

        }
    }

    func requestArray<T: Decodable>(url: URL?, method: HTTPMethod, parameters: Parameters?) -> Observable<Result<[T]>> {
        return Observable.create { (observer) -> Disposable in

            let headers = HTTPHeaders(["Authorization":"Bearer \(Keys.authorization)", "Accept":"application/vnd.github.v3+json"])

            print("Request to: \(url?.absoluteString ?? "")")
            AF.request(url?.absoluteString ?? "", method: method, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: [T].self) { (response) in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    observer.onNext(.success(value: value))
                case let .failure(error):
                    observer.onNext(.failure(error: error))
                }
                observer.onCompleted()
            }
            return Disposables.create()

        }
    }
}
