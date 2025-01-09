# Dual MP5 AMXX Plugin

The **Dual MP5** plugin is an AMXX (AMX Mod X) plugin for Counter-Strike 1.6, allowing players to wield dual MP5s for enhanced gameplay. This plugin introduces a new weapon model, customizable settings, and additional features to elevate the gaming experience.

## Features

- **Dual MP5 Weapon**: Adds a unique dual MP5 weapon for players.
- **Customizable Damage Multiplier**: Adjust the damage output of the dual MP5.
- **Custom Models and Sounds**: Includes a custom weapon model (`v_dualmp5.mdl`) and sound effects.
- **Admin Commands**: Grant the dual MP5 to players via an admin command.
- **Dynamic Weapon Behavior**: Integrates smooth animations and weapon functionality.
- **Event Integration**: Reacts to player spawn, death, and weapon usage events.

## Installation

1. **Download the Plugin**:
   - Clone or download the repository containing the plugin source code.

2. **Compile the Plugin**:
   - Use the AMXX Studio or the AMX Mod X compiler to compile the plugin source file (`dualmp5.sma`) into a `.amxx` file.

3. **Upload the Plugin**:
   - Place the compiled `.amxx` file in the `plugins` folder of your AMX Mod X installation.
   - Add the plugin to the `plugins.ini` file located in the `configs` folder.

4. **Precache Resources**:
   - Place the custom model (`v_dualmp5.mdl`) in the `models` directory.
   - Place the custom sound (`mp5-1.mp3`) in the `sound/weapons` directory.

5. **Restart Server**:
   - Restart your Counter-Strike server to apply the changes.

## Commands and CVARs

### Commands

- **`dm5`**:
  - Usage: `dm5 <player>`
  - Description: Grants the specified player the Dual MP5.
  - Access: Admins with the `ADMIN_KICK` flag.

### CVARs

- **`DUAL_MP5`**:
  - Default: `1.0`
  - Description: Sets the plugin version or enables/disables the plugin functionality.

## Plugin Details

### Constants

- **Weapon Details**:
  - `DUALMP5_NAME`: "Dual Mp5"
  - `DUALMP5_VMODEL`: `models/v_dualmp5.mdl`
  - `DUALMP5_DAMAGE`: `2` (Damage multiplier)
  - `DUALMP5_AMMO`: `500` (Maximum ammo)

### Event Hooks

- **`Ham_TakeDamage`**: Modifies damage taken when the Dual MP5 is used.
- **`Ham_Weapon_PrimaryAttack`**: Customizes the behavior of the primary attack.
- **`Ham_Spawn` and `Ham_Killed`**: Resets player weapon state on spawn and death.

## Development

### File Structure

- **`dualmp5.sma`**: Source code for the plugin.
- **`models/`**: Contains the custom model file (`v_dualmp5.mdl`).
- **`sound/weapons/`**: Contains the custom sound file (`mp5-1.mp3`).

### Dependencies

This plugin requires the following AMX Mod X modules:

- **amxmodx**
- **amxmisc**
- **cstrike**
- **fakemeta**
- **fun**
- **hamsandwich**

## Contributing

Contributions are welcome! If you have ideas for improvements or encounter bugs, feel free to fork the repository, make changes, and submit a pull request.

### Steps to Contribute

1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add feature or fix bug"
   ```
4. Push the branch:
   ```bash
   git push origin feature-name
   ```
5. Submit a pull request.

## License

This plugin is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.

## Support

For questions, suggestions, or support, please contact me

---

Thank you for using the Dual MP5 plugin! Enhance your Counter-Strike experience today.

