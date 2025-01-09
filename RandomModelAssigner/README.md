# RandomModelAssigner

RandomModelAssigner is a versatile AMXX plugin designed for Counter-Strike 1.6. It allows players to have custom models assigned to them based on their flags or randomly from a pool of models. This plugin enhances gameplay by introducing variety and personalization, providing a dynamic experience for all players.

## Features

- **Custom Models for Specific Flags**: Assign unique models to players based on their admin flags.
- **Random Model Assignment**: Players without specific flag assignments can receive random models from a predefined pool.
- **Seamless Integration**: Works smoothly with existing Base Builder mods and other plugins.
- **Dynamic Model Loading**: Reads model configurations from an external file, making it easy to update or add new models.
- **Zombie Mode Compatibility**: Ensures that zombie players retain their designated models.
- **Error Logging**: Provides warnings for missing or misconfigured models.

## Requirements

- AMXX Mod X 1.8.2 or higher
- Counter-Strike 1.6

## Installation

1. **Download the Plugin**:
   - Clone or download the repository from GitHub:
     ```bash
     git clone https://github.com/yourusername/RandomModelAssigner.git
     ```

2. **Compile the Plugin**:
   - Place the `RandomModelAssigner.sma` file in your `addons/amxmodx/scripting` folder.
   - Compile it using AMXX Studio or the provided compiler in your AMX Mod X installation.

3. **Add the Plugin**:
   - Place the compiled `RandomModelAssigner.amxx` file in your `addons/amxmodx/plugins` folder.
   - Add the plugin name to your `plugins.ini` file:
     ```
     RandomModelAssigner.amxx
     ```

4. **Configure Models**:
   - Edit the `CustomModels.ini` file located in your `configs` folder to specify models and their corresponding flags.

5. **Restart the Server**:
   - Restart your Counter-Strike 1.6 server to load the plugin.

## Configuration

The plugin reads its configuration from the `CustomModels.ini` file. Each line should contain the model name and the associated flag. Example:

```
"0" "model_name1, model_name2, model_name3, model_name4"
"t" "vip_model1, vip_model2"
"b" "admin_model"
```

- `0` indicates a model available to all players.
- Admin flags like `a` can restrict models to specific users.

## Usage

- Players with assigned flags will automatically receive their specific models upon spawn.
- Players without specific assignments will receive a random model from the pool.
- Zombie players will not be affected by custom or random model assignments.

## Troubleshooting

- Ensure all models listed in `CustomModels.ini` are correctly uploaded to the server under `models/player/`.
- Check the server logs for warnings or errors if models are not being assigned correctly.
- Verify the plugin is listed and running using the `amxx plugins` command.

## Contributing

Contributions are welcome! If you have ideas for improvements or bug fixes, please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

---

Thank you for using RandomModelAssigner!

