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
        continueAfterFailure = false
    }

    override func tearDown() {

    }

    func testSelectAUserAndGoBack() {
        app.launch()
        app.tables.staticTexts["defunkt"].tap()
        app.navigationBars["GitHub"].buttons["GitHub"].tap()
    }

    func testSearchForAUser() {
        app.launch()
        app.navigationBars["GitHub"].searchFields["Busque usuários do GitHub"].tap()

        expectTextToAppear(text: "igorbvaz")
        app.navigationBars["GitHub"].searchFields["Busque usuários do GitHub"].typeText("igor vaz")
        waitForExpectations(timeout: 20, handler: nil)
        app.otherElements["PopoverDismissRegion"].tap()
        app.tables.staticTexts["igorbvaz"].tap()
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
        let tableView = app.descendants(matching: .table).firstMatch
        tableView.swipeUp()
        expectTextToAppear(text: "dotenv")
        waitForExpectations(timeout: 10, handler: nil)

    }
}
