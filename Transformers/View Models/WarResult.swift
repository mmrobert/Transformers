//
//  WarResult.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-28.
//

import Foundation

enum WarResult {
    case destroyAll
    case destroySome(teamA: [TransformerViewModel], teamD: [TransformerViewModel])
}
