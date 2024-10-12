# Auto Restart Round Plugin

This plugin automatically restarts the game round after a specified number of rounds, providing a countdown with customizable settings for sound and HUD messages.

## Features

- **Automatic Round Restart**: Configures the plugin to restart the round after a set number of rounds.
- **Countdown Timer**: Displays a countdown message before the restart, with customizable duration and messages.
- **Sound Notifications**: Plays sounds during the countdown to alert players of the impending restart.
- **HUD Messages**: Displays customizable messages in the game HUD.

## Configuration

The plugin comes with several customizable CVars:

- `amx_restartround`: Number of rounds after which the game restarts (default: **30**).
- `amx_restart_time`: Time in seconds for the countdown before the restart (default: **10**).
- `amx_restart_sound`: Enable (1) or disable (0) sound notifications during countdown (default: **1**).
- `amx_restart_message`: Message displayed when the round is restarted (default: **"30 ROUNDS ENDED! Restarting..."**).
- `amx_restart_hudmessage`: HUD message format for the countdown (default: **"%seconds% seconds until restart!"**).
- `amx_restart_hudcolor`: Color for the HUD message in RGB format (default: **"0 255 0"**).

### Example Configuration

```plaintext
amx_restartround 30
amx_restart_time 10
amx_restart_sound 1
amx_restart_message "30 ROUNDS ENDED! Restarting..."
amx_restart_hudmessage "%seconds% seconds until restart!"
amx_restart_hudcolor "0 255 0"
