//
//  NetmeraAnalyticsAppUITests.swift
//  NetmeraAnalyticsAppUITests
//
//  Created by Elif Yürektürk on 12.04.2025.
//

import XCTest


// Helper extension for scrolling to an element
extension XCUIElement {
    func scrollToElement(in app: XCUIApplication) {
        var maxSwipes = 10
        while !self.isHittable && maxSwipes > 0 {
            app.swipeUp()
            maxSwipes -= 1
        }
    }
}

final class NetmeraAnalyticsAppUITests: XCTestCase {
   

    override func setUpWithError() throws {
      
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
   
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    @MainActor
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    @MainActor
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }

    @MainActor
    func testUserProfileUpdate() throws {
        // Ekran yönünü portrait olarak ayarla
        XCUIDevice.shared.orientation = .portrait

        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Profile screen
        let profileButton = app.buttons["person.circle"]
        XCTAssertTrue(profileButton.exists, "Profile button should exist")
        profileButton.tap()
        
        // Enter external ID
        let userIdTextField = app.textFields["profile_user_id_textfield"]
        XCTAssertTrue(userIdTextField.waitForExistence(timeout: 5), "User ID text field should exist")
        userIdTextField.tap()
        userIdTextField.typeText("test_external_id")

        // Klavyeyi kapat
        if app.keyboards.keys["Return"].exists {
            app.keyboards.keys["Return"].tap()
        } else if app.keyboards.buttons["Done"].exists {
            app.keyboards.buttons["Done"].tap()
        }
        // Hâlâ klavye açıksa, ekrana tap yap
        if app.keyboards.count > 0 {
            let coordinate = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }

        // Tap Update Profile button (scroll if needed)
        let updateButton = app.buttons["profile_update_button"]
        XCTAssertTrue(updateButton.exists, "Update Profile button should exist")

        let scrollView = app.scrollViews.firstMatch
        var maxSwipes = 10
        while !updateButton.isHittable && maxSwipes > 0 {
            scrollView.swipeUp()
            maxSwipes -= 1
        }

        XCTAssertTrue(updateButton.isHittable, "Update Profile button should be hittable after scrolling")
        updateButton.tap()
        
        // Wait for the success alert
        let successAlert = app.alerts["Profile Updated"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 5), "Success alert should appear")
        
        // Verify the alert message
        XCTAssertEqual(successAlert.staticTexts["User information sent to Netmera."].exists, true, "Success message should be correct")
        
        // Dismiss the alert
        successAlert.buttons["OK"].tap()
    }
}
