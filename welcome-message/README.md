# Welcome Message Plugin

This AMX Mod X plugin sends a customizable welcome message to players when they join the server. The message can include dynamic placeholders such as the player's name, hostname, auth ID, IP address, host's IP address, and country.

## Features

- Customizable welcome messages stored in an external file.
- Dynamic placeholders that personalize the message for each player.
- Supports multiple formats for messages, with line breaks.
- Integrated with GeoIP to determine the country of the player based on their IP address.

## Installation

1. **Download the Plugin**
   - Obtain the compiled plugin file (`welcome_message.amxx`) and place it in the `plugins` directory of your AMX Mod X installation.

2. **Configuration**
   - Create a file named `WelcomeMessages.ini` in the `configs` directory.
   - Add your desired welcome messages in this file, using the following placeholders:
     - `%name%`: Player's name
     - `%hostname%`: Player's hostname
     - `%authid%`: Player's authentication ID
     - `%ip%`: Player's IP address
     - `%hostip%`: Host's IP address
     - `%country%`: Player's country

   **Example `WelcomeMessages.ini` content:**
	-Welcome to the server, %name%! Your IP is %ip% and you are from %country%. Enjoy your stay!

3. **Configure the Plugin**
- Open the `plugins.ini` file located in the `configs` directory.
- Add the following line:
  ```
  welcome_message.amxx
  ```

4. **Restart the Server**
- Restart your game server to apply the changes.

## Usage

When a player joins the server, they will receive a welcome message containing the personalized information based on the placeholders defined in the `WelcomeMessages.ini` file.

## Commands

- No commands are required to use this plugin. It runs automatically upon player connection.

## Development

### Plugin Source Code

The source code for this plugin is written in Pawn and can be found in the main plugin file (`welcome_message.sma`). 

### Placeholder Replacement Logic

The following placeholders are supported:
- `%name%`: Replaced with the player's name.
- `%hostname%`: Replaced with the player's hostname.
- `%authid%`: Replaced with the player's auth ID.
- `%ip%`: Replaced with the player's IP address.
- `%hostip%`: Replaced with the server host's IP address.
- `%country%`: Replaced with the player's country based on their IP address.

### File Structure

- `WelcomeMessages.ini`: Contains customizable welcome messages.
- `welcome_message.sma`: Source code for the plugin.
- `welcome_message.amxx`: Compiled plugin file.



