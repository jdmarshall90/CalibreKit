//
//  CalibreKitTests.swift
//  CalibreKitTests
//
//  Created by Justin Marshall on 10/7/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

@testable import CalibreKit
import XCTest

class CalibreKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let theExpectation = expectation(description: "")
        BooksEndpoint().hitService { booksResponse in
            booksResponse.result.value?.first?.cover.hitService { coverResponse in
                print()
            }
            
            booksResponse.result.value?.first?.thumbnail.hitService { thumbnnailResponse in
                print()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
