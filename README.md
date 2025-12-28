# 💬 Reworked GTAO-Styled Chat System for QBCore

[![FiveM](https://img.shields.io/badge/FiveM-Ready-green.svg)](https://fivem.net/)
[![QBCore](https://img.shields.io/badge/Framework-QBCore-blue.svg)](https://github.com/qbcore-framework)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen.svg)]()

---

## 🌟 Overview
## Original link: https://github.com/citizenfx/cfx-server-data/tree/master/resources/%5Bgameplay%5D/chat-theme-gtao

A **custom chat rework** for QBCore-based FiveM servers featuring a GTA Online-inspired theme, immersive 3D /me text, roleplay chat games, OOC messaging, and enhanced styling. Built with performance and immersion in mind, this resource overrides the default chat for a more engaging experience.

---

## ✨ Key Features

### 🎭 Chat Interface & Styling
- **GTA Online theme** with custom CSS for modern, gradient-based usernames and message layouts
- **Responsive design** adapting to different aspect ratios (e.g., ultrawide support)
- **Drop shadow effects** via SVG filters for text visibility
- **Customizable positions** and paddings through CSS variables
- **Animated message entry** with slide-in transitions
- **Optional subtle backgrounds** for better readability

### 💬 Messaging Enhancements
- **Character name integration** from QBCore (first + last name)
- **/me command** with 3D text display above player head (visible within 20m range)
- **/ooc command** for out-of-character messages with gold coloring
- **/clear command** to clear personal chat history

### 🎲 Roleplay Chat Games
- **Interactive help menu** via /chatgames command showing all available games
- **/roll [max]**: Roll a number (default 1-100, up to 10000) displayed as 3D /me text
- **/dice**: Roll two six-sided dice with sum calculation
- **/flip**: Coin flip with Heads/Tails result
- **/rps [rock|paper|scissors]**: Play against the server with emojis and outcomes
- **/8ball [question]**: Magic 8-Ball with 20 possible responses
- **Global cooldown** (3 seconds) to prevent spam
- **Emoji integration** for visual flair (🎲, 🪙, ✊, etc.)

### 🛠️ Technical Features
- **NUI-based clearing** for reliable chat history reset
- **Thread-based 3D text rendering** for smooth performance
- **Customizable display time** for /me text (default 15 seconds)
- **ox_lib integration** for modern menus and notifications
- **Client-server synchronization** for events like 3D text display

---

## 📋 Requirements

| Dependency | Version | Required |
|------------|---------|----------|
| QBCore Framework | Latest | ✅ Yes |
| ox_lib | Latest | ✅ Yes |

---

## 🚀 Installation

### 1️⃣ Download & Extract

```bash
# Clone from GitHub
git clone https://github.com/MnCLosSantos/gtao-chat-system.git

# OR download ZIP from Releases
```

Place into your resources folder:
```
[server-data]/resources/[custom]/gtao-chat-system/
```

### 2️⃣ Database Setup

No database tables required! This resource uses in-memory handling and QBCore's existing player data.

### 3️⃣ Add to Server Config

```lua
# server.cfg
ensure ox_lib
ensure gtao-chat-system
```

### 4️⃣ Configure Settings

Edit `cl_chat.lua` and `sv_chat.lua` for customizations:

- **/me Display Time**: Adjust `displayTime = 15000` in `cl_chat.lua` (milliseconds)
- **Visibility Range**: Change `20.0` in distance check for 3D text
- **Text Color**: Modify `SetTextColour(173, 216, 230, 255)` for 3D text
- **Cooldown**: Update `3000` in game commands for spam prevention
- **OOC Template**: Customize the HTML template in `/ooc` command

Edit `style.css` for visual tweaks:

```css
:root {
    --chat-left: 2.27vh;  /* Chat position from left */
    --chat-input-bottom: 50vh;  /* Input field position */
    --radius: 12px;  /* Border radius */
}

.msg > span > span > b {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);  /* Username gradient */
}
```

### 5️⃣ Add Items to QBCore (Optional)

No items required! All features are command-based.

---

## ⚙️ Configuration Guide

### 🎯 Command Configuration

All commands are registered in `sv_chat.lua`:

```lua
-- /me example
RegisterCommand('me', function(source, args, rawCommand)
    local message = table.concat(args, ' ')
    if message == '' then return end
    TriggerClientEvent('chat:displayMe', -1, src, message)
end, false)

-- /roll example
RegisterCommand('roll', function(source, args, rawCommand)
    local maxRoll = tonumber(args[1]) or 100
    local roll = math.random(1, maxRoll)
    local action = "rolled a " .. roll .. " (1-" .. maxRoll .. ") 🎲"
    TriggerClientEvent('chat:displayMe', -1, src, action)
end, false)
```

### 🏭 Styling Configuration

In `style.css`:

```css
.chat-window {
    --size: calc(((2.7vh * 1.2)) * 13);  /* Height calculation */
    left: var(--chat-left);
    bottom: var(--chat-window-bottom);
}

.msg {
    font-size: calc(1.2vh);  /* Message font size */
    animation: slideIn 0.3s ease-out;  /* Entry animation */
}
```

### 💰 Game Help Menu

Configured in `cl_chat.lua` using ox_lib:

```lua
lib.registerContext({
    id = 'rp_games_help',
    title = '🎲 Chat Games Help',
    options = { ... }  // Add or modify game entries here
})
```

---

## 🎬 Available Commands

| Command | Description | Example Usage |
|---------|-------------|---------------|
| `/me [message]` | Display 3D action text above head | `/me waves hello` |
| `/ooc [message]` | Send out-of-character message | `/ooc Need help?` |
| `/clear` | Clear your chat history | `/clear` |
| `/chatgames` | Open games help menu | `/chatgames` |
| `/roll [max]` | Roll a number (1-max) | `/roll 20` |
| `/dice` | Roll two dice | `/dice` |
| `/flip` | Coin flip | `/flip` |
| `/rps [choice]` | Rock Paper Scissors | `/rps rock` |
| `/8ball [question]` | Magic 8-Ball | `/8ball Will I win?` |

---

### Contributing
Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with detailed description

---

## 📞 Support & Community

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-7289da?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/aTBsSZe5C6)

[![GitHub](https://img.shields.io/badge/GitHub-View%20Script-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/MnCLosSantos/mnc-gtao-chat-system)

**Need Help?**
- Open an issue on GitHub
- Join our Discord server

---

## 🔄 Changelog

### Version 1.0.0 (Current Release)
**New Features:**
- ✨ GTA Online-styled chat theme with custom CSS and JS
- ✨ 3D /me text with distance-based visibility
- ✨ Roleplay chat games (/roll, /dice, /flip, /rps, /8ball)
- ✨ /ooc messaging with custom formatting
- ✨ /clear command for personal chat reset
- ✨ Interactive games help menu via ox_lib
- ✨ QBCore integration for character names
- ✨ Responsive design and animations

**Improvements:**
- 🔧 Optimized 3D text rendering in client threads
- 🔧 Enhanced message templates for better visuals
- 🔧 Added global cooldown for game commands

**Bug Fixes:**
- 🐛 Fixed chat clearing not working via NUI
- 🐛 Resolved 3D text not showing for invalid peds
- 🐛 Corrected game cooldown not applying properly

---

**Enjoy enhanced chat features on your FiveM server! 💬**
