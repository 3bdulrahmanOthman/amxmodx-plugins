# Advanced Hat System for AMX Mod X

## Description
The **Hat menu** plugin for AMX Mod X allows players to equip and display hats in a game, with level-based restrictions for each hat. The system supports a configuration file (`hats.ini`) that defines the available hats, their models, names, and the levels required to use them.

Players can interact with the system using a menu that allows them to select their desired hat, and they can also remove their currently equipped hat.

## Features
- **Hat Selection Menu**: Players can select from a list of hats with a simple command (`/hats`).
- **Level Restrictions**: Hats have level requirements, and players can only equip hats that they have access to.
- **Player-Specific Hats**: Each player has their own selected hat, which is saved and loaded from a vault.
- **Hat Removal**: Players can remove their currently equipped hat at any time.
- **Hat Data**: Hats are defined in a simple configuration file (`hats.ini`), allowing for easy customization.

## Installation

1. **Download the Plugin**: Download the `.amxx` file from the releases section or compile the source code in AMX Mod X.
   
2. **Place the Plugin**: Move the compiled `.amxx` file to the `plugins/` directory in your AMX Mod X installation.

3. **Configure the Plugin**:
   - Modify the `hats.ini` file to define the hats that players can use. You can find this file in the `configs/` folder.
   - Example hat configuration in `hats.ini`:
     ```
     Hat Name 1 | models/hat1.mdl | 1
     Hat Name 2 | models/hat2.mdl | 2
     ```
     Each entry contains the hat name, model path, and the level required to equip it.

4. **Enable the Plugin**:
   - Open the `plugins.ini` file located in the `configs/` folder.
   - Add `HatMenu.amxx` to the list of active plugins.

5. **Ensure Vault Compatibility**: This plugin uses the `nvault` system for saving player data. Ensure that the AMX Mod X server is properly set up to support nVault.

6. **Restart the Server**: After setting everything up, restart your AMX Mod X server.

## Commands

- **/hats**: Displays the hat selection menu where players can choose a hat.
- **/remove**: Removes the currently equipped hat from the player.

## Configuration

The hats are defined in the `hats.ini` file. Each line contains:
- The **name** of the hat
- The **model path** to the hat (relative to the `models/` directory)
- The **level** required to equip the hat

Example:
