//
//  DataCenter.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-26.
//

import Foundation
import Combine

class DataCenter {
    
    static let shared = DataCenter()
    
    @Published var list: [TransformerDataModel] = []
    private var disposables = Set<AnyCancellable>()
    
    private init() {}
    
    func fetchToken() {
        NetworkService.shared.fetchToken()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
            }, receiveValue: { token in
                // cache "token"
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.synchronize()
            })
            .store(in: &disposables)
    }
    
    func fetchTransformers() {
        NetworkService.shared.fetchTransformers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let strongSelf = self else { return }
                switch value {
                case .failure:
                    strongSelf.list = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] transformers in
                guard let strongSelf = self else { return }
                strongSelf.list = transformers.list
            })
            .store(in: &disposables)
    }
    
    func createTransformer(transformer: TransformerDataModel) {
        let dict = transformer.toDictionary()
        NetworkService.shared.createTransformer(bodyParas: dict)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] transformer in
                guard let strongSelf = self else { return }
                strongSelf.list.append(transformer)
            })
            .store(in: &disposables)
    }
    
    func updateTransformer(transformer: TransformerDataModel) {
        let dict = transformer.toDictionary()
        NetworkService.shared.updateTransformer(bodyParas: dict)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] transformer in
                guard let strongSelf = self else { return }
                strongSelf.list.removeAll {
                    $0.id == transformer.id
                }
                strongSelf.list.append(transformer)
            })
            .store(in: &disposables)
    }
    
    func deleteTransformer(transformer: TransformerDataModel) {
        guard let id = transformer.id else {
            return
        }
        NetworkService.shared.deleteTransformer(itemID: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.list.removeAll {
                    $0.id == id
                }
            })
            .store(in: &disposables)
    }
}
