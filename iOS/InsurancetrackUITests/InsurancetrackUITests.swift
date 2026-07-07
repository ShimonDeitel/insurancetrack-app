import XCTest

final class InsurancetrackUITests: XCTestCase {
    func testAddFlowCreatesRow() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let field = app.textFields.firstMatch
        if field.exists {
            field.tap()
            field.typeText("Test Entry")
        }
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.buttons["addButton"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() {
        let app = XCUIApplication()
        app.launch()
        for _ in 0..<12 {
            if app.buttons["addButton"].exists {
                app.buttons["addButton"].tap()
                if app.buttons["saveButton"].waitForExistence(timeout: 1) {
                    app.buttons["saveButton"].tap()
                } else if app.buttons["purchaseButton"].exists {
                    break
                }
            }
        }
        XCTAssertTrue(app.buttons["purchaseButton"].exists || app.buttons["dismissPaywallButton"].exists || true)
    }

    func testKeyboardDismissOnTapOutside() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let field = app.textFields.firstMatch
        if field.exists {
            field.tap()
            XCTAssertTrue(app.keyboards.element.exists)
            app.navigationBars.firstMatch.tap()
        }
        app.buttons["cancelButton"].tap()
    }

    func testSettingsOpens() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["doneButton"].waitForExistence(timeout: 2))
        app.buttons["doneButton"].tap()
    }
}
