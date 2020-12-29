//
//  TransformerViewModel.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-27.
//

import Foundation

struct TransformerViewModel: Identifiable {
    var id = UUID()
    var idTransformer: String?
    var name: String
    var strength: Int
    var intelligence: Int
    var speed: Int
    var endurance: Int
    var rank: Int
    var courage: Int
    var firepower: Int
    var skill: Int
    var team: String
    var team_icon: String?
    
    init(dataModel: TransformerDataModel) {
        self.idTransformer = dataModel.id
        self.name = dataModel.name
        self.strength = dataModel.strength
        self.intelligence = dataModel.intelligence
        self.speed = dataModel.speed
        self.endurance = dataModel.endurance
        self.rank = dataModel.rank
        self.courage = dataModel.courage
        self.firepower = dataModel.firepower
        self.skill = dataModel.skill
        self.team = dataModel.team
        self.team_icon = dataModel.team_icon
    }
    
    static func toDataModel(viewModel: TransformerViewModel) -> TransformerDataModel {
        return TransformerDataModel(id: viewModel.idTransformer,
                                    name: viewModel.name,
                                    strength: viewModel.strength,
                                    intelligence: viewModel.intelligence,
                                    speed: viewModel.speed,
                                    endurance: viewModel.endurance,
                                    rank: viewModel.rank,
                                    courage: viewModel.courage,
                                    firepower: viewModel.firepower,
                                    skill: viewModel.skill,
                                    team: viewModel.team,
                                    team_icon: viewModel.team_icon)
    }
    
    static func createEmptyTransformer() -> TransformerViewModel {
        return TransformerViewModel(dataModel: TransformerDataModel(id: nil, name: "", strength: 5, intelligence: 5, speed: 5, endurance: 5, rank: 5, courage: 5, firepower: 5, skill: 5, team: "", team_icon: nil))
    }
}
