//
//  MockNetworkServiceTests.swift
//  TransformersTests
//
//  Created by boqian cheng on 2020-12-26.
//

import XCTest
@testable import Transformers
import Combine

class MockNetworkServiceTests: XCTestCase {
    
    var subject: NetworkServiceProvider!
    var disposables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        subject = MockNetworkService.shared
        disposables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        subject = nil
        disposables = nil
    }

    func testMockFetchToken() {
        
        let expectation = XCTestExpectation(description: "Fetching token.")
        let expectedToken = "result-token"
        
        subject.fetchToken()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { token in
                XCTAssertEqual(token, expectedToken)
                expectation.fulfill()
            })
            .store(in: &disposables)
        wait(for: [expectation], timeout: 10.0)
    }

    func testMockFetchTransformers() {
        
        let expectation = XCTestExpectation(description: "Fetching transformers.")
        let expectedDataModel = [TransformerDataModel(id: "-LLbrUN3dQkeejt9vTZc",
                                                      name: "Megatron",
                                                      strength: 10,
                                                      intelligence: 10,
                                                      speed: 4,
                                                      endurance: 8,
                                                      rank: 10,
                                                      courage: 9,
                                                      firepower: 10,
                                                      skill: 9,
                                                      team: "D",
                                                      team_icon: "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png")]
        
        subject.fetchTransformers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in }, receiveValue: { transformers in
                XCTAssertTrue(!transformers.list.isEmpty)
                XCTAssertEqual(transformers.list, expectedDataModel)
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testMockCreateTransformer() {
        
        let expectation = XCTestExpectation(description: "Creating transformer.")
        let expectedDataModel = TransformerDataModel(id: "-LLbrUN3dQkeejt9vTZc",
                                                      name: "Megatron",
                                                      strength: 10,
                                                      intelligence: 10,
                                                      speed: 4,
                                                      endurance: 8,
                                                      rank: 10,
                                                      courage: 9,
                                                      firepower: 10,
                                                      skill: 9,
                                                      team: "D",
                                                      team_icon: "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png")
        
        subject.createTransformer(bodyParas: [:])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in }, receiveValue: { transformer in
                XCTAssertEqual(transformer, expectedDataModel)
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        wait(for: [expectation], timeout: 10.0)
    }
}
