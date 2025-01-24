# Authorization Plugin for AMX Mod X

## Overview
The **Authorization Plugin** is a robust admin management system for AMX Mod X servers. It leverages JSON-based admin storage, password protection, expiration dates, custom models, and dynamic reloading. This plugin is designed to simplify and secure server administration by enabling server owners to manage admins with flexibility and ease.

## Features
- **JSON-based Admin Storage**: Store admin data securely in a JSON file.
- **Password Protection**: Add an additional layer of security with password authentication for admins.
- **Expiration Date Management**: Set expiration dates for admin privileges to ensure timely access control.
- **Custom Models**: Assign unique player models to admins based on their team (Terrorist or Counter-Terrorist).
- **Dynamic Reloading**: Reload the admin list and settings without restarting the server.
- **Admin Management Commands**:
  - Add, remove, and list admins with ease.
  - Suspend or reactivate admin privileges as needed.
- **Predefined Default Models**: Supports default Terrorist and Counter-Terrorist models.

## Requirements
- AMX Mod X 1.10 or higher.
- ReAPI installed on your server.

## Installation
1. Download the plugin file `authorization.amxx`.
2. Place `authorization.amxx` in your `plugins` directory (e.g., `addons/amxmodx/plugins/`).
3. Add the following line to your `plugins.ini` file:
   ```
   authorization.amxx
   ```
4. Place the `Authorization.json` file in your `configs` directory (e.g., `addons/amxmodx/configs/`).

## Configuration
The `Authorization.json` file is automatically generated if it does not exist. You can customize it to include:
- Default player models for CT and Terrorist teams.
- Admin credentials (auth ID, password, flags, etc.).
- Expiration dates and suspension status.

### JSON Example:
```json
{
    "date_format": "%d.%m.%Y",
    "default_ct_models": [
        "gign",
        "sas",
        "guerilla",
        "militia",
        "spetsnaz"
    ],
    "default_t_models": [
        "urban",
        "terror",
        "leet",
        "arctic",
        "gsg9"
    ],
    "authorization": [
        {
            "auth": "Supremache",
            "password": "admin123",
            "flags": "abcdefgh",
            "ct_model": "admin-ct",
            "terror_model": "admin-t",
        },
        {
            "auth": "STEAM_0:1:554511776",
            "password": "admin123",
            "flags": "abcdefghigklmnopqrstu",
            "tag": "[SuperAdmin]",
            "ct_model": "modertator-ct",
            "terror_model": "modertator-t",
            "expiration_date": "31.12.2025",
            "suspended": false
        },
    ]
}
```

## Commands
### Admin Commands:
- **Add Admin**:
  ```
  amx_addauth <auth> <password> <flags> <tag> <ct_model> <t_model> <expire_date>
  ```
  Example:
  ```
  amx_addauth STEAM_0:1:123456 securepass abcdefg SuperAdmin gign leet 31.12.2025
  ```

- **Remove Admin**:
  ```
  amx_removeauth <auth>
  ```

- **List Admins**:
  ```
  amx_listauth
  ```

- **Reload Admin List**:
  ```
  amx_reloadauth
  ```

### User Commands:
- Admin models are automatically applied based on their credentials.

## Changelog
### Version 1.0
- Initial release.
- Added JSON-based admin storage.
- Password authentication and expiration date management.
- Dynamic admin reloading.
- Support for custom player models.

## Contributing
Contributions are welcome! Feel free to submit issues or pull requests to enhance this plugin.

## License
This plugin is licensed under the MIT License. See the `LICENSE` file for details.
