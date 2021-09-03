//
//  AllTrailsLunchtimeTests.swift
//  AllTrailsLunchtimeTests
//
//  Created by Osamu Chiba on 8/26/21.
//

import XCTest
@testable import AllTrailsLunchtime

class AllTrailsLunchtimeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertTrue(priceRangeAsDollarSigns(priceLevel: 1) == "$")
        XCTAssertTrue(priceRangeAsDollarSigns(priceLevel: 2) == "$$")
        XCTAssertTrue(priceRangeAsDollarSigns(priceLevel: 3) == "$$$")
        XCTAssertTrue(priceRangeAsDollarSigns(priceLevel: 4) == "$$$$")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func priceRangeAsDollarSigns(priceLevel: Int) -> String {
        var level = "$" // At least one $.

        for _ in 1..<priceLevel {
            level = "\(level)$"
        }
        
        return level
    }

}
