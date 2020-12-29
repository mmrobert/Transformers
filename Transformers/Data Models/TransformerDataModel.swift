//
//  TransformerDataModel.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-26.
//

import Foundation

struct TransformerDataModel: Decodable, Equatable {
    
    let id: String?
    let name: String
    let strength: Int
    let intelligence: Int
    let speed: Int
    let endurance: Int
    let rank: Int
    let courage: Int
    let firepower: Int
    let skill: Int
    let team: String
    let team_icon: String?
    
    func toDictionary() -> [String: Any?] {
        let dict = [
            CodingKeys.id.rawValue: self.id,
            CodingKeys.name.rawValue: self.name,
            CodingKeys.strength.rawValue: self.strength,
            CodingKeys.intelligence.rawValue: self.intelligence,
            CodingKeys.speed.rawValue: self.speed,
            CodingKeys.endurance.rawValue: self.endurance,
            CodingKeys.rank.rawValue: self.rank,
            CodingKeys.courage.rawValue: self.courage,
            CodingKeys.firepower.rawValue: self.firepower,
            CodingKeys.skill.rawValue: self.skill,
            CodingKeys.team.rawValue: self.team,
            CodingKeys.team_icon.rawValue: self.team_icon
            ] as [String : Any?]
        
        return dict
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case strength
        case intelligence
        case speed
        case endurance
        case rank
        case courage
        case firepower
        case skill
        case team
        case team_icon
    }
}
