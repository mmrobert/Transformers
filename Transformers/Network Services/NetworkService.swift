//
//  NetworkService.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-26.
//

import Foundation
import Combine

protocol NetworkServiceProvider {
    func fetchToken() -> AnyPublisher<String, NetworkRequestError>
    func fetchTransformers() -> AnyPublisher<TransformersListDataModel, NetworkRequestError>
    func createTransformer(bodyParas: [String:Any?]) -> AnyPublisher<TransformerDataModel, NetworkRequestError>
    func updateTransformer(bodyParas: [String:Any?]) -> AnyPublisher<TransformerDataModel, NetworkRequestError>
    func deleteTransformer(itemID: String) -> AnyPublisher<String, NetworkRequestError>
}

class NetworkService: NetworkServiceProvider {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchToken() -> AnyPublisher<String, NetworkRequestError> {
        let router = NetworkAPI.token
        do {
            let netRequest = try router.makeURLRequest()
            return router.fetchString(request: netRequest)
        } catch let error {
            if let error = error as? NetworkRequestError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                let error = NetworkRequestError.other(description: error.localizedDescription)
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
    
    func fetchTransformers() -> AnyPublisher<TransformersListDataModel, NetworkRequestError> {
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            let error = NetworkRequestError.other(description: "Errror: no token.")
            return Fail(error: error).eraseToAnyPublisher()
        }
        let header = ["Authorization": token, "Content-Type": "application/json"]
        let router = NetworkAPI.list(headers: header, queryParas: nil, bodyParas: nil)
        do {
            let netRequest = try router.makeURLRequest()
            return router.fetchJSON(request: netRequest)
        } catch let error {
            if let error = error as? NetworkRequestError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                let error = NetworkRequestError.other(description: error.localizedDescription)
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
    
    func createTransformer(bodyParas: [String:Any?]) -> AnyPublisher<TransformerDataModel, NetworkRequestError> {
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            let error = NetworkRequestError.other(description: "Errror: no token.")
            return Fail(error: error).eraseToAnyPublisher()
        }
        let header = ["Authorization": token, "Content-Type": "application/json"]
        let router = NetworkAPI.create(headers: header, bodyParas: bodyParas)
        do {
            let netRequest = try router.makeURLRequest()
            return router.fetchJSON(request: netRequest)
        } catch let error {
            if let error = error as? NetworkRequestError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                let error = NetworkRequestError.other(description: error.localizedDescription)
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
    
    func updateTransformer(bodyParas: [String:Any?]) -> AnyPublisher<TransformerDataModel, NetworkRequestError> {
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            let error = NetworkRequestError.other(description: "Errror: no token.")
            return Fail(error: error).eraseToAnyPublisher()
        }
        let header = ["Authorization": token, "Content-Type": "application/json"]
        let router = NetworkAPI.update(headers: header, bodyParas: bodyParas)
        do {
            let netRequest = try router.makeURLRequest()
            return router.fetchJSON(request: netRequest)
        } catch let error {
            if let error = error as? NetworkRequestError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                let error = NetworkRequestError.other(description: error.localizedDescription)
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
    
    func deleteTransformer(itemID: String) -> AnyPublisher<String, NetworkRequestError> {
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            let error = NetworkRequestError.other(description: "Errror: no token.")
            return Fail(error: error).eraseToAnyPublisher()
        }
        let header = ["Authorization": token, "Content-Type": "application/json"]
        let router = NetworkAPI.delete(headers: header, itemID: itemID)
        do {
            let netRequest = try router.makeURLRequest()
            return router.fetchString(request: netRequest)
        } catch let error {
            if let error = error as? NetworkRequestError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                let error = NetworkRequestError.other(description: error.localizedDescription)
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
}
