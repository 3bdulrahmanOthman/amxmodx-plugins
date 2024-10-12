# CS 1.6 Bank System Plugin

This AMX Mod X plugin adds a bank system to CS 1.6 where players can manage their in-game cash by saving it in the form of a bank. Players can deposit, withdraw, check their balance, and even donate to other players.

## 📋 Features

1. **Deposit**: Save cash in the bank.
2. **Deposit All**: Save all available cash.
3. **Withdraw**: Take cash from the bank.
4. **Withdraw All**: Take all available cash from the bank.
5. **Bank Balance**: Check your bank balance.
6. **Donate Cash**: Transfer money to other players.
7. **Reset Bank**: Admin feature to reset a player's bank. Opens a menu showing online players.

## 🛠️ Installation

1. Download the plugin zip file.
2. Extract and place the `BankSystem.ini` file into the `cstrike/addons/amxmodx/configs` directory.
3. Open `addons/amxmodx/configs/plugins.ini` and add the following line at the end:
   ```ini
   Bank.amxx
4. Restart the server or change the map to apply the changes.

## 🖼️ Images


## ❓ FAQ

**Q: What happens when a player resets the bank?**  
A: The bank balance will be reset to zero for the chosen player.

**Q: Can players donate any amount of cash?**  
A: Yes, players can transfer a specific amount of cash to other players using the donation feature.
