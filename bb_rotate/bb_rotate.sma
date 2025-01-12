#include <amxmodx>
#include <fakemeta>
#include <engine>
#include <amxmisc>
#include <basebuilder>
#include <Clone>

#define PLUGIN_VERSION "1.0"  

#define ROTATE_SOUND "basebuilder/rotate.wav"

#define GetEntMover(%1) (entity_get_int(%1, EV_INT_iuser3))
#define SetEntMover(%1,%2)  	( entity_set_int( %1, EV_INT_iuser3, %2 ) )
#define IsMovingEnt(%1)   	( entity_get_int( %1, EV_INT_iuser2 ) == 1 )

new g_iEntBarrier;

public plugin_precache()
{
	precache_sound(ROTATE_SOUND);
}

public plugin_init() {
	register_plugin("Rotate Blocks", PLUGIN_VERSION, "Supremache");
	register_cvar("RotateBlocks", PLUGIN_VERSION, FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED );
	
	
	register_clcmd("+rotate", "@rotateBlock");

	g_iEntBarrier = find_ent_by_tname( -1, "barrier" );
}


@rotateBlock(pPlayer) 
{
	if (!is_user_alive(pPlayer) || bb_is_user_banned(pPlayer)
	|| bb_is_user_zombie(pPlayer) && !(get_user_flags(pPlayer) & bb_get_flags_override())
	|| !bb_is_build_phase() && !(get_user_flags(pPlayer) & bb_get_flags_override()))
	{
		return PLUGIN_HANDLED;
	}
	
	
	if (bb_get_user_block(pPlayer) && is_valid_ent(bb_get_user_block(pPlayer))) 
		bb_drop_user_block(pPlayer);
		
		
	new ent, bodypart
	get_user_aiming(pPlayer, ent, bodypart)
	
	if (!is_valid_ent(ent) || ent == g_iEntBarrier || is_user_alive(ent) || GetEntMover(ent) == 2 || IsMovingEnt(ent)) {
		client_print_color(pPlayer, print_team_default, "^4[RotateBlocks]^1 No valid entity aimed at.");
		return PLUGIN_HANDLED;
	}

	new szClass[10], szTarget[7];
	entity_get_string(ent, EV_SZ_classname, szClass, sizeof(szClass) - 1);
	entity_get_string(ent, EV_SZ_targetname, szTarget, sizeof(szTarget) - 1);

	if (!equal(szClass, "func_wall") || equal(szTarget, "ignore")) {
		client_print_color(pPlayer, print_team_default, "^4[RotateBlocks]^1 Target is not cloneable.");
		return PLUGIN_HANDLED;
	}
	
	static Float:fAngle[3];
	entity_get_vector(ent, EV_VEC_angles, fAngle);

	fAngle[1] = FloatMod(fAngle[1] + 360.0, 360.0);
	fAngle[1] = FloatMod(fAngle[1] + 90.0, 360.0);
    
	UTIL_SetEntityAngles(ent, fAngle);
	
	set_pev(ent,pev_rendermode,kRenderTransColor);
	set_pev(ent,pev_rendercolor, Float:{212.0, 255.0, 37.0} );
	set_pev(ent,pev_renderamt, 240.0 );	
	SetEntMover(ent, 1);
	set_task(0.3, "removeColor", ent);

	client_cmd(pPlayer, "spk %s", ROTATE_SOUND);
		
	client_print_color(pPlayer, print_team_default, "^4[RotateBlocks]^1 Block has been rotated successfully!");
	
	return PLUGIN_HANDLED
		
}

stock Float:FloatMod(Float:oper1, Float:oper2) {
    return oper1 - floatround(oper1 / oper2, floatround_floor) * oper2;
}

public removeColor(ent)
{   
	set_pev(ent, pev_rendermode, kRenderNormal);
	set_pev(ent, pev_renderamt, 255.0);
	SetEntMover(ent, 0);
}
