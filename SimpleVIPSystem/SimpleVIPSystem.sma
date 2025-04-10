#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <hamsandwich>

#define m_afButtonPressed 246
#if cellbits == 32
#define OFFSET_CSMONEY  115
#else
#define OFFSET_CSMONEY  140
#endif

#define OFFSET_LINUX       5

#define ADMIN_VIP ADMIN_LEVEL_H

enum {
	SCOREATTRIB_ARG_PLAYERID = 1,
	SCOREATTRIB_ARG_FLAGS
};

enum ( <<= 1 ) {
	SCOREATTRIB_FLAG_NONE = 0,
	SCOREATTRIB_FLAG_DEAD = 1,
	SCOREATTRIB_FLAG_BOMB,
	SCOREATTRIB_FLAG_VIP
};


enum eCvars {
	ChatPrefix[32],
	bool:PrivilageEnable,
	PrivilageHealth,
	PrivilageArmor,
	bool:MedicEnable,
	Float:MedicCooldown,
	MedicAmount,
	MedicPrice,
	MedicLimit,
	bool:MultiJumpEnable,
	MultiJumpCount,
	bool:DamageAdjustEnable,
	Float:DamageMultiplier,
	bool:OnlineCheckEnable,
	bool:RewardsEnable,
	ExtraMoney,
	bool:ScoreBoardEnable,
	bool:InfoMenuEnable
}

new g_pCvar[eCvars];

new iJumps[MAX_PLAYERS +1], bool:bGiveMultiJump[MAX_PLAYERS +1];


public plugin_init() {
	register_plugin("VIP System", "1.0", "Supremache");
	
	bind_pcvar_string(create_cvar("vip_chat_prefix", "[VIP System]", .description = "VIP chat prefix"), g_pCvar[ChatPrefix], charsmax(g_pCvar[ChatPrefix]));
	
	bind_pcvar_num(create_cvar("vip_privilage_enable", "1", .description = "Enable Privilage feature"), g_pCvar[PrivilageEnable]);
	bind_pcvar_num(create_cvar("vip_privilage_hp", "50", .description = "Amount of privilage health"), g_pCvar[PrivilageHealth]);
	bind_pcvar_num(create_cvar("vip_privilage_armor", "50", .description = "Amount of privilage armor"), g_pCvar[PrivilageArmor]);
	
	bind_pcvar_num(create_cvar("vip_medic_enable", "1", .description = "Enable Medic feature"), g_pCvar[MedicEnable]);
	bind_pcvar_float(create_cvar("vip_medic_cooldown", "30.0", .description = "Medic cooldown in seconds"), g_pCvar[MedicCooldown]);
	bind_pcvar_num(create_cvar("vip_medic_amount", "35", .description = "Amount of health to heal"), g_pCvar[MedicAmount]);
	bind_pcvar_num(create_cvar("vip_medic_price", "3500", .description = "Amount of medic price"), g_pCvar[MedicPrice]);
	bind_pcvar_num(create_cvar("vip_medic_limit", "150", .description = "Medic limit"), g_pCvar[MedicLimit]);
	
	bind_pcvar_num(create_cvar("vip_multijump_enable", "1", .description = "Enable Multi-Jump feature"), g_pCvar[MultiJumpEnable]);
	bind_pcvar_num(create_cvar("vip_multijump_count", "2", .description = "Number of additional jumps"), g_pCvar[MultiJumpCount]);
	
	bind_pcvar_num(create_cvar("vip_damage_adjust_enable", "1", .description = "Enable Damage Adjust feature"), g_pCvar[DamageAdjustEnable]);
	bind_pcvar_float(create_cvar("vip_damage_multiplier", "1.2", .description = "Damage multiplier for VIPs"), g_pCvar[DamageMultiplier]);
	
	bind_pcvar_num(create_cvar("vip_online_check_enable", "1", .description = "Enable Online Check feature"), g_pCvar[OnlineCheckEnable]);
	
	bind_pcvar_num(create_cvar("vip_rewards_enable", "1", .description = "Enable Rewards System"), g_pCvar[RewardsEnable]);
	bind_pcvar_num(create_cvar("vip_rewards_money", "300", .description = "Extra money per kill"), g_pCvar[ExtraMoney]);
	
	bind_pcvar_num(create_cvar("vip_scoreboard_enable", "1", .description = "Enable Score Board"), g_pCvar[ScoreBoardEnable]);
	
	bind_pcvar_num(create_cvar("vip_info_menu_enable", "1", .description = "Enable Info Menu"), g_pCvar[InfoMenuEnable]);
	
	register_clcmd("say /vipmenu", "@VIPControler");
	register_clcmd("say /vips", "@ShowVIPList");
	register_clcmd("say /vipmedic", "onMedicUsed");
	
	RegisterHam(Ham_TakeDamage, "player", "onPlayerTakeDamage", true);
	RegisterHam(Ham_Killed, "player", "onPlayerKill" , true);
	RegisterHam(Ham_Spawn, "player", "OnPlayerSpawn", true);
	RegisterHam(Ham_Player_Jump, "player", "onPlayerJump");
}

@VIPControler(id) {
	if (!(get_user_flags(id) & ADMIN_VIP)) {
		client_print_color(id, print_team_default, "^4%s^1 You do not have access to the VIP menu.", g_pCvar[ChatPrefix]);
		return PLUGIN_HANDLED;
	}
	show_vip_menu(id);
	return PLUGIN_HANDLED;
}

show_vip_menu(id) {
	new menu = menu_create("\r[VIP Menu Controller]^n\wSelect a feature to toggle:", "vip_menu_handler");
	
	new szOption[64];
	
	formatex(szOption, charsmax(szOption), "Medic: \y[%s]", g_pCvar[MedicEnable] ? "Enabled" : "Disabled");
	menu_additem(menu, szOption, "0");
	
	formatex(szOption, charsmax(szOption), "Multi-Jump: \y[%s]", g_pCvar[MultiJumpEnable] ? "Enabled" : "Disabled");
	menu_additem(menu, szOption, "1");
	
	formatex(szOption, charsmax(szOption), "Damage Boost: \y[%s]", g_pCvar[DamageAdjustEnable] ? "Enabled" : "Disabled");
	menu_additem(menu, szOption, "2");
	
	formatex(szOption, charsmax(szOption), "Scoreboard VIP Icon: \y[%s]", g_pCvar[ScoreBoardEnable] ? "Enabled" : "Disabled");
	menu_additem(menu, szOption, "3");
	
	formatex(szOption, charsmax(szOption), "Reward System: \y[%s]", g_pCvar[RewardsEnable] ? "Enabled" : "Disabled");
	menu_additem(menu, szOption, "4");
	
	formatex(szOption, charsmax(szOption), "Online VIP Check: \y[%s]", g_pCvar[OnlineCheckEnable] ? "Enabled" : "Disabled");
	menu_additem(menu, szOption, "5");
	
	formatex(szOption, charsmax(szOption), "Respawn Privilages: \y[%s]", g_pCvar[PrivilageEnable] ? "Enabled" : "Disabled");
	menu_additem(menu, szOption, "6");
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
	menu_display(id, menu, 0);
}

public vip_menu_handler(id, menu, item) {
	if (item == MENU_EXIT) {
		menu_destroy(menu);
		return PLUGIN_HANDLED;
	}
	
	switch (item) {
		case 0: g_pCvar[MedicEnable] = g_pCvar[MedicEnable] ? false : true;
		case 1: g_pCvar[MultiJumpEnable] = g_pCvar[MultiJumpEnable] ? false : true;
		case 2: g_pCvar[DamageAdjustEnable] = g_pCvar[DamageAdjustEnable] ? false : true;
		case 3: g_pCvar[ScoreBoardEnable] = g_pCvar[ScoreBoardEnable] ? false : true;
		case 4: g_pCvar[RewardsEnable] = g_pCvar[RewardsEnable]? false : true;
		case 5: g_pCvar[OnlineCheckEnable] = g_pCvar[OnlineCheckEnable] ? false : true;
		case 6: g_pCvar[PrivilageEnable] = g_pCvar[PrivilageEnable] ? false : true;
	}
	
	show_vip_menu(id);
	return PLUGIN_HANDLED;
}


@ShowVIPList(id) {
	if(!g_pCvar[OnlineCheckEnable]) return PLUGIN_HANDLED;
	new szBuffer[ MAX_FMT_LENGTH ], szPlayers[ MAX_PLAYERS ], iNum;
	
	get_players( szPlayers, iNum, "ch" );
	
	for (new i = 0; i < iNum; i++) {
		new iIndex = szPlayers[i];
		if (get_user_flags(iIndex) & ADMIN_VIP) {
			format(szBuffer, charsmax(szBuffer), "%s^4%n^1%s", szBuffer, iIndex, (i == iNum - 1 || !(get_user_flags(szPlayers[i + 1]) & ADMIN_VIP)) ? "." : ", ");
		}
	}
	
	client_print_color( id, print_team_default, "^4%s^1: %s", g_pCvar[ChatPrefix], szBuffer[ 0 ] != EOS ? szBuffer : "There is no VIP's onlines" );
	return PLUGIN_HANDLED;
}

public onMedicUsed(id) {
	if (!g_pCvar[MedicEnable] || !(get_user_flags(id) & ADMIN_VIP) || !is_user_alive(id)) return;
	
	static Float:lastUsed[MAX_PLAYERS + 1];
	new Float:currentTime = get_gametime(), iHealth = pev(id, pev_health), iMoney = fm_get_user_money(id);
	
	if (currentTime - lastUsed[id] < g_pCvar[MedicCooldown])
	{
		client_print_color(id, print_team_default, "^4%s^1 You must wait %.1f seconds before using Medic again.",g_pCvar[ChatPrefix],(g_pCvar[MedicCooldown] - (currentTime - lastUsed[id])));
		return;
	}
	
	if(iHealth >= (g_pCvar[MedicLimit] - g_pCvar[MedicAmount]))
	{
		client_print_color(id, print_team_default, "^4%s^1 You must have less than ^3%d HP^1 to use the Medic ability.", g_pCvar[ChatPrefix], g_pCvar[MedicLimit] - g_pCvar[MedicAmount]);
		return;
	}
	
	if(iMoney < g_pCvar[MedicPrice])
	{
		client_print_color(id, print_team_default, "^4%s^1 You don't have enough money, it's cost^4%d^1.", g_pCvar[ChatPrefix], g_pCvar[MedicPrice]);
		return ;
	}
	
	fm_set_user_money(id, iMoney - g_pCvar[MedicPrice]);
	set_pev(id, pev_health, iHealth + float(g_pCvar[MedicAmount]));
	lastUsed[id] = currentTime;
	client_print_color(id, print_team_default, "^4%s^1 You have been healed by^4 %d^1 HP.", g_pCvar[ChatPrefix], g_pCvar[MedicAmount]);
}

public onMessageScoreAttrib(iMsgId, iDest, iReceiver) {
	if(g_pCvar[ScoreBoardEnable]) {
		if(get_user_flags(get_msg_arg_int(SCOREATTRIB_ARG_PLAYERID)) & ADMIN_VIP) {
			set_msg_arg_int( SCOREATTRIB_ARG_FLAGS, ARG_BYTE, SCOREATTRIB_FLAG_VIP );
		}
	}
}

public OnPlayerSpawn(id){
	if(!g_pCvar[PrivilageEnable] || !(get_user_flags(id) && ADMIN_VIP) || is_user_bot(id) || !is_user_alive(id))
		return;
	
	set_pev(id, pev_health, pev(id, pev_health) + float(g_pCvar[PrivilageHealth]));
	set_pev(id, pev_armorvalue, pev(id, pev_armorvalue) + float(g_pCvar[PrivilageArmor]));
	client_print_color(id, print_team_default, "^4%s^1 You have been recived^4 +%d^1 HP and^4 +%d^1 Armor.", g_pCvar[ChatPrefix], g_pCvar[PrivilageHealth], g_pCvar[PrivilageArmor]);
}


public onPlayerJump(id) {
	if (!g_pCvar[MultiJumpEnable] || !is_user_alive(id) || !(get_user_flags(id) & ADMIN_VIP))
		return HAM_IGNORED;
	
	new iFlags = pev(id, pev_flags)
	
	static afButtonPressed ; afButtonPressed = get_pdata_int(id, m_afButtonPressed)
	
	
	if (iFlags & FL_WATERJUMP || pev(id, pev_waterlevel) >= 2 || ~afButtonPressed & IN_JUMP)
		return HAM_IGNORED;
	
	if (iFlags & FL_ONGROUND)
	{
		iJumps[id] = 0
		return HAM_IGNORED;
	}
	
	if (bGiveMultiJump[id] && ++iJumps[id] <= g_pCvar[MultiJumpCount])
	{
		new Float:fVelocity[3]
		pev(id, pev_velocity, fVelocity)
		fVelocity[2] = 268.328157;
		set_pev(id, pev_velocity, fVelocity)
		
		return HAM_IGNORED;
	}
	
	return HAM_IGNORED;
}

public onPlayerTakeDamage(victim, inflictor, attacker, Float:damage, damageType) {
	if (victim == attacker || inflictor != attacker || !is_user_connected(attacker) || !g_pCvar[DamageAdjustEnable] || !(get_user_flags(attacker) & ADMIN_VIP))
		return HAM_IGNORED;
	
	damage *= g_pCvar[DamageMultiplier];
	SetHamParamFloat(4, damage);
	return HAM_HANDLED;
}

public onPlayerKill(victim, attacker, shouldgib) {
	if(!g_pCvar[RewardsEnable] || attacker == victim || !(get_user_flags(attacker) & ADMIN_VIP) || !is_user_connected(attacker)) return HAM_IGNORED;
	
	fm_set_user_money(attacker, fm_get_user_money(attacker) + g_pCvar[ExtraMoney]);
	client_print_color(attacker, print_team_default, "^4%s^1 You received extra rewards for your kill.", g_pCvar[ChatPrefix]);
	
	return HAM_HANDLED;
}


public client_connect(id) {
	if (g_pCvar[OnlineCheckEnable] && (get_user_flags(id) & ADMIN_VIP)) {
		client_print_color(id, print_team_default, "^4%s^1 VIP^4 %s^1 has joined the game.", g_pCvar[ChatPrefix]);
	}
}

stock fm_set_user_money(id,money,flash=1)
{
	set_pdata_int(id,OFFSET_CSMONEY,money,OFFSET_LINUX);
	
	message_begin(MSG_ONE,get_user_msgid("Money"),{0,0,0},id);
	write_long(money);
	write_byte(flash);
	message_end();
}

stock fm_get_user_money(id)
{
	return get_pdata_int(id,OFFSET_CSMONEY,OFFSET_LINUX);
}
