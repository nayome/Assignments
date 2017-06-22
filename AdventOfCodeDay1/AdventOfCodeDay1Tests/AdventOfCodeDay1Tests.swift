//
//  AdventOfCodeDay1Tests.swift
//  AdventOfCodeDay1Tests
//
//  Created by nayome.devapriya on 2017/06/21.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import XCTest
@testable import AdventOfCodeDay1

class AdventOfCodeDay1Tests: XCTestCase {
    let testViewController = ViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testInputFileContainsData() {
        let metExpectation = XCTestExpectation()
        let identifier = Bundle.init(identifier: "Exilant.AdventOfCodeDay1Tests")
        
        if let filePath = identifier?.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = testViewController.readContentsOfFile(fromPath: filePath)
            XCTAssertTrue(arrayOfFileContents.count > 0)
            metExpectation.fulfill()
        }
    }
    
    func testParsingInput() {
        let metExpectation = XCTestExpectation()
        let identifier = Bundle.init(identifier: "Exilant.AdventOfCodeDay1Tests")
        
        if let filePath = identifier?.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = testViewController.readContentsOfFile(fromPath: filePath)
            
            XCTAssertTrue(arrayOfFileContents.count > 0)
            for instruction in arrayOfFileContents {
                let commandReceived = testViewController.parse(theInstruction: instruction)
                XCTAssertTrue(commandReceived.numberOfBlocksToMove > 0)
            }
            metExpectation.fulfill()
        }
    }
    
    func testDistanceRevisited() {
        let metExpectation = XCTestExpectation()
        let distanceRevisited = self.testViewController.findRevisitedPath(inputList: ["R8","R4","R4", "R8"])
        print("Distance revisited is ", distanceRevisited)
        XCTAssert(distanceRevisited == 4)
        
        metExpectation.fulfill()
    }
    
    func testDistanceTravelled() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let metExpectation = XCTestExpectation()
        let distanceFound = self.testViewController.calculateDistance(inputList: ["R2","L3","L4", "L4"])
        print("Distance travelled is",distanceFound," blocks")
        
        XCTAssert(distanceFound == 3)
        metExpectation.fulfill()
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
