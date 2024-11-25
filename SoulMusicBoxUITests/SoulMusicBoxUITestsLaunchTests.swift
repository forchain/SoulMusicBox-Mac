//
//  SoulMusicBoxUITestsLaunchTests.swift
//  SoulMusicBoxUITests
//
//  Created by Tony Outlier on 11/24/24.
//

import XCTest

final class SoulMusicBoxUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication(bundleIdentifier: "com.soulapp.cn")
        app.launch()

        let attachment = TestUtilities.takeScreenshot(
            of: app,
            name: "Launch Screen",
            testCase: self
        )
    }

    @MainActor
    func testSoulSaveWindowDescription() throws {
        let app = XCUIApplication(bundleIdentifier: "com.soulapp.cn")
        let appName = "Soul"
        
        // Get timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestamp = dateFormatter.string(from: Date())
        
        // Get the first window's debug description
        let windowDescription = app.windows.firstMatch.debugDescription
        
        // Create file URL in documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("\(appName)_window_description_\(timestamp).txt")
        
        // Write description to file
        try windowDescription.write(to: fileURL, atomically: true, encoding: .utf8)
        
        // Print to console
        print("\(appName) Window Description (\(timestamp)):")
        print("==================")
        print(windowDescription)
        print("==================")
        print("Saved to: \(fileURL.path)")
        
        // Add file as attachment
        let attachment = XCTAttachment(contentsOfFile: fileURL)
        attachment.name = "\(appName) Window Debug Description \(timestamp)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testQQMusicSaveWindowDescription() throws {
        let app = XCUIApplication(bundleIdentifier: "com.tencent.QQMusicMac")
        let appName = "QQMusic"
        
        // Get timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let timestamp = dateFormatter.string(from: Date())
        
        // Get all windows' debug descriptions
        var allWindowsDescription = ""
        let windows = app.windows.allElementsBoundByIndex
        
        for (index, window) in windows.enumerated() {
            allWindowsDescription += "Window \(index + 1):\n"
            allWindowsDescription += "==================\n"
            allWindowsDescription += window.debugDescription
            allWindowsDescription += "\n==================\n\n"
        }
        
        // Create file URL in documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("\(appName)_all_windows_description_\(timestamp).txt")
        
        // 只写入文件
        try allWindowsDescription.write(to: fileURL, atomically: true, encoding: .utf8)
        print("Saved to: \(fileURL.path)")
    }

    @MainActor
    func testQQMusicPlay() throws {
        let app = XCUIApplication(bundleIdentifier: "com.tencent.QQMusicMac")
        QQMusicActions.searchAndPlayFromClipboard(app: app)
    }

    @MainActor
    func testQQMusicQueue() throws {
        let app = XCUIApplication(bundleIdentifier: "com.tencent.QQMusicMac")
        QQMusicActions.addToPlayQueue(app: app)
    }

    @MainActor
    func testQQMusicNext() throws {
        let app = XCUIApplication(bundleIdentifier: "com.tencent.QQMusicMac")
        QQMusicActions.clickNextButton(app: app)
    }

    @MainActor
    func testQQMusicToggle() throws {
        let app = XCUIApplication(bundleIdentifier: "com.tencent.QQMusicMac")
        QQMusicActions.clickPlayPauseButton(app: app)
    }
}
