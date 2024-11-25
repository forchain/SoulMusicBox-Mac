import XCTest

/// Utility class for UI testing
class QQMusicActions {
    static func clickNextButton(app: XCUIApplication) {
        let window = app.windows.firstMatch
        let coordinate = window.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                              .withOffset(CGVector(dx: 585, dy: 675))
        coordinate.click()
        
        // Small delay after click to ensure action completes
        Thread.sleep(forTimeInterval: 0.5)
    }

    static func clickPlayPauseButton(app: XCUIApplication) {
        let window = app.windows.firstMatch
        let coordinate = window.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                              .withOffset(CGVector(dx: 520, dy: 675))
        coordinate.click()
        
        // Small delay after click to ensure action completes
        Thread.sleep(forTimeInterval: 0.5)
    }

    static func addToPlayQueue(app: XCUIApplication) {
        let window = app.windows.firstMatch
        
        // Search sequence
        TestUtilities.clickAt(window: window, x: 400, y: 40)
        TestUtilities.sendKeyboardShortcut(to: app, key: "a", modifiers: .command)
        TestUtilities.sendKeyboardShortcut(to: app, key: "v", modifiers: .command)
        TestUtilities.sendKeyboardShortcut(to: app, key: XCUIKeyboardKey.return.rawValue)
        
        // Queue operation
        TestUtilities.rightClickAt(window: window, x: 280, y: 400)
        TestUtilities.clickAt(window: window, x: 290, y: 445)
    }

    static func searchAndPlayFromClipboard(app: XCUIApplication) {
        let window = app.windows.firstMatch
        
        // Search and paste
        TestUtilities.clickAt(window: window, x: 400, y: 40)
        TestUtilities.sendKeyboardShortcut(to: app, key: "a", modifiers: .command)
        TestUtilities.sendKeyboardShortcut(to: app, key: "v", modifiers: .command)
        TestUtilities.sendKeyboardShortcut(to: app, key: XCUIKeyboardKey.return.rawValue)
        
        // Click on search result
        let newCoordinate = window.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                                .withOffset(CGVector(dx: 280, dy: 400))
        newCoordinate.rightClick()
        Thread.sleep(forTimeInterval: 0.5)
        
        // Click play option
        let playCoordinate = newCoordinate.withOffset(CGVector(dx: 10, dy: 10))
        playCoordinate.click()
        Thread.sleep(forTimeInterval: 0.5)
    }
}
