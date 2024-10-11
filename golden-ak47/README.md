# Perfect Golden AK Plugin

## Overview
The **Perfect Golden AK** plugin enhances your gameplay experience by introducing a beautifully designed golden AK-47 weapon that fires golden lasers. With precise damage and unique visual effects, this plugin provides a modern twist on the classic AK-47, making it a must-have for any serious player.

## Features
- **Custom Model**: Uses a unique golden AK-47 model.
- **Laser Effect**: Fires golden lasers with a visually stunning sprite effect.
- **Configurable Damage**: Set damage to 26 for every shot fired.
- **Easy Integration**: Simple installation process for any AMX Mod X server.

## Installation

### Requirements
- AMX Mod X 1.8 or higher
- Counter-Strike or other supported mods

### Installation Steps
1. **Download the Plugin**: Clone this repository or download it as a ZIP file.
2. **Install the Plugin**:
   - Move the `golden-ak47.sma` file to your `scripting` folder.
   - Compile the plugin using the AMX Mod X compiler.
   - Move the compiled `golden-ak47.amxx` file to your `plugins` folder.
   - Add `golden-ak47.amxx` to your `plugins.ini` file.
3. **Precache the Model**: Ensure that `sprites/laserbeam.spr` is included in your `sprites` folder.

## Usage
- Players will automatically receive the Perfect Golden AK upon spawning if they have the necessary permissions.
- The weapon can be fired like any other weapon, producing golden laser beams and dealing damage to opponents.

## Configuration
You can configure the plugin settings in the `configs` folder:
- Adjust `GoldenAK47` cvar for plugin-specific settings.

## Known Issues
- Compatibility issues may arise with other weapon modification plugins.
- Report any bugs or issues on the repository's issue tracker.

## License
This plugin is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author
**Supremache** - [GitHub Profile](https://github.com/Supremache)

## Acknowledgments
- Thanks to the AMX Mod X community for support and resources.
- Inspired by classic weapon modifications in FPS games.
