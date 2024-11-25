import XCTest

/// Utility class for UI testing
class TestUtilities {
    
    /// Generate timestamp string in format "yyyyMMdd_HHmmss"
    static func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        return dateFormatter.string(from: Date())
    }
    
    /// Create and add a screenshot attachment
    /// - Parameters:
    ///   - app: XCUIApplication to take screenshot from
    ///   - name: Name for the screenshot
    ///   - testCase: Test case to add attachment to
    /// - Returns: Created XCTAttachment
    static func takeScreenshot(
        of app: XCUIApplication,
        name: String,
        testCase: XCTestCase
    ) -> XCTAttachment {
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        testCase.add(screenshot)
        return screenshot
    }
    
    /// Create and save a log file attachment
    /// - Parameters:
    ///   - content: Log content to save
    ///   - name: Name for the log file
    ///   - testCase: Test case to add attachment to
    static func saveLog(
        content: String,
        name: String,
        testCase: XCTestCase
    ) {
        let attachment = XCTAttachment(string: content)
        attachment.name = name
        attachment.lifetime = .keepAlways
        testCase.add(attachment)
        print(content)
    }
    
    /// Click at specific coordinates relative to window
    /// - Parameters:
    ///   - window: Window to click in
    ///   - x: X coordinate relative to window
    ///   - y: Y coordinate relative to window
    static func clickAt(
        window: XCUIElement,
        x: CGFloat,
        y: CGFloat
    ) {
        let coordinate = window.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            .withOffset(CGVector(dx: x, dy: y))
        coordinate.click()
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    /// Right click at specific coordinates relative to window
    /// - Parameters:
    ///   - window: Window to click in
    ///   - x: X coordinate relative to window
    ///   - y: Y coordinate relative to window
    static func rightClickAt(
        window: XCUIElement,
        x: CGFloat,
        y: CGFloat
    ) {
        let coordinate = window.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            .withOffset(CGVector(dx: x, dy: y))
        coordinate.rightClick()
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    /// Save window description to file and create attachment
    /// - Parameters:
    ///   - app: XCUIApplication instance
    ///   - appName: Name of the application
    ///   - testCase: Test case to add attachment to
    /// - Returns: File URL where description was saved
    static func saveWindowDescription(
        for app: XCUIApplication,
        appName: String,
        testCase: XCTestCase
    ) throws -> URL {
        let timestamp = getTimestamp()
        let windowDescription = app.windows.firstMatch.debugDescription
        
        // Create file URL in documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("\(appName)_window_description_\(timestamp).txt")
        
        // Write description to file
        try windowDescription.write(to: fileURL, atomically: true, encoding: .utf8)
        
        // Create and add attachment
        let attachment = XCTAttachment(contentsOfFile: fileURL)
        attachment.name = "\(appName) Window Debug Description \(timestamp)"
        attachment.lifetime = .keepAlways
        testCase.add(attachment)
        
        return fileURL
    }
    
    /// Send keyboard shortcuts
    /// - Parameters:
    ///   - app: XCUIApplication instance
    ///   - key: Key to press
    ///   - modifiers: Modifier flags (e.g. .command)
    ///   - delay: Delay after keypress in seconds
    static func sendKeyboardShortcut(
        to app: XCUIApplication,
        key: String,
        modifiers: XCUIElement.KeyModifierFlags = []
    ) {
        app.typeKey(key, modifierFlags: modifiers)
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    /// Get all textfields information
    /// - Parameters:
    ///   - app: XCUIApplication instance
    ///   - appName: Name of the application
    /// - Returns: Description of all textfields
    static func getAllTextFieldsDescription(
        for app: XCUIApplication,
        appName: String
    ) -> String {
        let textFields = app.textFields.allElementsBoundByIndex
        var description = "Total TextFields Count: \(textFields.count)\n\n"
        
        for (index, textField) in textFields.enumerated() {
            description += """
                TextField \(index + 1):
                ==================
                Label: \(textField.label)
                Value: \(textField.value ?? "nil")
                Placeholder: \(textField.placeholderValue ?? "nil")
                Enabled: \(textField.isEnabled)
                Debug Description:
                \(textField.debugDescription)
                ==================\n\n
                """
        }
        
        return description
    }
} 