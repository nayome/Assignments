//
//  AdventOfCodeDay4Tests.swift
//  AdventOfCodeDay4Tests
//
//  Created by nayome.devapriya on 2017/06/21.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import XCTest
@testable import AdventOfCodeDay4

class AdventOfCodeDay4Tests: XCTestCase {
    
    var testViewController = ViewController()
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
        let identifier = Bundle.init(identifier: "Exilant.AdventOfCodeDay4Tests")
        
        if let filePath = identifier?.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = testViewController.readContentsOfFile(fromPath: filePath)
            XCTAssertTrue(arrayOfFileContents.count > 0)
            metExpectation.fulfill()
        }
    }
    
    func testParsingInput() {
        let metExpectation = XCTestExpectation()
        let identifier = Bundle.init(identifier: "Exilant.AdventOfCodeDay4Tests")
        
        if let filePath = identifier?.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = testViewController.readContentsOfFile(fromPath: filePath)
            
            XCTAssertTrue(arrayOfFileContents.count > 0)
            let parsedArray = testViewController.parseInputToStrings(InputList: arrayOfFileContents)
            XCTAssertTrue(parsedArray.count > 0)
        }
        metExpectation.fulfill()
    }

    
    func testFindSectorWhichIsStoredInNorthPole() {
        let metExpectation = XCTestExpectation()
        let parsedStrings = testViewController.parseInputToStrings(InputList: ["aaaaa-bbb-z-y-x-123[abxyz]", "a-b-c-d-e-f-g-h-987[abcde]", "not-a-real-room-404[oarel]", "totally-real-room-200[decoy]", "qzmt-zixmtkozy-ivhz-343"])
        let sectorId = testViewController.findRoomFrom(parsedStrings: parsedStrings, whoseRealNameContains: "very encrypted")
        XCTAssert(sectorId == 343)
        metExpectation.fulfill()
    }
    
    func testFindRealRommAndAddSector() {
        let metExpectation = XCTestExpectation()
        let parsedStrings = testViewController.parseInputToStrings(InputList: ["aaaaa-bbb-z-y-x-123[abxyz]", "a-b-c-d-e-f-g-h-987[abcde]", "not-a-real-room-404[oarel]", "totally-real-room-200[decoy]"])
        let sumOfSectors = testViewController.findRealRoomsAndAddSectorIdFor(parsedStrings: parsedStrings)
        XCTAssert(sumOfSectors == 1514)
        metExpectation.fulfill()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }    
}
