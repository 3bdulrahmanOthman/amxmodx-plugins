# VIP System Plugin for AMX Mod X

A powerful and modular VIP system for Counter-Strike 1.6 servers, providing a rich set of configurable perks and gameplay enhancements for VIP players.

## 📦 Features

This plugin provides administrators with the ability to grant VIP users various abilities and features:

- 🎖 **Respawn Privileges**: Extra health and armor on spawn.
- 💉 **Medic System**: Self-healing with cooldown, cost, and usage limit.
- 🦘 **Multi-Jump**: Double or triple jump capabilities.
- 💥 **Damage Boost**: Adjustable damage multiplier for VIPs.
- 💵 **Reward System**: Extra money per kill.
- 📊 **VIP Scoreboard Icon**: Show VIP icons on the scoreboard.
- 🧑‍🤝‍🧑 **Online VIP List**: Check online VIPs via chat.
- 🧾 **VIP Info Menu**: Enable/disable features via `/vipmenu`.

## 🔧 Configuration

All features are fully configurable using CVARs. You can set these in `amxx.cfg` or dynamically through the game.

Example:

```ini
vip_privilage_enable 1
vip_privilage_hp 50
vip_medic_enable 1
vip_multijump_enable 1
vip_rewards_enable 1
```

Full list of CVARs:
| CVAR                       | Description                   | Default        |
| -------------------------- | ----------------------------- | -------------- |
| `vip_chat_prefix`          | Chat prefix for VIP messages  | `[VIP System]` |
| `vip_privilage_enable`     | Enable extra spawn privileges | `1`            |
| `vip_privilage_hp`         | HP on spawn                   | `50`           |
| `vip_privilage_armor`      | Armor on spawn                | `50`           |
| `vip_medic_enable`         | Enable medic system           | `1`            |
| `vip_medic_cooldown`       | Cooldown in seconds           | `30.0`         |
| `vip_medic_amount`         | Heal amount                   | `35`           |
| `vip_medic_price`          | Heal cost                     | `3500`         |
| `vip_medic_limit`          | Max healing per round         | `150`          |
| `vip_multijump_enable`     | Enable multi-jump             | `1`            |
| `vip_multijump_count`      | Extra jumps count             | `2`            |
| `vip_damage_adjust_enable` | Enable damage multiplier      | `1`            |
| `vip_damage_multiplier`    | Multiplier value              | `1.2`          |
| `vip_online_check_enable`  | Enable online VIP list        | `1`            |
| `vip_rewards_enable`       | Enable reward system          | `1`            |
| `vip_rewards_money`        | Bonus money per kill          | `300`          |
| `vip_scoreboard_enable`    | Show VIP icon on scoreboard   | `1`            |
| `vip_info_menu_enable`     | Enable info menu              | `1`            |

## 🕹 Commands

| Command        | Access    | Description                   |
| -------------- | --------- | ----------------------------- |
| `say /vipmenu` | VIPs only | Open VIP feature toggles menu |
| `say /vips`    | All       | Show list of online VIPs      |

## 🔐 Admin Access Level

This plugin uses the default AMX Mod X admin level `ADMIN_LEVEL_H` (flag `t`) for VIP access. You can assign this in your `users.ini`:

```
"STEAM_0:1:23456789" "" "bit" "ce"
```

## 🛠 Dependencies

- [AMX Mod X](https://www.amxmodx.org/)
- [FakeMeta](https://wiki.alliedmods.net/Fakemeta)
- [HamSandwich](https://wiki.alliedmods.net/Ham_Sandwich_module)
