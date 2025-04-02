#include <amxmodx>
#include <amxmisc>
#include <nvault>
#include <fakemeta>
#include <hamsandwich>

native get_user_level(id);
native zp_get_user_zombie(id);
forward zp_user_humanized_post(id);
forward zp_user_infected_post(id);
#pragma semicolon 1

// Configuration
#define HAT_CONFIG_FILE "hats.ini"
#define MAX_HATS 64
#define HAT_DATA_SIZE 3    // 0:model, 1:name, 2:level

// Hat Data Structure
enum _:HatData {
	HAT_MODEL[64],
	HAT_NAME[32],
	HAT_LEVEL
}

;

new Array:g_HatData;

// Player Data
new g_SelectedHat[33];
new g_HatVault;

public plugin_init() {
	register_plugin("Advanced Hat menu", "1.0", "Supremache");
	
	// Commands
	register_clcmd("say /hats", "ShowHatsMenu");
	
	// Hamsandwich Registration
	RegisterHam(Ham_Spawn, "player", "OnPlayerSpawn", 1);
	
	// Initialize nVault
	g_HatVault=nvault_open("PlayerHats");
	
	// Load hats config
	if( !LoadHatsConfig()) {
		set_fail_state("Failed to load hats configuration");
	}
}

public plugin_precache() {
	g_HatData=ArrayCreate(HatData);
	LoadHatsConfig();
}

public client_authorized(id) {
	LoadPlayerHat(id);
}

public zp_user_infected_post(id) {
	RemoveHatEntity(id);
	g_SelectedHat[id]=0;
}

public zp_user_humanized_post(id) {
	RemoveHatEntity(id);
	g_SelectedHat[id]=0;
}



public client_disconnected(id) {
	RemoveHatEntity(id);
	g_SelectedHat[id]=0;
}

public OnPlayerSpawn(id) {
	if(is_user_alive(id)) {
		set_task(0.1, "ApplyHatDelayed", id);
	}
}

public ApplyHatDelayed(id) {
	if(is_user_alive(id)) {
		ApplyHat(id);
	}
}

public ShowHatsMenu(id) {
	if( !is_user_connected(id) || zp_get_user_zombie(id)) return;
	
	new menu=menu_create("Select a Hat:\r", "HatsMenuHandler");
	
	new hat[HatData],
	item[128],
	info[8];
	menu_additem(menu, "\rRemove Current Hat", "remove");
	
	for(new i=0; i < ArraySize(g_HatData); i++) {
		ArrayGetArray(g_HatData, i, hat);
		
		if(hat[HAT_LEVEL] < get_user_level(id)) {
			formatex(item, charsmax(item), "%s \y(Level %d)", hat[HAT_NAME], hat[HAT_LEVEL]);
		}
		
		else {
			formatex(item, charsmax(item), "%s \d(Level %d)", hat[HAT_NAME], hat[HAT_LEVEL]);
		}
		
		num_to_str(i, info, charsmax(info));
		menu_additem(menu, item, info);
	}
	
	
	menu_setprop(menu, MPROP_EXITNAME, "Exit");
	menu_display(id, menu);
}

public HatsMenuHandler(id, menu, item) {
	if(item==MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	new info[8],
	dummy;
	menu_item_getinfo(menu, item, dummy, info, charsmax(info), _, _, dummy);
	
	if(equal(info, "remove")) {
		g_SelectedHat[id]=0;
		SavePlayerHat(id);
		RemoveHatEntity(id);
		client_print_color(id, print_chat, "^4[DarkSlay]^1 Your hat has been removed.");
	}
	
	else {
		new hatIndex=str_to_num(info);
		
		if(0 <=hatIndex < ArraySize(g_HatData)) {
			new hat[HatData];
			ArrayGetArray(g_HatData, hatIndex, hat);
			
			if(get_user_level(id) < hat[HAT_LEVEL]) {
				client_print_color(id, print_chat, "^4[DarkSlay]^1 You have to reach level^3 %i^1 to get^4 %s", hat[HAT_LEVEL], hat[HAT_NAME]);
				goto @CLOSE;
			}
			
			g_SelectedHat[id]=hatIndex+1;
			SavePlayerHat(id);
			ApplyHat(id);
			client_print_color(id, print_chat, "^4[DarkSlay]^1 Hat selected successfully!");
		}
	}
	
	@CLOSE: menu_destroy(menu);
	return PLUGIN_HANDLED;
}

LoadHatsConfig() {
	new g_szFile[128],
	g_szConfigs[64];
	get_configsdir(g_szConfigs, charsmax(g_szConfigs));
	formatex(g_szFile, charsmax(g_szFile), "%s/%s", g_szConfigs, HAT_CONFIG_FILE);
	
	new iFile=fopen(g_szFile, "rt");
	
	if (iFile) {
		new szData[256],
		szHat[HatData];
		
		enum _:VALUES {
			NAME[32],
			MODEL[64],
			LEVEL[12],
		}
		
		new szValue[VALUES];
		
		while (fgets(iFile, szData, charsmax(szData))) {
			trim(szData);
			
			switch (szData[0]) {
				case EOS,
					';',
				'#',
				'/': continue;
				
				default: {
					parse(szData, szValue[NAME], charsmax(szValue[NAME]), szValue[MODEL], charsmax(szValue[MODEL]), szValue[LEVEL], charsmax(szValue[LEVEL]));
					for(new i=0; i < 3; i++) trim(szValue[i]);
					
					if(szValue[MODEL][0] !=EOS) {
						copy(szHat[HAT_MODEL], charsmax(szHat[HAT_MODEL]), szValue[MODEL]);
						precache_model(szValue[MODEL]);
					}
					
					copy(szHat[HAT_NAME], charsmax(szHat[HAT_NAME]), szValue[NAME]);
					
					szHat[HAT_LEVEL]=str_to_num(szValue[LEVEL]);
					
					ArrayPushArray(g_HatData, szHat);
				}
			}
		}
		
		fclose(iFile);
	}
	
	else {
		log_amx("ERROR: %s not found!", g_szFile);
	}
	
	return true;
}


ApplyHat(id) {
	if( !is_user_alive(id)) return;
	
	RemoveHatEntity(id);
	
	if(g_SelectedHat[id] > 0) {
		new hatIndex=g_SelectedHat[id] - 1;
		if(hatIndex >=ArraySize(g_HatData)) return;
		
		new hat[HatData];
		ArrayGetArray(g_HatData, hatIndex, hat);
		
		new iEntity=engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"));
		
		if(pev_valid(iEntity)) {
			engfunc(EngFunc_SetModel, iEntity, hat[HAT_MODEL]);
			set_pev(iEntity, pev_movetype, MOVETYPE_FOLLOW);
			set_pev(iEntity, pev_aiment, id);
			set_pev(iEntity, pev_owner, id);
			set_pev(id, pev_iuser2, iEntity); // Store the entity reference
		}
	}
}

RemoveHatEntity(id) {
	new ent=pev(id, pev_iuser2);
	
	if(ent > 0 && pev_valid(ent)) {
		engfunc(EngFunc_RemoveEntity, ent);
	}
	
	set_pev(id, pev_iuser2, 0);
}

LoadPlayerHat(id) {
	new authId[35],
	vaultData[10];
	get_user_authid(id, authId, charsmax(authId));
	
	if(nvault_get(g_HatVault, authId, vaultData, charsmax(vaultData))) {
		new hatIndex=str_to_num(vaultData);
		
		if(hatIndex >=0 && hatIndex < ArraySize(g_HatData)) {
			g_SelectedHat[id]=hatIndex+1;
		}
	}
}

SavePlayerHat(id) {
	new authId[35],
	vaultData[10];
	get_user_authid(id, authId, charsmax(authId));
	num_to_str(g_SelectedHat[id] - 1, vaultData, charsmax(vaultData));
	nvault_set(g_HatVault, authId, vaultData);
}