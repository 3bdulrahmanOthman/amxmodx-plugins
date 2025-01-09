#include <amxmodx>
#include <fakemeta>
#include <engine>
#include <amxmisc>
#include <hamsandwich>

#define isPlayer(%1) ((1 <= %1 && %1 < MAX_PLAYERS))

#define STUCK_CHECKER_TASK 118625
#define TELEPORTED_TASK 119533
#define ADMIN_FLAG ADMIN_KICK

enum PlayerState {
	Float:OriginalOrigin[3],
	bool:Teleported,
	bool:Semiclip,
	Target        
};

new g_pStates[MAX_PLAYERS + 1][PlayerState], g_iBeem;

public plugin_init() {
	register_plugin("Teleport To Player", "1.0", "Supremache");
	register_cvar("TTP", "1.0", FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED );
	

	register_clcmd("say", "OnSay");
	register_clcmd("say_team","OnSay");
	
	RegisterHam(Ham_Spawn, "player", "OnPlayerSpawn_Post", 1);
	RegisterHam(Ham_Killed, "player", "OnPlayerKilled_Post", 1);
}

public plugin_precache()
{
	g_iBeem = precache_model("sprites/laserbeam.spr")
}

public OnPlayerSpawn_Post(id)
{
	ResetData(id);
}

public OnPlayerKilled_Post(id)
{
	ResetData(id);
}

public client_putinserver(id)
{
	ResetData(id);
}

public OnSay(id)
{
	new szKey[MAX_FMT_LENGTH];
	read_args(szKey, charsmax(szKey));
	remove_quotes(szKey);

	if(equali(szKey, "/rtp", 4)) {
		if (!is_user_alive(id)) {
			client_print_color(id, print_team_default, "^4[RedBull]^1 You need to be alive to use this command!");
		}
		else if (!(get_user_flags(id) & ADMIN_FLAG)) {
			client_print_color(id, print_team_default,  "^4[RedBull]^1 You don't have permission to use this command!");
		}
		else if(g_pStates[id][Teleported]) {
			g_pStates[id][OriginalOrigin][2] += 60.0;
			engfunc(EngFunc_SetOrigin, id, g_pStates[id][OriginalOrigin]);
			ResetData(id);
			
			client_print_color(id, print_team_default, "^4[RedBull]^1 You have been teleported back to your original position.");
		}
	}
	else if(equali(szKey, "/tp", 3)) {
		if (!is_user_alive(id)) {
			client_print_color(id, print_team_default, "^4[RedBull]^1 You need to be alive to use this command!");
		}
		else if (!(get_user_flags(id) & ADMIN_FLAG)) {
			client_print_color(id, print_team_default,  "^4[RedBull]^1 You don't have permission to use this command!");
		}
		else {
			ResetData(id);

			g_pStates[id][Target] = cmd_target(id, szKey[4], CMDTARGET_ONLY_ALIVE | CMDTARGET_NO_BOTS);
			
			if(is_user_connected(g_pStates[id][Target])) {
				static Float:tOrigin[3];
		
				pev(id, pev_origin, g_pStates[id][OriginalOrigin]);
				pev(g_pStates[id][Target], pev_origin, tOrigin);
				
				engfunc(EngFunc_SetOrigin, id, tOrigin);
				g_pStates[id][Teleported] = true;
				
				set_pev(id, pev_solid, SOLID_NOT);
				set_pev(g_pStates[id][Target], pev_solid, SOLID_NOT);
				g_pStates[id][Semiclip] = true;
				g_pStates[g_pStates[id][Target]][Semiclip] = true;
				
				
				UTIL_SetRendering(id, kRenderFxNone, 255, 255, 255, kRenderTransAlpha, 150);
				UTIL_SetRendering(g_pStates[id][Target], kRenderFxNone, 255, 255, 255, kRenderTransAlpha, 150);
				set_task(1.0, "StuckChecker", id + STUCK_CHECKER_TASK, .flags ="b");
				set_task(1.0, "BeemRing", id + TELEPORTED_TASK, .flags = "b");
				UTIL_SetRendering(id, kRenderFxGlowShell, 127, 255, 42, kRenderNormal, 20);
				client_print_color(id, print_team_default, "^4[RedBull]^1 You have been teleported to^3 %n^1.", g_pStates[id][Target]);
				client_print_color(g_pStates[id][Target], print_team_default, "^4[RedBull]^3 %n^1 has been teleported to you.", id);

				
			} else {
				client_print_color(g_pStates[id][Target], print_team_default, "^4[RedBull]^1 Selected player is not available.");
			}
		}
	}
}

ResetData(id)
{
	arrayset(g_pStates[id][OriginalOrigin], 0.0, sizeof(g_pStates[][OriginalOrigin]));
	remove_task(id + TELEPORTED_TASK);
	remove_task(id + STUCK_CHECKER_TASK);
	g_pStates[id][Teleported] = false;
	ResetSemiClip(id)
	
	if(ResetSemiClip(g_pStates[id][Target]))
	{
		g_pStates[id][Target] = -1;
	}
}

bool:ResetSemiClip(id)
{
	if(isPlayer(id) && pev_valid(id))
	{
		g_pStates[id][Semiclip] = false;
		set_pev(id, pev_solid, SOLID_SLIDEBOX);
		set_pev(id, pev_movetype, MOVETYPE_WALK);
		UTIL_SetRendering(id);
		
		return true;
	}
	
	return false;
}


public StuckChecker(id)
{
	id -= STUCK_CHECKER_TASK;
	
	static Float:pOrigin[3], Float:tOrigin[3];
	pev(id, pev_origin, pOrigin);
	pev(g_pStates[id][Target], pev_origin, tOrigin);
        
	if (get_distance_f(pOrigin, tOrigin) > 60.0) { 
		ResetSemiClip(id)
		ResetSemiClip(g_pStates[id][Target]);
		UTIL_SetRendering(id, kRenderFxGlowShell, 127, 255, 42, kRenderNormal, 20);
		remove_task(id + STUCK_CHECKER_TASK);
	}
}


public BeemRing(id)
{
	id -= TELEPORTED_TASK;
	static Float:pOrigin[3];
	pev(id, pev_origin, pOrigin);

	pOrigin[2] -= 30.0;

	UTIL_BeamRing(pOrigin, g_iBeem, .life = 3,.width = 10, .r = 127, .g = 255, .b = 42, .receiver = id);
}

stock UTIL_SetRendering(iEntity, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16)
{
	static Float:color[3]
	color[0] = float(r)
	color[1] = float(g)
	color[2] = float(b)
	
	set_pev(iEntity, pev_renderfx, fx)
	set_pev(iEntity, pev_rendercolor, color)
	set_pev(iEntity, pev_rendermode, render)
	set_pev(iEntity, pev_renderamt, float(amount))
}

stock UTIL_BeamRing(Float:position[3], sprite, axis[3] = {0, 0, 0}, startframe = 0, framerate = 30, life = 10, width = 10, noise = 0, r = 0, g = 0, b = 255, a = 75, speed = 0, receiver = 0, bool:reliable = true)
{
	if(receiver && !is_user_connected(receiver))
		return 0;
	
	message_begin(reliable ? MSG_ONE : MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, .player = receiver);
	write_byte(TE_BEAMTORUS);
	write_coord_f(position[0]);
	write_coord_f(position[1]);
	write_coord_f(position[2]);
	write_coord(axis[0]);
	write_coord(axis[1]);
	write_coord(axis[2]);
	write_short(sprite);
	write_byte(startframe);
	write_byte(framerate);
	write_byte(life);
	write_byte(width);
	write_byte(noise);
	write_byte(r);
	write_byte(g);
	write_byte(b);
	write_byte(a);
	write_byte(speed);
	message_end();

	return 1;
}
