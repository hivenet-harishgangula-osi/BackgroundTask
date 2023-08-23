//
//  SampleiOSAppTests.swift
//  SampleiOSAppTests
//
//  Created by hgangula on 14/02/23.
//

import XCTest
@testable import SampleiOSApp

final class SampleiOSAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        passwordTestCases()
    }
    
    func passwordTestCases() {
        let viewModel = StorageViewModel()
        let password = "Abcd@12345"
        
        XCTAssertTrue(viewModel.isValidPassword(password: password))
        XCTAssertFalse(viewModel.isValidPassword(password: "abc"))
        XCTAssertFalse(viewModel.isValidPassword(password: "Abc"))
        XCTAssertFalse(viewModel.isValidPassword(password: "Abcd@"))
        XCTAssertFalse(viewModel.isValidPassword(password: "abcd@17676"))
        XCTAssertFalse(viewModel.isValidPassword(password: ""))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
