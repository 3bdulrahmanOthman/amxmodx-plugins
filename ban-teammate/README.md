# AMX Ban Team Plugin

### Version: 1.0  


## Description
The AMX Ban Team plugin allows server admins to ban or unban all players on a specific team (either Counter-Terrorists or Terrorists) with a single command. The plugin works for AMX Mod X and is designed to streamline banning teammates based on their in-game team.

## Features
- Ban all players on a team (either CT or Terrorist) with a single command.
- Unban all players from a previously banned team.
- Automatically stores banned players in a configuration file for easy reference.

## Commands
- **`amx_banct [minutes]`**: Bans all Counter-Terrorists for the specified duration.
- **`amx_bant [minutes]`**: Bans all Terrorists for the specified duration.
- **`amx_unbanct`**: Unbans all previously banned Counter-Terrorists.
- **`amx_unbant`**: Unbans all previously banned Terrorists.

## Installation Instructions
1. Download the plugin file and compile it.
2. Place the compiled `.amxx` file into the `cstrike/addons/amxmodx/plugins` folder.
3. Open `cstrike/addons/amxmodx/configs/plugins.ini` and add the following line:
   ```plaintext
   ban-teammate.amxx
4. Restart your server or change the map for the plugin to load.


## Configuration
- A configuration file will be created in the `cstrike/addons/amxmodx/configs` directory named `BanList_CT.ini` for Counter-Terrorists and `BanList_TERRORIST.ini` for Terrorists.
- The ban duration for each player is determined by the value passed in the command (in minutes).

## Cvars
- **`Ban-Teammate`**: Plugin version (default: `1.0`).

## Usage
- To ban all players on the Counter-Terrorist team for 5 minutes, type the following command in the console:
  ```plaintext
  amx_banct 5
- To unban all previously banned Counter-Terrorists, type:
  ```plaintext
  amx_unbanct

