//
//  AdventOfCodeDay10Tests.swift
//  AdventOfCodeDay10Tests
//
//  Created by nayome.devapriya on 2017/06/21.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import XCTest
@testable import AdventOfCodeDay10

class AdventOfCodeDay10Tests: XCTestCase {
    
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
        let identifier = Bundle.init(identifier: "Exilant.AdventOfCodeDay10Tests")
        
        if let filePath = identifier?.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = testViewController.readContentsOfFile(fromPath: filePath)
            XCTAssertTrue(arrayOfFileContents.count > 0)
            metExpectation.fulfill()
        }
    }
    
    func testParsingInput() {
        let metExpectation = XCTestExpectation()
        let identifier = Bundle.init(identifier: "Exilant.AdventOfCodeDay10Tests")
        
        if let filePath = identifier?.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = testViewController.readContentsOfFile(fromPath: filePath)
            
            XCTAssertTrue(arrayOfFileContents.count > 0)
            let prasingsucceeded = testViewController.parseTheInput(fileConentsArray: arrayOfFileContents)
            XCTAssertTrue(prasingsucceeded == true)
        }
        metExpectation.fulfill()
    }

    func testProcessingBots() {
        let metExpectation = XCTestExpectation()
        let inputArrayList = ["value 5 goes to bot 2", "bot 2 gives low to bot 1 and high to bot 0",
                              "value 3 goes to bot 1",
                              "bot 1 gives low to output 1 and high to bot 0",
                              "bot 0 gives low to output 2 and high to output 0",
                              "value 2 goes to bot 2"]
//        let inputArrayList = ["value fbzdfggdfgg fgdfgdfgtwdsadasda ewfsfsdgsdgs"]
        let prasingsucceeded = testViewController.parseTheInput(fileConentsArray: inputArrayList)
        
        XCTAssertTrue(prasingsucceeded == true)
        
        testViewController.processBots()

        XCTAssertTrue(testViewController.botsToBeProcessed.keys.count == testViewController.botsThatAreProcessed.count)
        metExpectation.fulfill()
    }
    
    func testFindBotsResponsible()
    {
        let metExpectation = XCTestExpectation()
        let inputArrayList = ["value 5 goes to bot 2", "bot 2 gives low to bot 1 and high to bot 0",
                              "value 3 goes to bot 1",
                              "bot 1 gives low to output 1 and high to bot 0",
                              "bot 0 gives low to output 2 and high to output 0",
                              "value 2 goes to bot 2"]
        let prasingsucceeded = testViewController.parseTheInput(fileConentsArray: inputArrayList)
        XCTAssertTrue(prasingsucceeded == true)
        testViewController.processBots()
        
        //Find the bot responsible for given input
        let inputValue = (highValue: 5,lowValue: 2)
        let responsibleBot = testViewController.findBotResponsibleForComparing(highvalue: inputValue.highValue, lowValue: inputValue.lowValue)
        print("The number of the bot that is responsible for comparing value-\(String(inputValue.highValue)) microchips with value-\(String(inputValue.lowValue)) microchips is ",responsibleBot);
        XCTAssertTrue(responsibleBot == 2)
        metExpectation.fulfill()
    }
    
    func testMultiplyValuesInOutput()
    {
        let metExpectation = XCTestExpectation()
        let inputArrayList = ["value 5 goes to bot 2", "bot 2 gives low to bot 1 and high to bot 0",
                              "value 3 goes to bot 1",
                              "bot 1 gives low to output 1 and high to bot 0",
                              "bot 0 gives low to output 2 and high to output 0",
                              "value 2 goes to bot 2"]
        let prasingsucceeded = testViewController.parseTheInput(fileConentsArray: inputArrayList)
        XCTAssertTrue(prasingsucceeded == true)
        testViewController.processBots()
        
        //Find the bot responsible for given input
        let part2Input = [0,1,2]
        let multipliedValueOfBins = testViewController.mutiplyValuesPresentIn(bins: part2Input)
        print("On multiplying the values of output bin at \(String(describing: part2Input)) is",multipliedValueOfBins)
        
        XCTAssertTrue(multipliedValueOfBins == 30)
        metExpectation.fulfill()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
