# LH_SwingTimer

Version: 1.1.0. WoW Forever Beta (Interface 16001).

A minimal main-hand and ranged swing timer beneath Blizzard's player cast bar.

## Features

- A gold bar, two physical screen pixels high, with an eight-pixel vertical marker at its right edge.
- For automatic ranged swings, a second vertical marker appears exactly 0.5 seconds before the end. The gold fill stops at that marker; the remaining section fills orange. If a ranged swing is shorter than 0.5 seconds, the marker starts at the left edge and the whole fill is orange. Main-hand melee swings stay gold throughout.
- Small white text beside the marker shows the remaining time in seconds to one decimal place.
- The bar fills from left to right after a main-hand swing or automatic ranged attack and disappears when the timer ends. The most recently started timer is displayed; off-hand swings are ignored.
- Uses the native beta `PLAYER_SWING` event and the swing duration supplied by the client.
- Follows Blizzard's player cast bar even when Quartz is enabled. The timer remains visible when the cast bar itself is hidden.
- No external libraries are required.

## Native settings

Open WoW Settings > AddOns > LH Tweaks > LH SwingTimer, or type `/lh_swingtimer`. The native page lets you enable or disable the addon and independently track main-hand melee swings and automatic ranged swings. These options are saved per character in `LH_SwingTimerDB`; all default to enabled. Disabling the addon or the currently displayed swing type hides the active bar immediately. `/lh_swingtimer on` and `/lh_swingtimer off` toggle the addon directly.

The AddOn list groups LH SwingTimer under LH Tweaks and uses the same gold icon. The timer stays anchored to Blizzard's player cast bar; it has no independent drag position.

## Installation and upgrade

Place the complete `LH_SwingTimer` folder in your game's `Interface/AddOns` folder, including `LH_SwingTimer.toc`, `LH_SwingTimer.lua`, `Settings.lua` and `Media`. Install and enable LH_Tweaks as well. Fully restart WoW and enable **LH SwingTimer** below **LH Tweaks** in the AddOn list. Version 1.1.0 adds a settings file, saved variable and icon/group metadata, so `/reload` alone is insufficient for this upgrade.

When upgrading from MiniSwingTimer, replace the old folder and fully restart WoW. Do not enable both versions together. The addon uses default settings on first load.

If Quartz also displays its own swing timer, disable its Swing module to avoid duplicate bars.

## Changelog

### 1.1.0 - 2026-10-21

- Added a marker and orange fill for the last 0.5 seconds of ranged swings only, including short swing durations. Main-hand melee keeps its original gold fill.
- Added native LH SwingTimer options under LH Tweaks, shared icon and AddOn grouping.
- Added per-character activation and independent main-hand/ranged tracking controls.
- Added Lua 5.1 regression coverage for both swing types, timing boundaries, cast-bar resizing and settings registration.

### 1.0.2 - 2026-10-21

- Renamed MiniSwingTimer to LH_SwingTimer, including the addon folder, Lua/TOC files, metadata and named bar frame.
- Translated the README into English and added installation and upgrade instructions.

## Required core addon

Install and enable **LH_Tweaks** alongside this addon. LH_Tweaks is the shared LiteHawk configuration host and must load first. CurseForge releases must list LH_Tweaks as a required dependency so the client installs it automatically.
