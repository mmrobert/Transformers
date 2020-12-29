//
//  NetworkAPIs.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-26.
//

import Foundation
import Combine

enum NetworkAPI {
    
    enum RequestMethod: String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case delete  = "DELETE"
    }
    
    // MARK: - for each endpoind of backend
    case token
    case create(headers: [String:String]?, bodyParas: [String:Any?]?)
    case list(headers: [String:String]?, queryParas: [String:String]?, bodyParas: [String:Any?]?)
    case update(headers: [String:String]?, bodyParas: [String:Any?]?)
    case delete(headers: [String:String]?, itemID: String)
    
    // MARK: - base URL
    var baseURL: String {
        switch self {
        default:
            return "https://transformers-api.firebaseapp.com"
        }
        // https://transformers-api.firebaseapp.com/allspark
    }
    
    // MARK: - Request Method
    var method: RequestMethod {
        switch self {
        case .token:
            return .get
        case .create( _, _):
            return .post
        case .list( _, _, _):
            return .get
        case .update( _, _):
            return .put
        case .delete( _, _):
            return .delete
        }
    }
    
    // MARK: - path string
    var path: String {
        switch self {
        case .token:
            return "/allspark"
        case .create( _, _):
            return "/transformers"
        case .list( _, _, _):
            return "/transformers"
        case .update( _, _):
            return "/transformers"
        case .delete( _, let itemID):
            return "/transformers/" + itemID
        }
    }
    
    // MARK: - headers
    var headers: [String:String]? {
        switch self {
        case .token:
            return nil
        case .create(let headers, _):
            return headers
        case .list(let headers, _, _):
            return headers
        case .update(let headers, _):
            return headers
        case .delete(let headers, _):
            return headers
        }
    }
    
    // MARK: - query parameters like ...?key=value
    var queryItems: [URLQueryItem]? {
        switch self {
        case .token:
            return nil
        case .create( _, _):
            return nil
        case .list( _, let queryParas, _):
            if let query = queryParas {
                return query.map({
                    URLQueryItem(name: $0.key, value: $0.value)
                })
            } else {
                return nil
            }
        case .update( _, _):
            return nil
        case .delete( _, _):
            return nil
        }
    }
    
    // MARK: - body parameters
    var bodyParameters: [String:Any?]? {
        switch self {
        case .token:
            return nil
        case .create( _, let bodyParas):
            return bodyParas
        case .list( _, _, let bodyParas):
            return bodyParas
        case .update( _, let bodyParas):
            return bodyParas
        case .delete( _, _):
            return nil
        }
    }
    
    // MARK: - URLRequest creating
    func makeURLRequest() throws -> URLRequest {
        
        let fullPath = baseURL + path
        guard var urlComponent = URLComponents(string: fullPath) else { throw NetworkRequestError.invalidURL(description: "Wrong URL: \(fullPath)") }
        
        if let query = queryItems {
            urlComponent.queryItems = query
        }
        
        guard let url = urlComponent.url else { throw NetworkRequestError.invalidURL(description: "Wrong URL: \(fullPath)") }
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        if let headers = headers {
            if let token = headers["Authorization"] {
                let bearer = "Bearer \(token)"
                urlRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
            }
            if let contentType = headers["Content-Type"] {
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
        }
        
        // body parameters
        if let body = bodyParameters {
            let body = body.compactMapValues { $0 }
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch let error {
                throw NetworkRequestError.bodyToJSON(description: "Body serialization error: \(error.localizedDescription)")
            }
        }
        return urlRequest
    }
    
    // MARK: - network by urlsession (Combine framework)
    func fetchString(request: URLRequest) -> AnyPublisher<String, NetworkRequestError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                NetworkRequestError.netConnection(description: error.localizedDescription)
            }
            .map { String(data: $0.data, encoding: .utf8) ?? "" }
            .eraseToAnyPublisher()
    }
    
    // MARK: - network by urlsession (Combine framework)
    func fetchJSON<T>(request: URLRequest) -> AnyPublisher<T, NetworkRequestError> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                NetworkRequestError.netConnection(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { response in
                decode(response.data)
            }
            .eraseToAnyPublisher()
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
