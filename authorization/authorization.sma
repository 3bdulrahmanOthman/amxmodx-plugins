#pragma semicolon 1

#include <amxmodx>
#include <amxmisc>
#include <json>
#include <reapi>

#define AUTHORIZATION_VERSION		"1.0"

#define OBJECT_DATE_FORMAT		"date_format"
#define OBJECT_DEFAULT_CT_MODEL 	"default_ct_models"
#define OBJECT_DEFAULT_T_MODEL		"default_terror_models"

#define OBJECT_AUTH			"auth"
#define OBJECT_PASSWORD			"password"
#define OBJECT_FLAGS			"flags"
#define OBJECT_TAG			"tag"
#define OBJECT_CT_MODEL			"ct_model"
#define OBJECT_T_MODEL			"terror_model"
#define OBJECT_EXPIRE_DATE		"expiration_date"
#define OBJECT_SUSPENDED		"suspended"
			
new const AUTHORIZATION_FILE[] = "Authorization.json";
new const AUTHORIZATION_NAME[] = "authorization";

enum _:AuthorizationData {
	Auth[MAX_NAME_LENGTH],
	Password[32],
	Flags[32],
	Tag[MAX_NAME_LENGTH],
	CTModel[MAX_RESOURCE_PATH_LENGTH],
	TModel[MAX_RESOURCE_PATH_LENGTH],
	ExpireDate[32],
	bool:Suspended
	
}; new g_authData[AuthorizationData];

enum _:PlayerData
{
	Name[MAX_NAME_LENGTH],
	AuthID[MAX_AUTHID_LENGTH],
	IP[MAX_IP_LENGTH]
	
}; new g_pData[MAX_PLAYERS + 1][PlayerData];

enum SettingsData
{
	DateFormat[32],
	DefaultCTModel[MAX_RESOURCE_PATH_LENGTH],
	DefaultTModel[MAX_RESOURCE_PATH_LENGTH]
	
}; new g_aSettings[SettingsData];

new JSON:g_iJsonHandle;
new Trie:g_tAuthor;
new Array:g_aDefaultCTModels;
new Array:g_aDefaultTModels;

public plugin_end()
{
	if (g_iJsonHandle != Invalid_JSON)
	{
		json_free(g_iJsonHandle);
	}

	if (g_tAuthor != Invalid_Trie)
	{
		TrieDestroy(g_tAuthor);
	}
	
	if (g_aDefaultCTModels != Invalid_Array)
	{
		ArrayDestroy(g_aDefaultCTModels);
	}

	if (g_aDefaultTModels != Invalid_Array)
	{
		ArrayDestroy(g_aDefaultTModels);
	}
}

public plugin_precache()
{
	g_tAuthor = TrieCreate();
	g_aDefaultCTModels = ArrayCreate(MAX_RESOURCE_PATH_LENGTH);
	g_aDefaultTModels = ArrayCreate(MAX_RESOURCE_PATH_LENGTH);
	LoadAuthorization();
}

public plugin_init()
{
	register_plugin("Authorization", AUTHORIZATION_VERSION, "Supremache", "https://github.com/Supremache/amxmodx-plugins/blob/main/authorization", "A robust admin management system for AMX Mod X, featuring JSON-based admin storage, password protection, expiration dates, custom models, and dynamic reloading. Easily add, remove, and manage admins with flags, tags, and suspension capabilities. Perfect for secure and flexible server administration.");
	register_cvar("Authorization", AUTHORIZATION_VERSION, FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED);
	
	RegisterHookChain(RG_CBasePlayer_SetClientUserInfoName, "CBasePlayer_ClientUserInfoNameChange_Post", true);
	RegisterHookChain(RG_CBasePlayer_SetClientUserInfoModel, "@CBasePlayer_SetClientUserInfoModel_Pre", false);
	
	register_concmd("amx_reloadauth", "@ReloadAuthorization", ADMIN_RCON);
	register_concmd("amx_addauth", "@AddAuthorization", ADMIN_RCON, "amx_addauth <auth> <password> <flags> <tag> <ctmodel> <tmodel> <expire date>");
	register_concmd("amx_removeauth", "@RemoveAuthorization", ADMIN_RCON, "amx_removeauth <auth>");
	register_concmd("amx_listauth", "@ListAuthorization", ADMIN_ALL);
}

public client_authorized(pPlayer)
{
	get_user_name(pPlayer, g_pData[pPlayer][Name], charsmax(g_pData[][Name]));
	get_user_authid(pPlayer, g_pData[pPlayer][AuthID], charsmax(g_pData[][AuthID]));
	get_user_ip(pPlayer, g_pData[pPlayer][IP], charsmax(g_pData[][IP]), 1);

	CheckAuthorization(pPlayer);
}


public CBasePlayer_SetClientUserInfoModel_Pre(const pPlayer, szInfoBuffer[], szNewModel[])
{
	new bool:isAuthorized;

	if (TrieKeyExists(g_tAuthor, g_pData[pPlayer][Name]))
	{
		TrieGetArray(g_tAuthor, g_pData[pPlayer][Name], g_authData, sizeof(g_authData));
		isAuthorized = true;
	}
	else if (TrieKeyExists(g_tAuthor, g_pData[pPlayer][AuthID]))
	{
		TrieGetArray(g_tAuthor, g_pData[pPlayer][AuthID], g_authData, sizeof(g_authData));
		isAuthorized = true;
	}
	else if (TrieKeyExists(g_tAuthor, g_pData[pPlayer][IP]))
	{
		TrieGetArray(g_tAuthor, g_pData[pPlayer][IP], g_authData, sizeof(g_authData));
		isAuthorized = true;
	}

	if (isAuthorized)
	{
		switch (TeamName:get_member(pPlayer, m_iTeam))
		{
			case TEAM_TERRORIST:
			{
				if (g_authData[TModel][0] != EOS)
				{
					SetHookChainReturn(ATYPE_STRING, g_authData[TModel]);
				}
				else if (ArraySize(g_aDefaultTModels) > 0)
				{
					ArrayGetString(g_aDefaultTModels, random_num(0, ArraySize(g_aDefaultTModels) - 1), g_aSettings[DefaultTModel], charsmax(g_aSettings[DefaultTModel]));
					SetHookChainReturn(ATYPE_STRING, g_aSettings[DefaultTModel]);
				}
			}
			case TEAM_CT:
			{
				if (g_authData[CTModel][0] != EOS)
				{
					SetHookChainReturn(ATYPE_STRING, g_authData[CTModel]);
				}
				else if (ArraySize(g_aDefaultCTModels) > 0)
				{
					ArrayGetString(g_aDefaultCTModels, random_num(0, ArraySize(g_aDefaultCTModels) - 1), g_aSettings[DefaultCTModel], charsmax(g_aSettings[DefaultCTModel]));
					SetHookChainReturn(ATYPE_STRING, g_aSettings[DefaultCTModel]);
				}
			}
		}
	}

	return HC_CONTINUE;
}

public CBasePlayer_ClientUserInfoNameChange_Post(const pPlayer, infobuffer[], szNewName[])
{
	if (!is_user_connected(pPlayer))
		return;

	copy(g_pData[pPlayer][Name], charsmax(g_pData[][Name]), szNewName);

	CheckAuthorization(pPlayer);
}


@ReloadAuthorization(pPlayer)
{
	if (g_iJsonHandle != Invalid_JSON)
	{
		json_free(g_iJsonHandle);
	}

	LoadAuthorization();
	console_print(pPlayer, "[Author System] Authorization has been reloaded successfully.");
}

@AddAuthorization(pPlayer, level, cid)
{
	if (!cmd_access(pPlayer, level, cid, 3))
	{
		return PLUGIN_HANDLED;
	}

	read_argv(1, g_authData[Auth], charsmax(g_authData[Auth]));
	read_argv(2, g_authData[Password], charsmax(g_authData[Password]));
	read_argv(3, g_authData[Flags], charsmax(g_authData[Flags]));
	read_argv(4, g_authData[Tag], charsmax(g_authData[Tag]));
	read_argv(5, g_authData[CTModel], charsmax(g_authData[CTModel]));
	read_argv(6, g_authData[TModel], charsmax(g_authData[TModel]));
	read_argv(7, g_authData[ExpireDate], charsmax(g_authData[ExpireDate]));

	AddAuthorization(g_authData[Auth], g_authData[Password], g_authData[Flags], g_authData[Tag], g_authData[CTModel], g_authData[TModel], g_authData[ExpireDate]);
	
	console_print(pPlayer, "^n----------------------------------------------");
	console_print(pPlayer, "| Authorization has been added successfully     ");
	console_print(pPlayer, "----------------------------------------------");
	if (g_authData[Auth][0] != EOS) console_print(pPlayer, "| Auth: %s", g_authData[Auth]);
	if (g_authData[Password][0] != EOS) console_print(pPlayer, "| Password: %s", g_authData[Password]);
	if (g_authData[Flags][0] != EOS) console_print(pPlayer, "| Flags: %s", g_authData[Flags]);
	if (g_authData[Tag][0] != EOS) console_print(pPlayer, "| Tag: %s", g_authData[Tag]);
	if (g_authData[CTModel][0] != EOS) console_print(pPlayer, "| CT Model: %s", g_authData[CTModel]);
	if (g_authData[TModel][0] != EOS) console_print(pPlayer, "| T Model: %s", g_authData[TModel]);
	if (g_authData[ExpireDate][0] != EOS) console_print(pPlayer, "| Expiration Date: %s", g_authData[ExpireDate]);
	console_print(pPlayer, "----------------------------------------------^n^n");
	return PLUGIN_HANDLED;
}

@RemoveAuthorization(pPlayer, level, cid)
{
	if (!cmd_access(pPlayer, level, cid, 2))
	{
		return PLUGIN_HANDLED;
	}

	read_argv(1, g_authData[Auth], charsmax(g_authData[Auth]));

	if (g_iJsonHandle == Invalid_JSON)
	{
		console_print(pPlayer, "[Author System] JSON handle is invalid. Reload the authorization system first.");
		return PLUGIN_HANDLED;
	}

	new JSON:authorizationArray = json_object_get_value(g_iJsonHandle, AUTHORIZATION_NAME);

	if (authorizationArray == Invalid_JSON)
	{
		console_print(pPlayer, "[Author System] 'authorization' array not found in JSON.");
		return PLUGIN_HANDLED;
	}

	new size = json_array_get_count(authorizationArray);

	for (new JSON:authorizationObject, i = 0; i < size; i++)
	{
		authorizationObject = json_array_get_value(authorizationArray, i);

		if (authorizationObject == Invalid_JSON)
		{
			console_print(pPlayer, "[Author System] Invalid authorization object at index %d.", i);
			continue;
		}

		new szAuth[MAX_AUTHID_LENGTH];
		json_object_get_string(authorizationObject, OBJECT_AUTH, szAuth, charsmax(szAuth));

		if (equal(g_authData[Auth], szAuth))
		{
			json_array_remove(authorizationArray, i);
			SaveAuthorization();
			TrieDeleteKey(g_tAuthor, g_authData[Auth]);
			console_print(pPlayer, "[Author System] Authorization for '%s' removed successfully.", g_authData[Auth]);
			json_free(authorizationObject);
			break;
		}

		json_free(authorizationObject);
	}

	return PLUGIN_HANDLED;
}


@ListAuthorization(pPlayer, level, cid)
{
	if (!cmd_access(pPlayer, level, cid, 1))
	{
		return PLUGIN_HANDLED;
	}

	ListAuthorization(pPlayer);
	return PLUGIN_HANDLED;
}

LoadAuthorization()
{
	ArrayClear(g_aDefaultCTModels);
	ArrayClear(g_aDefaultTModels);
	
	new filePath[PLATFORM_MAX_PATH];
	get_configsdir(filePath, charsmax(filePath));
	format(filePath, charsmax(filePath), "%s/%s", filePath, AUTHORIZATION_FILE);

	
	if (!file_exists(filePath))
	{
		g_iJsonHandle = json_init_object();
		json_object_set_string(g_iJsonHandle, OBJECT_DATE_FORMAT, "%d.%m.%Y");

		new JSON:defaultCTModels = json_init_array();
		new const ctDefaultModels[][] = { "gign", "sas", "guerilla", "militia", "spetsnaz" };
		for (new i = 0; i < sizeof(ctDefaultModels); i++)
		{
			json_array_append_string(defaultCTModels, ctDefaultModels[i]);
			ArrayPushString(g_aDefaultCTModels, ctDefaultModels[i]);
		}
		json_object_set_value(g_iJsonHandle, OBJECT_DEFAULT_CT_MODEL, defaultCTModels);
		json_free(defaultCTModels);

		new JSON:defaultTModels	 = json_init_array();
		new const tDefaultModels[][] = { "urban", "terror", "leet", "arctic", "gsg9" };
		for (new i = 0; i < sizeof(tDefaultModels); i++)
		{
			json_array_append_string(defaultTModels, tDefaultModels[i]);
			ArrayPushString(g_aDefaultCTModels, tDefaultModels[i]);
		}
		json_object_set_value(g_iJsonHandle, OBJECT_DEFAULT_T_MODEL, defaultTModels);
		json_free(defaultTModels);

		new JSON:authorizationArray = json_init_array();
		json_object_set_value(g_iJsonHandle, AUTHORIZATION_NAME, authorizationArray);
		json_free(authorizationArray);
		
		json_serial_to_file(g_iJsonHandle, filePath, true);
		json_free(g_iJsonHandle);
		return;
	}

	g_iJsonHandle = json_parse(filePath, true);

	if (g_iJsonHandle == Invalid_JSON)
	{
		server_print("Error parsing authorization file '%s'. Please check the file for syntax errors.", filePath);
		return;
	}

	if (!json_object_get_string(g_iJsonHandle, OBJECT_DATE_FORMAT, g_aSettings[DateFormat], charsmax(g_aSettings[DateFormat])))
	{
		server_print("Failed to load date format from JSON. Using default format.");
		copy(g_aSettings[DateFormat], charsmax(g_aSettings[DateFormat]), "%d.%m.%Y");
	}

	new JSON:defaultCTModels = json_object_get_value(g_iJsonHandle, OBJECT_DEFAULT_CT_MODEL);

	if (json_is_array(defaultCTModels))
	{
		for (new i = 0; i < json_array_get_count(defaultCTModels); i++)
		{
			
			json_array_get_string(defaultCTModels, i, g_aSettings[DefaultCTModel], charsmax(g_aSettings[DefaultCTModel]));
			if (TryPrecachePlayerModel(g_aSettings[DefaultCTModel]))
			{
				ArrayPushString(g_aDefaultCTModels, g_aSettings[DefaultCTModel]);
			}
		}
	}
	else
	{
		server_print("Failed to load default CT models from JSON.");
	}

	new JSON:defaultTModels = json_object_get_value(g_iJsonHandle, OBJECT_DEFAULT_T_MODEL);
	if (json_is_array(defaultTModels))
	{
		for (new i = 0; i < json_array_get_count(defaultTModels); i++)
		{
			json_array_get_string(defaultTModels, i, g_aSettings[DefaultTModel], charsmax(g_aSettings[DefaultTModel]));
			if (TryPrecachePlayerModel(g_aSettings[DefaultTModel]))
			{
				ArrayPushString(g_aDefaultTModels, g_aSettings[DefaultTModel]);
			}
		}
	}
	else
	{
		server_print("Failed to load default T models from JSON.");
	}

	new JSON:authorizationArray = json_object_get_value(g_iJsonHandle, AUTHORIZATION_NAME);
	if (json_is_array(authorizationArray))
	{
		new size = json_array_get_count(authorizationArray);

		for (new i = 0; i < size; i++)
		{
			new JSON:authorizationObject = json_array_get_value(authorizationArray, i);

			if (json_is_object(authorizationObject))
			{
				// Required field
				if (!json_object_get_string(authorizationObject, OBJECT_AUTH, g_authData[Auth], charsmax(g_authData[Auth])))
				{
					server_print("Missing 'auth' field in authorization object at index %d", i);
					continue;
				}

				// Optional fields
				json_object_get_string(authorizationObject, OBJECT_PASSWORD, g_authData[Password], charsmax(g_authData[Password]));
				json_object_get_string(authorizationObject, OBJECT_FLAGS, g_authData[Flags], charsmax(g_authData[Flags]));
				json_object_get_string(authorizationObject, OBJECT_TAG, g_authData[Tag], charsmax(g_authData[Tag]));
				json_object_get_string(authorizationObject, OBJECT_CT_MODEL, g_authData[CTModel], charsmax(g_authData[CTModel]));
				json_object_get_string(authorizationObject, OBJECT_T_MODEL, g_authData[TModel], charsmax(g_authData[TModel]));
				json_object_get_string(authorizationObject, OBJECT_EXPIRE_DATE, g_authData[ExpireDate], charsmax(g_authData[ExpireDate]));
				json_object_get_bool(authorizationObject, OBJECT_SUSPENDED, g_authData[Suspended]);

				if(!TryPrecachePlayerModel(g_authData[CTModel]))
				{
					continue;
				}
				
				if(!TryPrecachePlayerModel(g_authData[TModel]))
				{
					continue;
				}
			
				if (g_authData[Suspended])
				{
					server_print("Author '%s' has been suspended.", g_authData[Auth]);
					continue;
				}

				if (parse_time(g_authData[ExpireDate], g_aSettings[DateFormat]) < get_systime())
				{
					server_print("Author '%s' has expired.", g_authData[Auth]);
					continue;
				}

				TrieSetArray(g_tAuthor, g_authData[Auth], g_authData, sizeof(g_authData));
				json_free(authorizationObject);
			}
		}
	}
	else
	{
		server_print("Failed to load authorization data from JSON.");
	}
}

AddAuthorization(const auth[], const password[], const flags[], const tag[], const ct_model[], const terror_model[], const expiration[], bool: suspended = false)
{
	new JSON:authorization = json_init_object();

	json_object_set_string(authorization, OBJECT_AUTH, auth);
	json_object_set_string(authorization, OBJECT_PASSWORD, password);
	json_object_set_string(authorization, OBJECT_FLAGS, flags);
	json_object_set_string(authorization, OBJECT_TAG, tag);
	json_object_set_string(authorization, OBJECT_CT_MODEL, ct_model);
	json_object_set_string(authorization, OBJECT_T_MODEL, terror_model);
	json_object_set_string(authorization, OBJECT_EXPIRE_DATE, expiration);
	json_object_set_bool(authorization, OBJECT_SUSPENDED, suspended);

	new JSON:authorizationArray = json_object_get_value(g_iJsonHandle, AUTHORIZATION_NAME);

	if (authorizationArray == Invalid_JSON)
	{
		authorizationArray = json_init_array();
		json_object_set_value(g_iJsonHandle, AUTHORIZATION_NAME, authorizationArray);
	}

	json_array_append_value(authorizationArray, authorization);
	SaveAuthorization();
}

SaveAuthorization()
{
	new filePath[PLATFORM_MAX_PATH];
	get_configsdir(filePath, charsmax(filePath));
	format(filePath, charsmax(filePath), "%s/%s", filePath, AUTHORIZATION_FILE);

	json_serial_to_file(g_iJsonHandle, filePath, true);
}

ListAuthorization(pPlayer)
{
	console_print(pPlayer, "^n--------------------------------------------------------------------------------------------------------------");
	console_print(pPlayer, "| %-20s | %-20s | %-15s | %-10s | %-10s | %-12s |", "Name", "AuthID", "IP", "Flags", "Tag", "Expiration");
	console_print(pPlayer, "--------------------------------------------------------------------------------------------------------------");

	for (new bool:isAuthorized, i = 1; i <= MaxClients; i++)
	{
		if (is_user_connected(i))
		{
			if (TrieKeyExists(g_tAuthor, g_pData[i][Name]))
			{
				TrieGetArray(g_tAuthor, g_pData[i][Name], g_authData, sizeof(g_authData));
				isAuthorized = true;
			}
			else if (TrieKeyExists(g_tAuthor, g_pData[i][AuthID]))
			{
				TrieGetArray(g_tAuthor, g_pData[i][AuthID], g_authData, sizeof(g_authData));
				isAuthorized = true;
			}
			else if (TrieKeyExists(g_tAuthor, g_pData[i][IP]))
			{
				TrieGetArray(g_tAuthor, g_pData[i][IP], g_authData, sizeof(g_authData));
				isAuthorized = true;
			}

			if (isAuthorized)
			{
				console_print(pPlayer, "| %-20s | %-20s | %-15s | %-10s | %-10s | %-12s |", 
					g_pData[i][Name], g_pData[i][AuthID], g_pData[i][IP], 
					g_authData[Flags], g_authData[Tag], g_authData[ExpireDate]);
			}
		}
	}
	console_print(pPlayer, "--------------------------------------------------------------------------------------------------------------^n^n");
	return PLUGIN_HANDLED;
}

CheckAuthorization(const pPlayer)
{
	new szPassword[32];
	get_user_info(pPlayer, "_pw", szPassword, charsmax(szPassword));

	if (TrieGetArray(g_tAuthor, g_pData[pPlayer][Name], g_authData, sizeof(g_authData)) || TrieGetArray(g_tAuthor, g_pData[pPlayer][AuthID], g_authData, sizeof(g_authData)) || TrieGetArray(g_tAuthor, g_pData[pPlayer][IP], g_authData, sizeof(g_authData)))
	{
		if ((g_authData[Password][0] && equali(g_authData[Password], szPassword)) || !g_authData[Password][0])
		{
			remove_user_flags(pPlayer);
			set_user_flags(pPlayer, g_authData[Flags][0] ? read_flags(g_authData[Flags]) : ADMIN_USER);
		}
		else if (g_authData[Password][0] && !equali(g_authData[Password], szPassword)) {
			server_cmd("kick #%d ^"Incorrect password^"", get_user_userid(pPlayer));
		}
	}
}


TryPrecachePlayerModel(const szModel[])
{
	new szFile[128];
	formatex(szFile, charsmax(szFile), "models/player/%s/%s.mdl", szModel, szModel);

	if (!file_exists(szFile))
	{
		log_error(AMX_ERR_NOTFOUND, "[DEBUG] Model file '%s' not found.", szFile);
		return 0;
	}

	precache_model(szFile);

	replace_all(szFile, charsmax(szFile), ".mdl", "T.mdl");
	if (file_exists(szFile))
	{
		precache_model(szFile);
	}

	return 1;
}
