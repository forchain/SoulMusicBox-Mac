# SoulMusicBox-Mac

A macOS application that acts as a music bot for Soul chat rooms, automatically controlling QQ Music based on chat commands.

## Features

- 🤖 Monitors Soul chat room messages for music commands
- 🎵 Automatically controls QQ Music player
- 🎧 Supports common music commands:
  - `:播放 [歌名]` - Play a song
  - `:排队 [歌名]` - Add song to queue
  - `:切歌` - Skip to next song
  - `:暂停/:继续` - Toggle play/pause
- 🔄 Handles both singer-specific and general song searches
- ⚡️ Quick response to chat commands

## Requirements

- macOS 13.0+
- Xcode 15.0+
- Swift 5.9+
- QQ Music for Mac
- Soul App (running in simulator or device)

## Setup

1. Clone the repository
```bash
git clone https://github.com/soul-music/SoulMusicBox-Mac.git
```
2. Open `SoulMusicBox.xcodeproj` in Xcode
3. Configure UI coordinates in `ui_config.json` if needed
4. Build and run the UI tests

## How It Works

1. The application monitors Soul chat messages using UI testing
2. When a music command is detected (e.g., `:播放 周杰伦-稻香`), it:
   - Extracts the command and song information
   - Controls QQ Music through simulated UI interactions
   - Performs actions like searching, playing, or queueing songs

## Configuration

UI coordinates for QQ Music controls are configured in `ui_config.json`. This includes:
- Button locations (play/pause, next)
- Search box position
- Search result coordinates
- Click offsets for different actions

## Development Status

🚧 This project is currently under active development.

## Contributing

We welcome contributions! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Project Link: [https://github.com/soul-music/SoulMusicBox-Mac](https://github.com/soul-music/SoulMusicBox-Mac)
