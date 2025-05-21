//
//  homebankUITests.swift
//  homebankUITests
//
//  Created by Dean Trl on 18/5/25.
//

import XCTest

final class homebankUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func test_openDashboard() throws {
        let collection = app.collectionViews.firstMatch
        XCTAssertTrue(collection.exists)
        
        // Wait for cells to load
        let cell = collection.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testPullToRefreshChangesCellCount() throws {
        let cv = app.collectionViews.firstMatch
        XCTAssertTrue(cv.waitForExistence(timeout: 4), "Collection view must be on screen")

        // 1) record initial count
        let initialCount = cv.cells.count

        // 2) pull to refresh
        let start = cv.coordinate(
            withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2)
        )
        let end = cv.coordinate(
            withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6)
        )
        start.press(forDuration: 0.1, thenDragTo: end)

        // 3) wait for the count to change
        let predicate = NSPredicate(format: "cells.count != %d", initialCount)
        expectation(for: predicate, evaluatedWith: cv, handler: nil)
        waitForExpectations(timeout: 8)

        // 4) final assertion
        let finalCount = cv.cells.count
        XCTAssertNotEqual(finalCount, initialCount, "Pull-to-refresh should change the number of cells")
    }
}
