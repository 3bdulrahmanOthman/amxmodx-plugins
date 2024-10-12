# Respawn Dead Players Plugin

**Author:** Supremache  
**Version:** 1.0.0  

## Description

The **Respawn Dead Players** plugin automatically respawns players in a game at regular intervals during the round. When a round starts, dead players are respawned after a specified delay, allowing them to rejoin the action quickly.

## Features

- Automatic respawn of dead players every 15 seconds after the round starts.
- HUD message displayed to inform players of their respawn status.

## Installation

Follow these steps to install the plugin:

1. **Download the plugin**: Get the latest version from the repository.
2. **Place the plugin**: Move the plugin file to the `cstrike/addons/amxmodx/plugins` directory.
3. **Configure the plugin**: 
   - Add `respown_players.amxx` to your `cstrike/addons/amxmodx/configs/plugins.ini` (without the quotes).
4. **Compile**: Ensure the plugin is compiled using AMX Mod X.
5. **Restart the server**: Restart your game server to apply the changes.

## Usage

- The plugin activates when the `HLTV` event triggers at the start of a round.
- It sets a task to respawn dead players every 15 seconds.
- Players will receive a HUD message saying, "You Have Been Respawned!" upon respawn.
