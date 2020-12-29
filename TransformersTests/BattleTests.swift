//
//  BattleTests.swift
//  TransformersTests
//
//  Created by boqian cheng on 2020-12-28.
//

import XCTest
@testable import Transformers

class BattleTests: XCTestCase {
    
    var subject: TransformersListViewModel!
    var data1: TransformerDataModel!
    var data2: TransformerDataModel!
    var data3: TransformerDataModel!
    var data4: TransformerDataModel!

    override func setUpWithError() throws {
        subject = TransformersListViewModel()
        data1 = TransformerDataModel(id: nil,
                                     name: "Sound",
                                     strength: 8,
                                     intelligence: 9,
                                     speed: 2,
                                     endurance: 6,
                                     rank: 7,
                                     courage: 5,
                                     firepower: 6,
                                     skill: 10,
                                     team: "D",
                                     team_icon: nil)
        data2 = TransformerDataModel(id: nil,
                                     name: "Blue",
                                     strength: 6,
                                     intelligence: 6,
                                     speed: 7,
                                     endurance: 9,
                                     rank: 5,
                                     courage: 2,
                                     firepower: 9,
                                     skill: 7,
                                     team: "A",
                                     team_icon: nil)
        data3 = TransformerDataModel(id: nil,
                                     name: "Hub",
                                     strength: 4,
                                     intelligence: 4,
                                     speed: 4,
                                     endurance: 4,
                                     rank: 4,
                                     courage: 4,
                                     firepower: 4,
                                     skill: 4,
                                     team: "A",
                                     team_icon: nil)
        data4 = TransformerDataModel(id: nil,
                                     name: "Optimus Prime",
                                     strength: 4,
                                     intelligence: 4,
                                     speed: 4,
                                     endurance: 4,
                                     rank: 7,
                                     courage: 4,
                                     firepower: 4,
                                     skill: 4,
                                     team: "A",
                                     team_icon: nil)
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testBattle_Skill() {
        
        let sound = TransformerViewModel(dataModel: data1)
        let blue = TransformerViewModel(dataModel: data2)
        let hub = TransformerViewModel(dataModel: data3)
        subject.list = [sound, blue, hub]
        
        let result = subject.start()
        
        switch result {
        case .destroyAll:
            XCTFail("Wrong!")
        case .destroySome(let teamA, let teamD):
            XCTAssertEqual(teamA.count, 1)
            XCTAssertEqual(teamD.count, 0)
        }
    }
    
    func testBattle_SpecialName() {
        
        let sound = TransformerViewModel(dataModel: data1)
        let blue = TransformerViewModel(dataModel: data2)
        let hub = TransformerViewModel(dataModel: data3)
        let optimus_prime = TransformerViewModel(dataModel: data4)
        subject.list = [sound, blue, hub, optimus_prime]
        
        let result = subject.start()
        
        switch result {
        case .destroyAll:
            XCTFail("Wrong!")
        case .destroySome(let teamA, let teamD):
            XCTAssertEqual(teamA.count, 0)
            XCTAssertEqual(teamD.count, 1)
        }
    }
}
