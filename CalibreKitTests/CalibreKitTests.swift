//
//  CalibreKitTests.swift
//  CalibreKitTests
//
//  Created by Justin Marshall on 10/7/18.
//
//  CalibreKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  CalibreKit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with CalibreKit.  If not, see <https://www.gnu.org/licenses/>.
//
//  Copyright © 2018 Justin Marshall
//  This file is part of project: CalibreKit
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
//        let theExpectation = expectation(description: "")
        BooksEndpoint().hitService { booksResponse in
            booksResponse.result.value?.first?.cover.hitService { coverResponse in
                print()
            }
            
            booksResponse.result.value?.first?.thumbnail.hitService { thumbnnailResponse in
                print()
            }
        }
        
//        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
