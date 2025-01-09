#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta>
#include <fun>
#include <hamsandwich>

#define PLUGIN_VERSION "1.0"

#define DUALMP5_ID "dualmp5"
#define DUALMP5_NAME "Dual Mp5"
#define DUALMP5_VMODEL "models/v_dualmp5.mdl"
#define DUALMP5_WEAPON_STR "weapon_mp5navy"
#define DUALMP5_WEAPON_CSW CSW_MP5NAVY
#define DUALMP5_DAMAGE 2
#define DUALMP5_AMMO 500
#define BULLET_SOUND "weapons/mp5-1.mp3"

#define DEFAULT_VMODEL "models/v_mp5navy.mdl"

new bool:g_bDualMp5[MAX_PLAYERS +1];


public plugin_init()
{
	register_plugin("Dual Mp5", PLUGIN_VERSION, "Supremache")
	register_cvar("DUAL_MP5", PLUGIN_VERSION, FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED );
	
	RegisterHam(Ham_TakeDamage, "player", "OnTakeDamage")
	register_event("CurWeapon", "DualMP5Model", "be", "1=1")

	RegisterHam(Ham_Weapon_PrimaryAttack, DUALMP5_WEAPON_STR, "OnPrimaryAttack", 1)
	RegisterHam(Ham_Spawn, "player", "OnPlayerSpawn_Post", 1);
	RegisterHam(Ham_Killed, "player", "OnPlayerKilled_Post", 1);
	
	register_concmd("dm5", "@GiveDualMp5", ADMIN_KICK, "<player>");
}

public plugin_precache()
{
	precache_model(DUALMP5_VMODEL)
	precache_sound(BULLET_SOUND)
}



public client_putinserver(id)
{
	g_bDualMp5[id] = false;
}

@GiveDualMp5(id, cLevel, cCid)
{
	if(!cmd_access(id, cLevel, cCid, 1))
	{
		return PLUGIN_HANDLED;
	}
	
	static szTarget[32], iTarget;
	read_argv(1, szTarget, charsmax(szTarget));
	
	
	iTarget = cmd_target(id, szTarget, CMDTARGET_ALLOW_SELF | CMDTARGET_NO_BOTS);

	if(!iTarget) 
	{
		console_print(id, "Invalid player or matching multiple targets!");
		return PLUGIN_HANDLED;
	}
	
	g_bDualMp5[iTarget] = true; give_item(iTarget, DUALMP5_WEAPON_STR); cs_set_user_bpammo(iTarget, DUALMP5_WEAPON_CSW, DUALMP5_AMMO); DualMP5Model(iTarget);
	
	client_print_color(0, print_team_default, "[ADMIN]^4 %n^1 give^4 Dual Mp5^1 for^4 %n^1.", id, iTarget); 

	return PLUGIN_HANDLED;
}

public OnPlayerSpawn_Post(id)
{
	g_bDualMp5[id] = false;
	set_default_model(id);
}

public OnPlayerKilled_Post(id)
{
	g_bDualMp5[id] = false;
	set_default_model(id);
}

public OnTakeDamage(iVictim, iInflictor, iAttacker, Float:flDamage, iDamageBits)
	if(is_user_alive(iAttacker) && iAttacker != iVictim)
		if(g_bDualMp5[iAttacker])
			SetHamParamFloat(4, flDamage * DUALMP5_DAMAGE)
			
		
public OnPrimaryAttack(iWeapon)
{
	new id = pev(iWeapon, pev_owner)
	
	if(!g_bDualMp5[id])
		return
		
	new iClip, iAmmo
	new iWeapon = get_user_weapon(id, iClip, iAmmo)
	
	if(!iClip || iWeapon != DUALMP5_WEAPON_CSW)
		return
	
	emit_sound(id, CHAN_WEAPON, BULLET_SOUND, 1.0, ATTN_NORM, 0, PITCH_HIGH)
}


public DualMP5Model(id)
{
	if(get_user_weapon(id) == DUALMP5_WEAPON_CSW && g_bDualMp5[id])
	{
		set_pev(id, pev_viewmodel2, DUALMP5_VMODEL)
	}
}

set_default_model(id)
{
	if(get_user_weapon(id) == DUALMP5_WEAPON_CSW)
	{
		set_pev(id, pev_viewmodel2, DEFAULT_VMODEL)
	}
}
