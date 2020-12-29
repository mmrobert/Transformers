//
//  TransformersListDataModel.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-26.
//

import Foundation

struct TransformersListDataModel: Decodable {
    
    let list: [TransformerDataModel]
    
    enum CodingKeys: String, CodingKey {
        case list = "transformers"
    }
}
