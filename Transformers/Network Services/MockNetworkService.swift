//
//  MockNetworkService.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-28.
//

import Foundation
import Combine

class MockNetworkService: NetworkServiceProvider {
    
    static let shared = MockNetworkService()
    
    private init() {}
    
    func fetchToken() -> AnyPublisher<String, NetworkRequestError> {
        let mockToken = "result-token"
        return fetchString(with: mockToken)
    }
    
    func fetchTransformers() -> AnyPublisher<TransformersListDataModel, NetworkRequestError> {
        let mockResponse: [String:Any?] =
            ["transformers":
                [
                    ["id": "-LLbrUN3dQkeejt9vTZc",
                     "name": "Megatron",
                     "strength": 10,
                     "intelligence": 10,
                     "speed": 4,
                     "endurance": 8,
                     "rank": 10,
                     "courage": 9,
                     "firepower": 10,
                     "skill": 9,
                     "team": "D",
                     "team_icon": "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png"
                    ]
                ]
            ]
        return fetchJSON(with: mockResponse)
    }
    
    func createTransformer(bodyParas: [String : Any?]) -> AnyPublisher<TransformerDataModel, NetworkRequestError> {
        let mockResponse: [String:Any?] =
            ["id": "-LLbrUN3dQkeejt9vTZc",
             "name": "Megatron",
             "strength": 10,
             "intelligence": 10,
             "speed": 4,
             "endurance": 8,
             "rank": 10,
             "courage": 9,
             "firepower": 10,
             "skill": 9,
             "team": "D",
             "team_icon": "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png"
            ]
        return fetchJSON(with: mockResponse)
    }
    
    func updateTransformer(bodyParas: [String : Any?]) -> AnyPublisher<TransformerDataModel, NetworkRequestError> {
        let mockResponse: [String:Any?] =
            ["id": "-LLbrUN3dQkeejt9vTZc",
             "name": "Megatron",
             "strength": 10,
             "intelligence": 10,
             "speed": 4,
             "endurance": 8,
             "rank": 10,
             "courage": 9,
             "firepower": 10,
             "skill": 9,
             "team": "D",
             "team_icon": "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png"
            ]
        return fetchJSON(with: mockResponse)
    }
    
    func deleteTransformer(itemID: String) -> AnyPublisher<String, NetworkRequestError> {
        let mockResponse = "result"
        return fetchString(with: mockResponse)
    }
    
    private func fetchString(with mockResponse: String) -> AnyPublisher<String, NetworkRequestError> {
        
        if let mockData = mockResponse.data(using: .utf8) {
            return Just(mockData)
                .setFailureType(to: NetworkRequestError.self)
                .map { String(data: $0, encoding: .utf8) ?? "" }
                .eraseToAnyPublisher()
        } else {
            let error = NetworkRequestError.other(description: "Wrong string response.")
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func fetchJSON<T>(with mockResponse: [String:Any?]) -> AnyPublisher<T, NetworkRequestError> where T: Decodable {
        
        if let mockData = try? JSONSerialization.data(withJSONObject: mockResponse, options: []) {
            return Just(mockData)
                .setFailureType(to: NetworkRequestError.self)
                .flatMap(maxPublishers: .max(1)) { [self] data in
                    decode(data)
                }
                .eraseToAnyPublisher()
        } else {
            let error = NetworkRequestError.other(description: "Wrong response format.")
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func decode<T>(_ data: Data) -> AnyPublisher<T, NetworkRequestError> where T: Decodable {
        let decoder = JSONDecoder()
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                NetworkRequestError.parsingResponseData(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
