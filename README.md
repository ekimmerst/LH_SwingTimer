# LH_SwingTimer

Version: 1.0.2. WoW Forever Beta (Interface 16001).

A minimal main-hand and ranged swing timer beneath Blizzard's player cast bar.

## Features

- A gold bar, two physical screen pixels high, with an eight-pixel vertical marker at its right edge.
- Small white text beside the marker shows the remaining time in seconds to one decimal place.
- The bar fills from left to right after a main-hand swing or automatic ranged attack and disappears when the timer ends. The most recently started timer is displayed; off-hand swings are ignored.
- Uses the native beta `PLAYER_SWING` event and the swing duration supplied by the client.
- Follows Blizzard's player cast bar even when Quartz is enabled. The timer remains visible when the cast bar itself is hidden.
- No libraries, configuration, slash commands or saved variables are required.

## Installation and upgrade

Place the `LH_SwingTimer` folder in your game's `Interface/AddOns` folder. It must contain `LH_SwingTimer.toc` and `LH_SwingTimer.lua`. Restart WoW and enable **LH_SwingTimer** in the addon list.

When upgrading from MiniSwingTimer, replace the old folder and fully restart WoW. Do not enable both versions together. There are no saved settings to migrate.

If Quartz also displays its own swing timer, disable its Swing module to avoid duplicate bars.

## Changelog

### 1.0.2 - 2026-10-21

- Renamed MiniSwingTimer to LH_SwingTimer, including the addon folder, Lua/TOC files, metadata and named bar frame.
- Translated the README into English and added installation and upgrade instructions.

## Required core addon

Install and enable **LH_Tweaks** alongside this addon. LH_Tweaks is the shared LiteHawk configuration host and must load first. CurseForge releases must list LH_Tweaks as a required dependency so the client installs it automatically.
