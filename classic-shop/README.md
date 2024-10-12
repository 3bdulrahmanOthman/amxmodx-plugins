# Classic Shop Plugin

This plugin adds a shop system to any mod, allowing players (both tourist and counter-tourist) to purchase various items, abilities, and upgrades. Each team has its own shop with different items.

## Features

### Human Shop:
- **Health Packs**: Two types of health packs available.
- **Armor**: Purchase armor for protection.
- **Grenades**: HE Grenade, Flash Grenade, Smoke Grenade.
- **Super Knife**: A powerful melee weapon.
- **Bunny Hop**: Permanent ability to bunny hop.
- **MultiJump**: Permanent ability to perform multiple jumps.
- **Ultimate Clip**: Extra clip for your weapons.
- **Low Gravity**: Reduce gravity for the player.
- **Invisibility**: Temporary invisibility for a few seconds.
- **Godmode**: Temporary invincibility.
- **M249 Para Machinegun**: Purchase a heavy machine gun.
- **Auto Snipers**: G3SG1 and SG550 rifles available for purchase.

### Zombie Shop:
- **Health Packs**: Two types of health packs available.
- **Super Knife**: A powerful melee weapon for zombies.
- **Low Gravity**: Reduce gravity for the zombie.
- **Fast Speed**: Increase the zombie's speed.
- **Bunny Hop**: Permanent ability to bunny hop.
- **MultiJump**: Permanent ability to perform multiple jumps.
- **Invisibility**: Temporary invisibility for a few seconds.
- **Godmode**: Temporary invincibility.

## Installation

To install the plugin:

1. Download the zip file.
2. Place the plugin in the `cstrike/addons/amxmodx/plugins` folder.
3. Add the `shop.txt` to the `cstrike/addons/amxmodx/data/lang` folder.
4. Add the `shop.cfg` to the `cstrike/addons/amxmodx/configs` folder.
5. Add `classic-shop.amxx` in the `cstrike/addons/amxmodx/configs/plugins.ini` file (without quotes).
6. Restart your server or change the map to apply the plugin.

## Commands

The plugin automatically enables the shop based on the player's team (Humans or Zombies). Use the following commands to access the shop:

- **counter-tourist Shop**: Opens the shop for counter-tourist players to purchase items and upgrades.
- **tourist Shop**: Opens the shop for tourist players to purchase items and abilities.

## FAQ

**Q: What happens if the shop is disabled?**  
A: Players will receive a message indicating that the shop is currently disabled.

**Q: Can zombies and humans have different shop items?**  
A: Yes, each team has its own set of items and upgrades specific to their gameplay.

**Q: Is Bunny Hop permanent?**  
A: Yes, once purchased, the Bunny Hop ability is permanent for the player.

**Q: What happens when a player resets their items?**  
A: The player’s purchases will be reset, and they can start fresh.


Enjoy the plugin and happy building!
