//
//  TransformersListViewModel.swift
//  Transformers
//
//  Created by boqian cheng on 2020-12-27.
//

import Foundation
import Combine
import SwiftUI

// binding to DataCenter
// MainEntryView has a reference to this class
class TransformersListViewModel: ObservableObject {
    
    @Published var viewLoaded: Bool = false
    @Published var list: [TransformerViewModel] = []
    private var disposables = Set<AnyCancellable>()
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init() {
        $viewLoaded
            .sink(receiveValue: fetchTransformers(viewLoaded:))
            .store(in: &disposables)
        // subscribing to DataCenter "list" - @Published
        DataCenter.shared.$list
            .sink(receiveValue: { [weak self] list in
                guard let strongSelf = self else { return }
                strongSelf.list = list.map {
                    TransformerViewModel(dataModel: $0)
                }
            })
            .store(in: &disposables)
    }
    
    private func fetchTransformers(viewLoaded: Bool) {
        if viewLoaded {
            DataCenter.shared.fetchTransformers()
        }
    }
    
    func startBattle() {
        
        let result = start()
        switch result {
        case .destroyAll:
            alertTitle = "Re-create and Re-start"
            alertMessage = "It is a match by special name."
            showingAlert = true
            let allList = list
            for player in allList {
                TransformersListViewModel.deleteTransformer(transformer: player)
            }
        case .destroySome(let teamA, let teamD):
            if teamA.count > teamD.count {
                alertTitle = "Team D is the winner."
                alertMessage = ""
                showingAlert = true
            } else if teamA.count < teamD.count {
                alertTitle = "Team A is the winner."
                alertMessage = ""
                showingAlert = true
            } else {
                alertTitle = "No winner, it is a match."
                alertMessage = ""
                showingAlert = true
            }
            for player in teamA {
                TransformersListViewModel.deleteTransformer(transformer: player)
            }
            for player in teamD {
                TransformersListViewModel.deleteTransformer(transformer: player)
            }
        }
    }
    
    func start() -> WarResult {
        
        var teamA_Destroyed: [TransformerViewModel] = []
        var teamD_Destroyed: [TransformerViewModel] = []
        
        let teamA = list.filter {
            $0.team == "A"
        }.sorted(by: { $0.rank > $1.rank })
        let teamD = list.filter {
            $0.team == "D"
        }.sorted(by: { $0.rank > $1.rank })
        
        let battleNo = min(teamA.count, teamD.count)
        
        for i in 0..<battleNo {
            let teamA_Player = teamA[i]
            let teamD_Player = teamD[i]
            if (teamA_Player.name == "Optimus Prime" || teamA_Player.name == "Predaking") && (teamD_Player.name == "Optimus Prime" || teamD_Player.name == "Predaking") {
                return WarResult.destroyAll
            } else if let result = fight(A_player: teamA_Player, D_player: teamD_Player) {
                if result.team == "A" {
                    teamA_Destroyed.append(result.transformer)
                } else {
                    teamD_Destroyed.append(result.transformer)
                }
            } else {
                teamA_Destroyed.append(teamA_Player)
                teamD_Destroyed.append(teamD_Player)
            }
        }
        return WarResult.destroySome(teamA: teamA_Destroyed, teamD: teamD_Destroyed)
    }
    
    private func fight(A_player: TransformerViewModel, D_player: TransformerViewModel) -> (team: String, transformer: TransformerViewModel)? {
        
        let rateA = A_player.strength + A_player.intelligence + A_player.speed + A_player.endurance + A_player.firepower
        let rateD = D_player.strength + D_player.intelligence + D_player.speed + D_player.endurance + D_player.firepower
        
        if A_player.name == "Optimus Prime" || A_player.name == "Predaking" {
            return ("D", D_player)
        } else if D_player.name == "Optimus Prime" || D_player.name == "Predaking" {
            return ("A", A_player)
        } else if (A_player.courage <= D_player.courage - 4) && (A_player.strength <= D_player.strength - 3) {
            return ("A", A_player)
        } else if (D_player.courage <= A_player.courage - 4) && (D_player.strength <= A_player.strength - 3) {
            return ("D", D_player)
        } else if A_player.skill >= D_player.skill + 3 {
            return ("D", D_player)
        } else if D_player.skill >= A_player.skill + 3 {
            return ("A", A_player)
        } else if rateA < rateD {
            return ("A", A_player)
        } else if rateD < rateA {
            return ("D", D_player)
        } else {
            return nil
        }
    }
    
    static func createTransformer(transformer: TransformerViewModel) {
        let dataModel = TransformerViewModel.toDataModel(viewModel: transformer)
        DataCenter.shared.createTransformer(transformer: dataModel)
    }
    
    static func updateTransformer(transformer: TransformerViewModel) {
        let dataModel = TransformerViewModel.toDataModel(viewModel: transformer)
        DataCenter.shared.updateTransformer(transformer: dataModel)
    }
    
    static func deleteTransformer(transformer: TransformerViewModel) {
        let dataModel = TransformerViewModel.toDataModel(viewModel: transformer)
        DataCenter.shared.deleteTransformer(transformer: dataModel)
    }
}


