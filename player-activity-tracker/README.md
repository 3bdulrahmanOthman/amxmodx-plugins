# Player Activity Tracker Plugin for AMX Mod X

## Version
- **Current Version**: 1.1.2

## Description
The Time Played plugin tracks the time each player spends in the game. It can save and retrieve player data using various methods, including NVault, MySQL, and SQLite. This allows server administrators to keep track of player engagement and activity efficiently.

## Features
- Tracks total time played by each player.
- Supports multiple saving methods: NVault, MySQL, and SQLite.
- Commands for players to check their total playtime and view a leaderboard.
- Automatically updates player information on connection and disconnection.

## Installation
1. Download the plugin file.
2. Place the plugin in the `plugins` folder of your AMX Mod X installation.
3. Add the plugin name to your `plugins.ini` file.
4. Configure the database settings in the source code if using MySQL or SQLite.
5. Compile the plugin using AMX Mod X compiler.

## Configuration
### CVar Configuration
- `tp_save_method` (default: `0`)
  - **0**: NVault
  - **1**: MySQL
  - **2**: SQLite

- `tp_save_type` (default: `0`)
  - **0**: Save using Nickname
  - **1**: Save using IP
  - **2**: Save using SteamID

### Database Configuration (for MySQL/SQLite)
- **SQL Host**: `localhost`
- **SQL User**: `root`
- **SQL Password**: `password`
- **SQL Database**: `database`
- **SQL Table**: `player-activity-tracker`

## Commands
- `/time` or `/ptime`: Displays total playing time.
- `/timelist` or `/ptimelist`: Shows a leaderboard of player times.

## API
### Player Data Structure
```cpp
enum PlayerData
{ 
	SaveInfo[MAX_AUTHID_LENGTH],
	Time_Played,
	First_Seen,
	Last_Seen,
	bool:BotOrHLTV
}
