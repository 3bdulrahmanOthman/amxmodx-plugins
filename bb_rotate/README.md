# Rotate Blocks Plugin

The Rotate Blocks plugin for AMX Mod X enhances the Base Builder mod by enabling players to rotate blocks during the build phase, making it easier to create precise and aesthetically pleasing structures. Designed with efficiency and usability in mind, this plugin adds a valuable feature for Base Builder servers, fostering creativity and better gameplay.

## Features

- **Block Rotation**: Players can rotate valid blocks by aiming and using the `+rotate` command.
- **Build Phase Compatibility**: Functionality is restricted to the build phase to maintain game balance.
- **Color Feedback**: Blocks provide visual feedback when rotated.
- **Error Handling**: Alerts players when aiming at invalid entities or performing restricted actions.
- **Customizable Sound Effects**: Includes a rotation sound to enhance the user experience.

## Requirements

- AMX Mod X 1.8+ installed on the server.
- Base Builder mod installed and configured.
- Counter-Strike 1.6 server.

## Installation

1. **Download the Plugin**:
   Clone or download the plugin files from the repository.

2. **Compile the Plugin**:
   Use the AMX Mod X compiler to compile `bb_clone.sma` into a `.amxx` file.

3. **Upload the Plugin**:
   Place the compiled `.amxx` file into your server's `addons/amxmodx/plugins/` directory.

4. **Add Plugin to Config**:
   Open `plugins.ini` located in `addons/amxmodx/configs/` and add:
   ```
   rotate_blocks.amxx
   ```

5. **Upload Sound Files**:
   Place the `rotate.wav` file in the `sound/basebuilder/` directory on the server.

6. **Restart the Server**:
   Restart your Counter-Strike 1.6 server to activate the plugin.

## Usage

1. **Activate Rotation**:
   During the build phase, aim at a valid block and press the `+rotate` bind.

2. **Binding the Command**:
   Bind the `+rotate` command to a key using the in-game console:
   ```bash
   bind "<key>" "+rotate"
   ```
   Replace `<key>` with the desired key (e.g., `bind "r" "+rotate"`).

3. **Successful Rotation**:
   When successfully rotated, the block changes color momentarily, and a sound plays to confirm the action.

## Customization

- **Sound Effect**:
  Replace `basebuilder/rotate.wav` with a different sound file to customize the rotation sound.

- **Rotation Angle**:
  Modify the rotation logic in the `@rotateBlock` function to change the default 90-degree rotation.

## Limitations

- Only `func_wall` entities without the `ignore` target name can be rotated.
- Block rotation is available only during the build phase.
- Prevents rotation of restricted entities or entities in use.

## Contributing

Contributions are welcome! To propose changes or enhancements:

1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of changes"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contact

---

Thank you for using the Rotate Blocks plugin! Enhance your Base Builder gameplay and elevate creativity with this powerful tool.

