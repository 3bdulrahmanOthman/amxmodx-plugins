# ZP: Custom Models

## Description

The **ZP: Custom Models** plugin allows players to use custom player models based on their Steam ID in Zombie Plague servers. This enhances the gameplay experience by allowing players to customize their appearances.

## Features

- Custom player models based on Steam ID.
- Supports server-side configuration.
- Easy to set up and use.
- Pre-caches player models for efficient performance.

## Installation

1. **Download the Plugin**
   - Download the plugin files.

2. **Add Plugin Files**
   - Place the plugin in the `cstrike/addons/amxmodx/plugins` folder.

3. **Configuration**
   - Add `CustomModels.ini` in the `cstrike/addons/amxmodx/configs` folder.
   - The `CustomModels.ini` file should contain entries in the following format:
     ```
     STEAM_ID    ModelName    Flags
     ```
   - Example:
     ```
     STEAM_0:0:1234567    custom_model_name    "a"
     ```

4. **Register the Plugin**
   - Open `plugins.ini` located in the `cstrike/addons/amxmodx/configs` folder.
   - Add the following line:
     ```
     zp-custom-models.amxx
     ```

5. **Restart Your Server**
   - Restart your server for the changes to take effect.


## Usage

Upon connection, the plugin retrieves the player's Steam ID and checks if there is a custom model assigned to that ID in the `CustomModels.ini` file. If a matching model is found and the player is alive, it overrides the default model with the custom one.

## Example `CustomModels.ini`

```ini
# Custom Models Configuration
STEAM_ID              ModelName                Flags
STEAM_0:0:1234567     custom_model_name        "a"
STEAM_0:0:7654321     another_model_name       "b"
