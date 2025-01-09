#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <hamsandwich>
#include <basebuilder>


new const g_szModelFile[ ] = "CustomModels.ini";

new Array:g_aTotalModels, Array:g_aModelFlags;

public plugin_init( ) 
{
	register_plugin("BB: RandomModelAssigner", "1.0.2", "Supremache");
	RegisterHam(Ham_Spawn, "player", "CBasePlayer_Spawn", 1);
    
	if(ArraySize(g_aModelFlags))
	{
		server_print("[Custom Models] Loaded %d models", ArraySize(g_aModelFlags))
	}
}

public plugin_precache() 
{
	g_aTotalModels = ArrayCreate(MAX_RESOURCE_PATH_LENGTH);
	g_aModelFlags = ArrayCreate();
	
	ReadFile();
}
    
public CBasePlayer_Spawn(id)
{
	if (!is_user_alive(id)) {
		return;
	}
    
	new szPlayerModel[MAX_RESOURCE_PATH_LENGTH];
	new bool:bModelAssigned = false;

	// Check for a specific model based on user flags
	for (new i = 0; i < ArraySize(g_aModelFlags); i++) {
		if (get_user_flags(id) & ArrayGetCell(g_aModelFlags, i) && !bb_is_user_zombie(id)) {
			ArrayGetString(g_aTotalModels, i, szPlayerModel, charsmax(szPlayerModel));
			cs_set_user_model(id, szPlayerModel);
			bModelAssigned = true;
			break;
		}
	}

	// If no specific flag model matches, assign a random model to all players
	if (!bModelAssigned) {
		if(ArraySize(g_aTotalModels) && !bb_is_user_zombie(id))
		{
			ArrayGetString(g_aTotalModels, random_num(0, ArraySize(g_aTotalModels) - 1), szPlayerModel, charsmax(szPlayerModel));
			cs_set_user_model(id, szPlayerModel);
		}
		else {
			cs_reset_user_model(id);
		}
	}
}

ReadFile()
{
    new g_szFile[128], g_szConfigs[64];
    get_configsdir(g_szConfigs, charsmax(g_szConfigs));
    formatex(g_szFile, charsmax(g_szFile), "%s/%s", g_szConfigs, g_szModelFile);

    new iFile = fopen(g_szFile, "rt");

    if (iFile)
    {
		new szData[MAX_USER_INFO_LENGTH],  szKey[MAX_RESOURCE_PATH_LENGTH], szValue[MAX_RESOURCE_PATH_LENGTH];

		while (fgets(iFile, szData, charsmax(szData)))
		{
			trim(szData);

			switch (szData[0])
			{
				case EOS, ';', '#', '/': continue;

				default:
				{
					parse(szData, szKey, charsmax(szKey), szValue, charsmax(szValue));
					trim(szKey); trim(szValue);

		    
					if(szValue[0] != EOS) {
						ArrayPushCell(g_aModelFlags, szKey[0] == '0' ? (ADMIN_ALL | ADMIN_USER): read_flags(szKey));
					}
					else {
						log_amx("WARNING: Empty model flag found for '%s'. Skipping.", szKey);
					}
					
					while(szValue[0] != 0 && strtok(szValue, szKey, charsmax(szKey), szValue, charsmax(szValue), ','))
					{
						trim(szKey); trim(szValue);
						precache_player_model(szKey);
						ArrayPushString(g_aTotalModels, szKey);
					}
					
					
				}
			}
		}
		fclose(iFile);
	}
	else {
		log_amx("ERROR: %s not found!", g_szFile);
	}
}


precache_player_model(const szModel[], &id = 0)
{
	new model[128]
	formatex(model, charsmax(model), "models/player/%s/%sT.mdl", szModel, szModel)

	if(file_exists(model))
	{
		id = precache_generic(model)
	}

	static const extension[] = "T.mdl"
	#pragma unused extension
	
	copy(model[strlen(model) - charsmax(extension)], charsmax(model), ".mdl")
    
	return precache_generic(model)
}
