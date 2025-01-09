# Teleport To Player Plugin

The "Teleport To Player" plugin is a powerful AMX Mod X tool for teleporting players in real-time within a game server. This plugin is ideal for admins who need quick mobility or the ability to assist other players efficiently. It provides an intuitive set of commands for teleportation and restoring the original positions, ensuring a seamless and immersive experience.

## Features

- **Admin Teleportation Commands**: Allows authorized admins to teleport to another player's location or return to their original position.
- **Semiclip Mode**: Automatically enables semi-clipping for smooth positioning during teleportation.
- **Position Reset**: Restores the player's original position with a single command.
- **Anti-Stuck Mechanism**: Detects and resolves potential player overlap issues after teleportation.
- **Visual Effects**: Adds rendering effects, such as beam rings and glow, to highlight teleportation events.
- **Comprehensive Error Handling**: Prevents misuse and ensures commands work only under valid conditions (e.g., alive players, correct permissions).

## Commands

### `/tp`
- **Description**: Teleports the admin to a target player.
- **Usage**: `/tp <player_name>`
- **Restrictions**: Only accessible to players with the required admin permissions (default: `ADMIN_KICK`).

### `/rtp`
- **Description**: Returns the admin to their original position after teleportation.
- **Usage**: `/rtp`
- **Restrictions**: Admin must have been teleported using the `/tp` command.

## Prerequisites

- **Game Server**: Requires an AMX Mod X-supported game server.
- **Admin Permissions**: Admin flag (default: `ADMIN_KICK`) is necessary to execute commands.
- **Sprite File**: Ensure `sprites/laserbeam.spr` is available on the server.

## Installation

1. Download the plugin source code (`TeleportToPlayer.sma`) and compile it using the AMX Mod X compiler.
2. Place the compiled plugin (`TeleportToPlayer.amxx`) into the `plugins` directory of your server.
3. Add the plugin to the `plugins.ini` file:
   ```
   TeleportToPlayer.amxx
   ```
4. Restart your server to load the plugin.

## Configuration

- **Admin Flag**: Modify the `ADMIN_FLAG` macro in the source code to customize the required admin permissions.
- **Beam Sprite**: Update the `sprites/laserbeam.spr` path if necessary.

## Code Highlights

### Key Functionalities

- **Teleportation**:
  The `OnSay` function handles player commands (`/tp` and `/rtp`) and executes the teleportation logic.

- **Anti-Stuck Mechanism**:
  The `StuckChecker` function monitors player positions post-teleport and resolves potential collisions by resetting semi-clip modes.

- **Visual Effects**:
  The `BeemRing` function utilizes `UTIL_BeamRing` to create a beam ring effect, visually marking teleportation events.

## Contributing

Contributions are welcome! To contribute:

1. Fork this repository.
2. Create a feature branch:
   ```
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```
   git commit -m "Add feature or fix bug"
   ```
4. Push your branch:
   ```
   git push origin feature-name
   ```
5. Submit a pull request.

## License

This plugin is released under the MIT License. See the [LICENSE](./LICENSE) file for more details.

## Support

For questions, issues, or feature requests, please open an issue in the repository or contact the plugin maintainer.

---

Thank you for using the "Teleport To Player" plugin. Your feedback and contributions are highly appreciated!

