# ZE: Custom Staff Models

## Overview
**ZE: Custom Staff Models** is an AMX Mod X plugin designed for Zombie Plague servers, allowing special players (VIPs and Owners) to have unique player models. The models are assigned based on admin flags, ensuring a customized experience for privileged players.

## Features
- Assigns custom player models to VIPs and Owners.
- Models are configured in `zombieplague.ini`.
- Uses `amx_settings_api` to load and save models dynamically.
- Preloads models to prevent missing textures or crashes.
- Supports multiple models per rank (random selection on spawn).

## Requirements
- **AMX Mod X 1.8.2+**
- **Zombie Plague Mod**
- **Ham Sandwich Module**
- **amx_settings_api Module**

## Installation
### 1. Compile & Install
1. **Compile the plugin**  
   Use **AMX Mod X Compiler** or compile locally.
2. **Upload the compiled `.amxx` file**  
   Place `ze_custom_staff_models.amxx` into `cstrike/addons/amxmodx/plugins/`
3. **Enable the plugin**  
   Open `plugins.ini` in `cstrike/addons/amxmodx/configs/` and add:
   ```
   ze_custom_staff_models.amxx
   ```
4. **Restart the server or change the map** to load the plugin.

### 2. Configure Models
1. Open **`cstrike/addons/amxmodx/configs/zombieplague.ini`**  
2. Find or add the **Player Models** section:
   ```
   [Player Models]
   VIP HUMAN = vip_model_1, vip_model_2
   OWNER HUMAN = owner_model_1, owner_model_2
   ```
3. Replace `vip_model_1`, `owner_model_1`, etc., with actual model names.
4. Ensure models are placed in `cstrike/models/player/`.

## Admin Flags for Models
| Admin Type | Required Flags |
|------------|---------------|
| **Owner**  | `abcdefghjklmnoprstv` |
| **VIP**    | `bcdefghjkmnoprstq` |

## How It Works
- On spawn, the plugin checks if the player is an Owner or VIP.
- It assigns a random model from the `zombieplague.ini` file.
- Owners have the highest priority, followed by VIPs.
- If no custom model is found, it defaults to `vip`.

## Changelog
- **v1.0** - Initial release with model assignment, precaching, and dynamic loading.

## Credits
- **Supremache** – Plugin Developer
- **Connor** – `IsPlayer` Macro

## License
This plugin is open-source and free to use under the AMXX license.

---
### Need Help?
For support, feel free to open an issue on GitHub!
