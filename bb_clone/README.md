# Clone Blocks Plugin

The **Clone Blocks** plugin for AMX Mod X enables players to clone blocks in Base Builder game mode. This plugin enhances gameplay by allowing users to duplicate blocks easily and efficiently during the build phase. With its intuitive design and reliable performance, it is an excellent addition for Base Builder servers.

## Features

- **Block Cloning**: Players can clone in-game blocks with a simple command.
- **Clone Limit**: A configurable maximum number of cloned blocks per player to maintain balance.
- **Interactive Feedback**: Players receive real-time notifications and sound effects when blocks are cloned.
- **Build Phase Compatibility**: Ensures block cloning works seamlessly during the build phase.
- **Automatic Cleanup**: Removes all cloned blocks at the start of a new round.

## Installation

1. **Download the Plugin**:
   Save the plugin's source code as `bb_clone.sma`.

2. **Compile the Plugin**:
   Use the AMX Mod X compiler to compile the `.sma` file into a `.amxx` file.

3. **Add the Plugin to Your Server**:
   Place the compiled `bb_clone.amxx` file into the `addons/amxmodx/plugins/` directory.

4. **Update the Plugins Configuration**:
   Add the following line to the `addons/amxmodx/configs/plugins.ini` file:
   ```plaintext
   bb_clone.amxx
   ```

5. **Restart Your Server**:
   Restart the server to load the plugin.

## Commands

- `+clone`: Allows players to clone a block they are aiming at, provided it meets the requirements.

## Configuration

### Constants

- **`MAX_CLONED_BLOCKS`**: Maximum number of blocks a player can clone. Default is `15`.
- **`CLONE_SOUND`**: Path to the sound file played when a block is cloned. Default is `"basebuilder/clone.wav"`.

### Requirements for Cloning

- Players must be alive.
- The game must be in the build phase (or override flags must be enabled).
- Blocks must be valid entities and meet the plugin's criteria for cloning.

## Technical Details

- **Dependencies**:
  - AMX Mod X modules: `fakemeta`, `engine`, `amxmisc`, `basebuilder`

- **Key Functions**:
  - `@impulseClone`: Handles the cloning logic.
  - `OnRoundStart`: Cleans up cloned blocks at the start of each round.
  - `removeColor`: Resets cloned block visuals after cloning.

## Contributing

Contributions to improve the plugin are welcome! Follow these steps to contribute:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of changes"
   ```
4. Push to your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

## License

This plugin is released under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Credits

- **Author**: Supremache
- **Version**: 1.2

## Support

For issues, suggestions, or feature requests, please open an issue in the repository or contact the author directly.

---

Thank you for using the Clone Blocks plugin! Enhance your Base Builder gameplay today!

