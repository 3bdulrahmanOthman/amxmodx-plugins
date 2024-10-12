#include <amxmodx>
#include <hamsandwich>
#include <cstrike>
#include <amxmisc>


new const g_szModelFile[ ] = "CustomModels.ini";

enum _:ModelData
{ 
	Model_Name[ 64 ],
	Model_Flag[ 32 ],
	CsTeams:Model_Team
}

new Array:g_aModels, eModel[ ModelData ]

public plugin_init( ) 
{
	register_plugin( "Custom Models", "1.0.2", "Supremache" );
	RegisterHam( Ham_Spawn, "player", "CBasePlayer_Spawn", 1 )
    
	if( ArraySize( g_aModels ) )
	{
		server_print( "[Custom Models] Loaded %d models", ArraySize( g_aModels ) )
	}
}

public plugin_precache() 
{
	g_aModels = ArrayCreate( ModelData );
	ReadFile( );
}
    
public CBasePlayer_Spawn( id )
{
	if( is_user_alive( id ) )
	{
		for( new CsTeams:iTeam = cs_get_user_team( id ), i; i < ArraySize( g_aModels ); i++ )
		{
			ArrayGetArray( g_aModels, i, eModel )
			
			if( ( !eModel[ Model_Team ] || iTeam == eModel[ Model_Team ] ) && has_all_flags( id , eModel[ Model_Flag ] ) )
			{
				cs_set_user_model( id, eModel[ Model_Name ] )
				break;
			}
			else cs_reset_user_model( id );
		}
	}
}

ReadFile( )
{
	new g_szFile[ 128 ], g_szConfigs[ 64 ];
	get_configsdir( g_szConfigs, charsmax( g_szConfigs ) )
	formatex( g_szFile, charsmax( g_szFile ), "%s/%s", g_szConfigs, g_szModelFile )
    
	new iFile = fopen( g_szFile, "rt" );
    
	if( iFile )
	{
		new szData[ 512 ], szModel[ 64 ], szTeam[ 32 ];
        
		while( fgets( iFile, szData, charsmax( szData ) ) )
		{    
			trim( szData );
            
			switch( szData[ 0 ] )
			{
				case EOS, ';',  '#', '/': continue;

				default:
				{
					eModel[ Model_Flag ][ 0 ] = EOS;
					szTeam[ 0 ] = EOS;
                    
					parse ( szData, szModel, charsmax( szModel ), eModel[ Model_Flag ], charsmax( eModel[ Model_Flag ] ), szTeam, charsmax( szTeam ) )
                    
					trim( szModel ); trim( szTeam ); trim( eModel[ Model_Flag ] );

					precache_player_model( szModel )
					copy( eModel[ Model_Name ], charsmax( eModel[ Model_Name ] ), szModel );
					
					eModel[ Model_Team ] = CsTeams:clamp( str_to_num( szTeam ), _:CS_TEAM_UNASSIGNED, _:CS_TEAM_SPECTATOR );
					
					ArrayPushArray( g_aModels, eModel );
				}
			}
		}
		fclose( iFile );
	}
	else log_amx( "ERROR: ^"%s^" not found!", g_szFile )
} 

//Credits to OciXCrom
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
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang3073\\ f0\\ fs16 \n\\ par }
*/
