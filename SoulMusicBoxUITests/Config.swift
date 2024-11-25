import Foundation

struct UIConfig: Codable {
    struct Coordinates: Codable {
        let x: CGFloat
        let y: CGFloat
    }
    
    struct QQMusicConfig: Codable {
        let nextButton: Coordinates
        let playPauseButton: Coordinates
        let searchBox: Coordinates
        let searchResultWithSinger: Coordinates
        let searchResultWithoutSinger: Coordinates
        let playOffset: Coordinates
        let queueOffset: Coordinates
    }
    
    let qqMusic: QQMusicConfig
    
    static func load() -> UIConfig {
        guard let url = Bundle(for: TestUtilities.self).url(forResource: "ui_config", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(UIConfig.self, from: data) else {
            fatalError("Failed to load ui_config.json")
        }
        return config
    }
} 