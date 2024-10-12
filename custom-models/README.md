# Custom Models Plugin

## Overview
The **Custom Models Plugin** allows players to have custom player models in a Counter-Strike server. This plugin supports team-based models and flags, enabling a more customized gameplay experience.

## Features
- Load custom player models based on user flags and teams.
- Supports multiple models defined in a configuration file.
- Automatically assigns models when a player spawns.

## Installation

1. **Download the plugin files** and extract them.
2. Place the plugin file in the `cstrike/addons/amxmodx/plugins` folder.
3. Create a file named `CustomModels.ini` in the `cstrike/addons/amxmodx/data` folder.
4. Add the following line to the `plugins.ini` file located in `cstrike/addons/amxmodx/configs`:
```plaintext
	custom-models.amxx
5. Restart your server to apply changes.

## Configuration

### CustomModels.ini
The `CustomModels.ini` file is where you will define your custom player models. Each entry should have the following format:
```plaintext
"Model name" "flag" "team id"

	- `model_name`: The name of the model file (without the `.mdl` extension).
	- `flag`: User flags that need to be met for the model to be applied.
	- `team_id`: The team associated with the model (0 for unassigned, 1 for Terrorists, 2 for Counter-Terrorists, 3 for Spectators).

### Example
**"custom_model1" "0" "1"**
**"custom_model2" "a" "2"**

## Usage
Once the plugin is installed and configured, players will automatically be assigned their respective models based on their flags and team when they spawn in the game.

