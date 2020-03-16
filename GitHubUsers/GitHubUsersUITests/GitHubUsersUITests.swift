//
//  GitHubUsersUITests.swift
//  GitHubUsersUITests
//
//  Created by Igor Vaz on 13/03/20.
//  Copyright © 2020 Igor Vaz. All rights reserved.
//

import XCTest

class GitHubUsersUITests: XCTestCase {

    let app = XCUIApplication()

    func expectTextToAppear(text: String) {
        let cell = app.tables.staticTexts[text]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: cell, handler: nil)
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSelectAUserAndGoBack() {
        // UI tests must launch the application that they test.
        app.launch()
        app.tables.staticTexts["defunkt"].tap()
        app.navigationBars["GitHub"].buttons["GitHub"].tap()
    }

    func testSearchForAUser() {
        app.launch()
        app.navigationBars["GitHub"].searchFields["Busque usuários do GitHub"].tap()

        expectTextToAppear(text: "beatriz")
        app.navigationBars["GitHub"].searchFields["Busque usuários do GitHub"].typeText("beatriz")
        waitForExpectations(timeout: 10, handler: nil)
        app.otherElements["PopoverDismissRegion"].tap()
        app.tables.staticTexts["beatriz"].tap()
    }

    func testLoadUsersNextPage() {
        app.launch()
        expectTextToAppear(text: "wycats")
        waitForExpectations(timeout: 10, handler: nil)
        let tableView = app.descendants(matching: .table).firstMatch
        tableView.swipeUp()
        expectTextToAppear(text: "takeo")
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testLoadRepositoriesNextPageNextPage() {
        app.launch()
        app.tables.staticTexts["defunkt"].tap()
        expectTextToAppear(text: "ace")
        waitForExpectations(timeout: 10, handler: nil)
        app.tables.staticTexts["ace"].swipeUp()
        expectTextToAppear(text: "dotenv")
        waitForExpectations(timeout: 10, handler: nil)

    }
}
