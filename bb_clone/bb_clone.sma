#include <amxmodx>
#include <fakemeta>
#include <engine>
#include <amxmisc>
#include <basebuilder>
#include <Clone>

#define PLUGIN_VERSION "1.2"   

// Define keys and clone mode
#define GetEntMover(%1) (entity_get_int(%1, EV_INT_iuser3))
#define SetEntMover(%1,%2)  	( entity_set_int( %1, EV_INT_iuser3, %2 ) )
#define IsMovingEnt(%1)   	( entity_get_int( %1, EV_INT_iuser2 ) == 1 )

#define MAX_CLONED_BLOCKS 15

#define CLONE_SOUND "basebuilder/clone.wav"

new g_ClonesCount[MAX_PLAYERS + 1], g_iEntBarrier;
new g_ClonedBlocks[MAX_PLAYERS + 1][MAX_CLONED_BLOCKS];

public plugin_precache()
{
	precache_sound(CLONE_SOUND)
}

public plugin_init() {
	register_plugin("BB: Clone Blocks", PLUGIN_VERSION, "Supremache");
	register_cvar("CloneBlocks", PLUGIN_VERSION, FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED );
	
	register_clcmd("+clone", "@impulseClone");
	//register_impulse(201, "@impulseClone");
	
	register_event("HLTV", "OnRoundStart", "a", "1=0", "2=0")
	
	g_iEntBarrier = find_ent_by_tname( -1, "barrier" );
}
public client_putinserver(id)
{
	g_ClonesCount[id] = 0;
	arrayset(g_ClonedBlocks[id], 0, MAX_CLONED_BLOCKS);
}

public OnRoundStart() {
	for (new id = 1; id <= MAX_PLAYERS; id++) {
		if (!is_user_connected(id))
			continue;

		for (new i = 0; i < MAX_CLONED_BLOCKS; i++) {
			if (g_ClonedBlocks[id][i]) {
				Util_RemoveEntity(g_ClonedBlocks[id][i]);
				g_ClonedBlocks[id][i] = 0;
			}
		}
		g_ClonesCount[id] = 0;
	}
}

@impulseClone(pPlayer) {
	if (!is_user_alive(pPlayer) || bb_is_user_banned(pPlayer)
	|| bb_is_user_zombie(pPlayer) && !(get_user_flags(pPlayer) & bb_get_flags_override())
	|| !bb_is_build_phase() && !(get_user_flags(pPlayer) & bb_get_flags_override()))
	{
		return PLUGIN_HANDLED;
	}

	new ent, bodypart;
	get_user_aiming(pPlayer, ent, bodypart);

	if (!is_valid_ent(ent) || ent == g_iEntBarrier || is_user_alive(ent) || GetEntMover(ent) == 2 || IsMovingEnt(ent)) {
		client_print_color(pPlayer, print_team_default, "^4[CloneBlocks]^1 No valid entity aimed at.");
		return PLUGIN_HANDLED;
	}

	new szClass[10], szTarget[7];
	entity_get_string(ent, EV_SZ_classname, szClass, sizeof(szClass) - 1);
	entity_get_string(ent, EV_SZ_targetname, szTarget, sizeof(szTarget) - 1);

	if (!equal(szClass, "func_wall") || equal(szTarget, "ignore")) {
		client_print_color(pPlayer, print_team_default, "^4[CloneBlocks]^1 Target is not cloneable.");
		return PLUGIN_HANDLED;
	}

	if (g_ClonesCount[pPlayer] > MAX_CLONED_BLOCKS) {
		client_print_color(pPlayer, print_team_default, "^4[CloneBlocks]^1 You have reached your cloning limit of^4 %d^1 blocks!", MAX_CLONED_BLOCKS);
		return PLUGIN_HANDLED;
	}
	
	new iClone = UTIL_CloneEntity(ent);
	if (iClone != -1) {
		g_ClonedBlocks[pPlayer][g_ClonesCount[pPlayer]] = iClone;
		g_ClonesCount[pPlayer]++;
		set_pev(iClone, pev_rendermode, kRenderTransColor);
		set_pev(iClone, pev_rendercolor, Float:{163.0, 1.0, 37.0});
		set_pev(iClone, pev_renderamt, 240.0);
		client_cmd(pPlayer, "spk %s", CLONE_SOUND);
		SetEntMover(iClone, 1);
		set_task(0.3, "removeColor", iClone);
		client_print_color(pPlayer, print_team_default, "^4[CloneBlocks]^1 Block [^4%d^1 -^4 %i^1] cloned successfully!", g_ClonesCount[pPlayer], MAX_CLONED_BLOCKS);
	} else {
		client_print_color(pPlayer, print_team_default, "^4[CloneBlocks]^1 Failed to clone block.");
	}

	return PLUGIN_HANDLED;
}

public removeColor(ent){	
	set_pev(ent,pev_rendermode,kRenderNormal);
	set_pev(ent,pev_renderamt, 255.0 );
	SetEntMover(ent, 0);
}

