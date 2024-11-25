import XCTest
import ApplicationServices

/// Utility class for UI testing
class QQMusicActions {
    private static let config = UIConfig.load().qqMusic
    
    static func clickNextButton(app: XCUIApplication) {
        let window = app.windows.firstMatch
        let coordinate = window.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                              .withOffset(CGVector(dx: config.nextButton.x, dy: config.nextButton.y))
        coordinate.click()
        
        Thread.sleep(forTimeInterval: 0.5)
    }

    static func clickPlayPauseButton(app: XCUIApplication) {
        let window = app.windows.firstMatch
        let coordinate = window.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
                              .withOffset(CGVector(dx: config.playPauseButton.x, dy: config.playPauseButton.y))
        coordinate.click()
        
        Thread.sleep(forTimeInterval: 0.5)
    }

    static func openSearch(app: XCUIApplication)  {
        let window = app.windows.firstMatch
        
        TestUtilities.clickAt(window: window, x: config.searchBox.x, y: config.searchBox.y)
        TestUtilities.sendKeyboardShortcut(to: app, key: "a", modifiers: .command)
        TestUtilities.sendKeyboardShortcut(to: app, key: "v", modifiers: .command)
        TestUtilities.sendKeyboardShortcut(to: app, key: XCUIKeyboardKey.return.rawValue)
        
        Thread.sleep(forTimeInterval: 0.5)
    }

    static func addToPlayQueue(app: XCUIApplication) {
        let window = app.windows.firstMatch
        openSearch(app: app)

        // With singer
        TestUtilities.clickAt(window: window, x: config.searchResultWithSinger.x, y: config.searchResultWithSinger.y)
        TestUtilities.clickAt(window: window, 
                            x: config.searchResultWithSinger.x + config.queueOffset.x, 
                            y: config.searchResultWithSinger.y + config.queueOffset.y)

        // Without singer
        TestUtilities.clickAt(window: window, x: config.searchResultWithoutSinger.x, y: config.searchResultWithoutSinger.y)
        TestUtilities.clickAt(window: window, 
                            x: config.searchResultWithoutSinger.x + config.queueOffset.x, 
                            y: config.searchResultWithoutSinger.y + config.queueOffset.y)
    }

    static func searchAndPlayFromClipboard(app: XCUIApplication) {
        let window = app.windows.firstMatch
        openSearch(app: app)
        
        // With singer
        TestUtilities.clickAt(window: window, x: config.searchResultWithSinger.x, y: config.searchResultWithSinger.y)
        TestUtilities.clickAt(window: window, 
                            x: config.searchResultWithSinger.x + config.playOffset.x, 
                            y: config.searchResultWithSinger.y + config.playOffset.y)

        // Without singer
        TestUtilities.clickAt(window: window, x: config.searchResultWithoutSinger.x, y: config.searchResultWithoutSinger.y)
        TestUtilities.clickAt(window: window, 
                            x: config.searchResultWithoutSinger.x + config.playOffset.x, 
                            y: config.searchResultWithoutSinger.y + config.playOffset.y)
    }
}
