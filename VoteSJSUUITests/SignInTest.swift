//
//  VoteSJSUUITests.swift
//  VoteSJSUUITests
//
//  Created by Personal on 4/24/18.
//  Copyright © 2018 San Jose State University. All rights reserved.
//

import XCTest

class SignInTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSignIn() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["GIDSignInButton"]/*[[".buttons[\"Sign in\"]",".buttons[\"GIDSignInButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().tabBars.buttons["Account"].tap()
        
        let app = XCUIApplication()
        XCTAssert(app.staticTexts["derek.lopes@sjsu.edu"].exists)
    }
    
}
