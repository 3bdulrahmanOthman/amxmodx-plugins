#include < amxmodx >
#include <amxmisc>
#include < hamsandwich >
#include < zombieplague >
#include < amx_settings_api >

new const ZE_SETTING_RESOURCES[] = "zombieplague.ini"

#define IsPlayer(%0) ( 1 <= (%0) <= get_maxplayers() ) // Thank you Connor !

new const g_szDefaultModel[][] = { "vip" };

new Array:g_szOwnerModel, Array:g_szVIPModel;
	
	
public plugin_init() {
	register_plugin("ZE: Custom Staff Models", "1.0", "Supremache")
	RegisterHam( Ham_Spawn, "player", "forwardClientSpawn_Post", 1 );
}

public plugin_precache()
{
	g_szVIPModel = ArrayCreate(64, 1);
	g_szOwnerModel = ArrayCreate(64, 1);
	
	amx_load_setting_string_arr(ZE_SETTING_RESOURCES, "Player Models", "VIP HUMAN", g_szVIPModel)
	amx_load_setting_string_arr(ZE_SETTING_RESOURCES, "Player Models", "OWNER HUMAN", g_szOwnerModel)
	
	static iIndex;
	
	if(ArraySize(g_szVIPModel) == 0)
	{
		for(iIndex = 0; iIndex < sizeof g_szDefaultModel; iIndex++)
			ArrayPushString(g_szVIPModel, g_szDefaultModel[iIndex])
		
		amx_save_setting_string_arr(ZE_SETTING_RESOURCES, "Player Models", "VIP HUMAN", g_szVIPModel)
	}
	
	if(ArraySize(g_szOwnerModel) == 0)
	{
		for(iIndex = 0; iIndex < sizeof g_szDefaultModel; iIndex++)
			ArrayPushString(g_szOwnerModel, g_szDefaultModel[iIndex])
		
		amx_save_setting_string_arr(ZE_SETTING_RESOURCES, "Player Models", "OWNER HUMAN", g_szOwnerModel)
	}
	
	new szPlayerModel[64], szModelPath[128];
	
	
	for (iIndex = 0; iIndex < ArraySize(g_szVIPModel); iIndex++)
	{
		ArrayGetString(g_szVIPModel, iIndex, szPlayerModel, charsmax(szPlayerModel))
		formatex(szModelPath, charsmax(szModelPath), "models/player/%s/%s.mdl", szPlayerModel, szPlayerModel)
		precache_model(szModelPath)
	}
	
	for (iIndex = 0; iIndex < ArraySize(g_szOwnerModel); iIndex++)
	{
		ArrayGetString(g_szOwnerModel, iIndex, szPlayerModel, charsmax(szPlayerModel))
		formatex(szModelPath, charsmax(szModelPath), "models/player/%s/%s.mdl", szPlayerModel, szPlayerModel)
		precache_model(szModelPath)
	}
}

public forwardClientSpawn_Post( id, attacker, gib )
{	
	if (is_user_alive(id) && IsPlayer(id))
	{
		new szPlayerModel[64];
		if(has_all_flags(id, "abcdefghjklmnoprstv")) {
			ArrayGetString(g_szOwnerModel, random_num(0, ArraySize(g_szOwnerModel) - 1), szPlayerModel, charsmax(szPlayerModel))
			zp_override_user_model( id, szPlayerModel);
		} else if (has_all_flags	(id, "bcdefghjkmnoprstq")) {
			ArrayGetString(g_szVIPModel, random_num(0, ArraySize(g_szVIPModel) - 1), szPlayerModel, charsmax(szPlayerModel))
			zp_override_user_model( id, szPlayerModel);
		}
			
	}
}

public zp_user_humanized_post( id, survvior )
{
	if (IsPlayer(id) && !zp_get_user_survivor(id))
	{
		new szPlayerModel[64];
		if(has_all_flags(id, "abcdefghjklmnoprstv")) {
			ArrayGetString(g_szOwnerModel, random_num(0, ArraySize(g_szOwnerModel) - 1), szPlayerModel, charsmax(szPlayerModel))
			zp_override_user_model( id, szPlayerModel);
		} else if (has_all_flags	(id, "bcdefghjkmnoprstq")) {
			ArrayGetString(g_szVIPModel, random_num(0, ArraySize(g_szVIPModel) - 1), szPlayerModel, charsmax(szPlayerModel))
			zp_override_user_model( id, szPlayerModel);
		}		
	}
}
