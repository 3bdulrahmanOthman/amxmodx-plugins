# SteamID Health Plugin

## Description

The **SteamID Health** plugin allows you to set custom health values for players based on their Steam ID. When a player spawns in the game, their health is automatically set to the value specified in a configuration file.

## Features

- Custom health settings for each player based on their Steam ID.
- Easy to configure using an external `.ini` file.
- Supports up to 32 players.
- Automatically loads player health values upon server startup or plugin reload.

## Installation

1. **Download the plugin files**.
2. Place the compiled plugin file (`steamid-hp.amxx`) into the `cstrike/addons/amxmodx/plugins` folder.
3. Add the configuration file `SteamHp.ini` to the `cstrike/addons/amxmodx/data` folder.
4. Open the `plugins.ini` file located in `cstrike/addons/amxmodx/configs` and add the following line: 
```plaintext
	steamid-hp.amxx
5. Restart your server to apply the changes.

## Configuration

The plugin uses a configuration file named `SteamHp.ini` to set player health values. The format for each line in the file is:
```plaintext
<SteamID> <Health>

### Example
```plaintext
"STEAM_0:1:xxxx123456" "100"

- In the above example, the player with Steam ID `STEAM_0:1:123456` will have 100 health, while the player with Steam ID `STEAM_0:1:654321` will have 150 health.

## Usage

- Players' health will be set automatically upon spawning based on the values defined in `SteamHp.ini`.
- If a player's Steam ID is not found in the configuration file, they will spawn with default health (typically 100).

## Commands

No specific commands are needed for this plugin, as it functions automatically based on the configuration file.

## Notes

- Ensure that the `SteamHp.ini` file is properly formatted and located in the specified directory.
- If the file does not exist or cannot be read, the plugin will log an error message to the server console.

