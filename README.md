# 💬 mnc-gtao-chat-system — GTAO‑Styled Chat for QBCore

[![FiveM](https://img.shields.io/badge/FiveM-Ready-green.svg)](https://fivem.net/)  
[![QBCore](https://img.shields.io/badge/Framework-QBCore-blue.svg)](https://github.com/qbcore-framework)  
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen.svg)]()
![mncchatsystem](https://github.com/user-attachments/assets/9773d022-567d-41b6-9297-a3ffa7f56519)

A GTA Online-themed chat UI and chat-command resource for QBCore-based FiveM servers. This resource includes a styled NUI chat, 3D /me text, a set of roleplay chat games, a /clear to clear chat flow, and aggressive blocking logic to prevent other resources from injecting messages into the chat UI (see WARNING).

This README documents the current codebase (files: fxmanifest.lua, cl_chat.lua, sv_chat.lua, shadow.js, style.css).

---
<img width="1920" height="1080" alt="Screenshot (32)" src="https://github.com/user-attachments/assets/3876eb0a-f5e9-4ab2-b0c6-cb89e5297a69" />
<img width="1920" height="1080" alt="Screenshot (39)" src="https://github.com/user-attachments/assets/131607dc-6459-43fe-b899-0dfb48d5d7fb" />
<img width="1920" height="1080" alt="Screenshot (37)" src="https://github.com/user-attachments/assets/4e87581a-0771-46d6-a999-7c7abd3af286" />

<img width="1920" height="1080" alt="Screenshot (33)" src="https://github.com/user-attachments/assets/72f31b08-02b7-4a6e-91bb-f2974e620a60" />
<img width="1920" height="1080" alt="Screenshot (34)" src="https://github.com/user-attachments/assets/a3e4561f-3229-4eea-975b-829bd24f9f8b" />
<img width="1920" height="1080" alt="Screenshot (35)" src="https://github.com/user-attachments/assets/96e9cb5c-bcce-472f-bafb-2f8fac00d71f" />
<img width="1920" height="1080" alt="Screenshot (36)" src="https://github.com/user-attachments/assets/3c8da526-e8ad-4b54-a9c4-f400b621a952" />
<img width="1920" height="1080" alt="Screenshot (38)" src="https://github.com/user-attachments/assets/42557402-2409-4d34-99ed-aacc237fe733" />


## Highlights / Features

- GTA Online-inspired visual theme (CSS + SVG drop shadows)
- NUI-based chat UI (style.css + shadow.js)
- 3D /me text shown above player heads (client-side, distance-limited)
- Roleplay mini-games: /roll, /dice, /flip, /rps, /8ball
- /chatgames opens an ox_lib context menu help screen (if using ox_lib)
- /clear command clears your local chat via NUI
- NUI message marking and multiple layers of aggressive external message blocking:
  - client-side AddEventHandler blocks in cl_chat.lua,
  - server-side AddEventHandler blocks in sv_chat.lua,
  - window postMessage / message listener interception in shadow.js
- Uses QBCore for player & character name resolution

---

## Requirements

- FiveM / Cfx.re server
- QBCore framework (tested against modern QBCore exports)
- ox_lib (recommended for menu/notifications integration — used by `chat:openGamesHelp` and lib.notify). If you do not use ox_lib, remove or adapt those parts.

---

## Installation

1. Clone (or download) this repository into your server resources folder:

```bash
git clone https://github.com/MnCLosSantos/mnc-gtao-chat-system.git
# Place into:
# [server-data]/resources/[custom]/mnc-gtao-chat-system/
```

2. Add to your server config (ensure dependencies first):

```ini
# server.cfg
ensure ox_lib        # recommended (if you use ox_lib features)
ensure mnc-gtao-chat-system
```

3. Restart/refresh your server or resource.

---

## Quick Configuration

Open the listed files to tweak behaviour:

- cl_chat.lua
  - /me display time: change `local displayTime = 15000` (milliseconds)
  - 3D text visibility range: change the `20.0` distance check inside the display thread
  - 3D text color: `SetTextColour(173, 216, 230, 255)`
- sv_chat.lua
  - Game/global cooldown: update the 3000 ms checks (variable `GameCooldowns[src]` and comparisons)
  - Roll limits: default/min/max set in `roll` command (default 100, capped at 10000)
- style.css
  - Visual variables at the top (`:root`) — chat position, paddings, radii, fonts, etc.

Examples (server-side ensure & simple changes):
- To increase /me display time to 20s: set `displayTime = 20000` in cl_chat.lua
- To increase /me visibility distance to 30m: change `if #(GetEntityCoords(playerPed) - senderPos) < 20.0 then` to `< 30.0`

---

## Commands

Server-registered commands (implemented in sv_chat.lua):

- /me [message] — display 3D action text above your head, broadcast as a /me action
  - Example: `/me waves hello`
- /clear — clears your local NUI chat via `chat:clear`
- /chatgames — opens an ox_lib-based help menu (requires ox_lib)
- /roll [max] — roll a number (default 1–100, accepted max up to 10000). Example: `/roll 20`
- /dice — roll two six-sided dice. Example: `/dice`
- /flip — coin flip (Heads/Tails). Example: `/flip`
- /rps [rock|paper|scissors] — rock-paper-scissors vs server. Example: `/rps rock`
- /8ball [question] — magic 8-ball responses. Example: `/8ball Will I win?`

Notes:
- All mini-games apply a global per-player cooldown of 3 seconds by default (server-side).
- Message broadcast for games uses `TriggerClientEvent('chat:displayMe', -1, src, action)` to show as /me-style 3D text.

---

## Aggressive External Message Blocking — IMPORTANT WARNING

This resource includes logic that attempts to block any chat messages coming from other resources. The blocking is implemented in multiple places:

- cl_chat.lua: overrides SendNUIMessage to mark own messages and registers AddEventHandler for `chat:addMessage`, `chatMessage`, `__cfx_internal:chatMessage`, and `onChatMessage` to CancelEvent() when invoker != this resource.
- sv_chat.lua: registers AddEventHandler for server-side `chat:addMessage` and `__cfx_internal:serverPrint` to CancelEvent() when invoker != this resource.
- shadow.js: intercepts window/document `message` events and overrides `postMessage` to ignore any ON_MESSAGE that does not include `__fromOurResource`.

Why this matters:
- This will block other resources that rely on FiveM's chat events to display messages in the same NUI. If you run third-party scripts that broadcast chat via `TriggerClientEvent('chat:addMessage', ...)` or rely on the default chat handler, their messages will be suppressed.
- If you want compatibility with other resources, remove or comment out the blocking sections in cl_chat.lua, sv_chat.lua and the message-intercept portion of shadow.js. Search for the "AGGRESSIVE EXTERNAL MESSAGE BLOCKING" headers to find the relevant sections.

Recommended approach:
- If you intend to use this resource as *the* chat UI for your server and want to prevent duplicates/injection, keep the blocking logic.
- If you want cooperative behavior, remove or modify the blocking to only filter known duplicate sources instead of cancelling all external messages.

---

## NUI & Styling Details

- style.css contains chat layout, fonts, responsive aspect-ratio handling, word wrapping fixes and SVG drop-shadow filter usage.
- shadow.js includes the SVG drop-shadow setup and the JavaScript-level message interception described above.
- fxmanifest.lua registers the chat theme (style.css and shadow.js) and marks the `chat_theme 'gtao'` msg template. It also references `@ox_lib/init.lua` as a shared script for ox_lib integration.

---

## Troubleshooting & Tips

- If 3D text isn't appearing:
  - Ensure client can receive the `chat:displayMe` event.
  - Check that `GetPlayerFromServerId(senderServerId)` returns a valid player ped (not -1 or 0).
  - Verify displayTime and distance values in cl_chat.lua.
- If other resources' chat messages are missing, review the "Aggressive External Message Blocking" section above and disable blocking if needed.
- If `lib` (ox_lib) functions cause errors, either install ox_lib or remove the `lib.registerContext` / `lib.notify` calls in cl_chat.lua.

---

## Contributing

Contributions welcome! Suggestions:
1. Fork the repository
2. Create a feature branch
3. Open a pull request with a detailed description of changes

Please update the README for any functionality or config additions you include.

---

## Changelog

### v1.0.0
- Initial release:
  - GTAO-styled chat UI + styling (style.css)
  - NUI message interception & aggressive blocking (shadow.js, cl_chat.lua, sv_chat.lua)
  - 3D /me text rendering (cl_chat.lua)
  - Chat games: /roll, /dice, /flip, /rps, /8ball (sv_chat.lua)
  - /clear and /chatgames (ox_lib context) support

---

## Support

- Open an issue on GitHub: [mnc-gtao-chat-system issues](https://github.com/MnCLosSantos/mnc-gtao-chat-system/issues)
- Join the project's Discord (if available) for faster help.

---

Enjoy the GTAO-flavored chat on your FiveM server — and be careful with blocking behavior if you run other chat-dependent resources!
