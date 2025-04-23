

https://github.com/user-attachments/assets/b1166ccb-bfe6-46a1-83e2-2cb812060f37



This project was undertaken to:
1. Get an easy introduction to SwiftData and SwiftUI navigation
2. Learn about UIKit, and how it interfaces with SwiftUI
3. Fulfill a friend's request of a 2048 game that can show one's worst score on the main page

This app is essentially a wrapper around Austin Zheng's [swift-2048](https://github.com/austinzheng/swift-2048). It is extended with statistics, an updated UI, and the beginnings of persisted game state. 

The app was rejected for a public beta on TestFlight for spam (too similar to existing apps), which is unfortunate but understandable. After this, I decided to not bother finishing what I had planned.

Improvements to make:
- Finish persisting game state (functions for saving and loading state are done, just need to apply them on open/close)
- Undo move (would likely follow easily from saving game state each move)
- More stats (game time, number of games played, moves per game, etc.)
- Complete scoreboard customization (anywhere from 0 to 4 stats on main page)
