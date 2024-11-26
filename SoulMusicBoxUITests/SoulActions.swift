import XCTest

class SoulActions {
    static func processNewSoulMessage(app: XCUIApplication, previousMessageCount: Int) ->  Int {
  
        let (currentMessage, currentCount) = findLastSoulerMessage(app: app)
        
        if currentCount > previousMessageCount {
            // Found new message
            if let command = extractAndProcessCommand(currentMessage) {
                executeCommand(command)
            }
            return currentCount
        }
        
        return previousMessageCount
    }
    
    private static func findLastSoulerMessage(app: XCUIApplication) -> (String, Int) {
        if !app.exists {
            app.launch()
            Thread.sleep(forTimeInterval: 5)
        }
        
        let pattern = "souler.+说：:.+"
        let predicate = NSPredicate(format: "label MATCHES %@", pattern)
        let matchingCells = app.cells.matching(predicate)
        let count = matchingCells.count
        if count > 0 {
            return (matchingCells.element(boundBy: count - 1).label, count)
        }
        return ("", 0)
    }
    
    private static func extractAndProcessCommand(_ message: String) -> Command? {
        let parts = message.components(separatedBy: "说：")
        guard parts.count > 1 else { return nil }
        
        let content = parts[1].trimmingCharacters(in: .whitespaces)
        
        if content.hasPrefix(":播放") {
            let songName = content.replacingOccurrences(of: ":播放", with: "").trimmingCharacters(in: .whitespaces)
            return .play(songName)
        } else if content.hasPrefix(":排队") {
            let songName = content.replacingOccurrences(of: ":排队", with: "").trimmingCharacters(in: .whitespaces)
            return .queue(songName)
        } else if content == ":切歌" {
            return .next
        } else if content == ":暂停" || content == ":继续" {
            return .togglePlay
        }
        
        return nil
    }
    
    private static func executeCommand(_ command: Command) {
        let qqMusicApp = XCUIApplication(bundleIdentifier: "com.tencent.QQMusicMac")
        
        switch command {
        case .play(let songName):
            copyToClipboard(songName)
            QQMusicActions.searchAndPlayFromClipboard(app: qqMusicApp)
        case .queue(let songName):
            copyToClipboard(songName)
            QQMusicActions.addToPlayQueue(app: qqMusicApp)
        case .next:
            QQMusicActions.clickNextButton(app: qqMusicApp)
        case .togglePlay:
            QQMusicActions.clickPlayPauseButton(app: qqMusicApp)
        }
    }
    
    private static func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private enum Command {
        case play(String)
        case queue(String)
        case next
        case togglePlay
    }
}
    
