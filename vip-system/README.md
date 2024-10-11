# VIP System Plugin for AMX Mod X

## Overview
The VIP System plugin allows server administrators to manage VIP users, providing them with special privileges and features within the game. This plugin integrates with both SQL databases and configuration files to offer flexible account management.

## Features
- Manage VIP accounts with customizable settings.
- Supports MySQL and SQLite for data storage.
- Easy integration with existing AMX Mod X servers.
- Configurable expiration dates for VIP accounts.
- Connect messages that display VIP information to players.

## Installation

1. **Download the Plugin:**
   - Clone the repository:
     ```bash
     git clone https://github.com/Supremache/VIPSystem.git
     ```

2. **Move the Plugin Files:**
   - Copy the `VIPSystem.sma` file into your `scripting` directory.
   - Create the necessary configuration and language folders:
     ```bash
     mkdir configs
     mkdir lang
     ```

3. **Install Configuration Files:**
   - Place the configuration files (like `VIPAccount.ini`) into the `configs` directory.

4. **Compile the Plugin:**
   - Use the AMX Mod X compiler to compile `VIPSystem.sma`.
s
## Configuration
The plugin configuration is done through the `VIPSettings.ini` file. Below are key configuration options:

### Configuration Example
```plaintext
#============================================#
# Supremache's VIP System Configuration file #
# Need help https://forums.alliedmods.net/showthread.php?t=335515
#============================================#

# Prefix for chat messages.
CHAT_PREFIX = &x04[VIP]

# Accounts file name, don't forget to put ".ini" if you make any modification
ACCOUNT_FILE = VIPAccount.ini

# How the SQL work? It loads data from SQL and config files. 
# If a VIP account is not in the SQL file, it will be saved there.
# To save player's preferences: 0 = Config File | 1 = MySQL | 2 = SQLite
USE_SQL = 0

# Database informations (if using SQL)
SQL_HOST = localhost
SQL_USER = root
SQL_PASS = password
SQL_DATABASE = vip_database
SQL_TABLE = vip

# Connect Message Fields: $name$, $authid$, $flag$, $expiredate$
CONNECT_MESSAGE = &x03$name$&x01 has joined the game, Expired on &x04$expiredate$&x01 $country$.
TIME_CONNECT_MESSAGE = 2.5

# Default access for all non-VIP players 
DEFAULT_FLAGS = z

# Expiration date format
EXPIRATION_DATE_FORMAT = %d.%m.%Y

# Expiration date behavior: 0 = ignore, 1 = comment out, 2 = remove
EXPIRATION_DATE_BEHAVIOR = 1

# Control the date of adding VIPs
EXPIRATION_DATE_TYPE = day

# Auto-reload file settings
TIME_RELOAD_FILE = 1.0
AUTO_RELOAD = 0

# Command to reload file via console
RELOAD_VIP = amx_reloadvips

# Command to add VIP user via console
ADD_VIP = amx_addvip

# Command to check VIP list via chat
VIP_LIST = say /vips, say_team /vips, say /vip, say_team /vip

# Free VIP time (VIP Event) information
EVENT_TIME = 10 22
EVENT_FLAGS = cdef
EVENT_MESSAGE = "Event of free &x04VIPS&x01 has started"  "Event of free &x04VIPS&x01 starts at &x04 10 &x01| End at &x04 22"

# Access levels for various commands
ACCESS_RELOAD = i
ACCESS_ADD_VIP = a
ACCESS_SCOREBOARD = 0
ACCESS_CONNECT_MESSAGE = b
ACCESS_VIP_LIST = 0
