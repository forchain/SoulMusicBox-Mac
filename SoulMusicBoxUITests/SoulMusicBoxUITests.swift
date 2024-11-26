//
//  SoulMusicBoxUITests.swift
//  SoulMusicBoxUITests
//
//  Created by Tony Outlier on 11/24/24.
//

import XCTest

final class SoulMusicBoxUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testMain() throws {
        let app = XCUIApplication(bundleIdentifier: "com.soulapp.cn")
        var lastMessage: String? = nil
        
        // Continuous monitoring
        while true {
            lastMessage = SoulActions.processNewSoulMessage(app: app, previousMessage: lastMessage)
            Thread.sleep(forTimeInterval: 9)
        }
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        TestUtilities.takeScreenshot(
            of: app,
            name: "Example Test Screenshot",
            testCase: self
        )
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
