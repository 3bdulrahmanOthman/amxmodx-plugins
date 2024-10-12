#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <zombieplague>

new const Version[ ] = "1.0.0";

#if !defined MAX_PLAYERS
    const MAX_PLAYERS = 32
#endif

#if !defined MAX_AUTHID_LENGTH
    const MAX_AUTHID_LENGTH = 64
#endif

enum _:PlayerModels
{ 
    Player_SteamID[ MAX_AUTHID_LENGTH ],
    Player_Model[ 64 ],
    Player_Flags
}

new Trie:g_tModels, eData[ PlayerModels ], g_szSteamID[ MAX_PLAYERS + 1 ][ MAX_AUTHID_LENGTH ];

public plugin_init( ) 
{
    register_plugin( "ZP: Custom Models", Version, "Supremache" )
    register_cvar( "CustomModels", Version, FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED )
    
    g_tModels = TrieCreate( );
    
    RegisterHam( Ham_Spawn, "player", "CBasePlayer_Spawn", 1 );
}

public plugin_precache( ) 
{
    ReloadFile( );
}

public client_connect( id )
{
    get_user_authid( id, g_szSteamID[ id ], charsmax( g_szSteamID[ ] ) )
}

public CBasePlayer_Spawn( id )
{
    if( !is_user_alive( id ) )
    {
        return;
    }
    
    if( TrieGetArray( g_tModels, g_szSteamID[ id ], eData, sizeof eData ) )
    {
        if( eData[ Player_Model ][ 0 ] != EOS && !zp_get_user_zombie( id ) && has_all_flags( id, eData[ Player_Flags ] ) )
        {
            zp_override_user_model( id, eData[ Player_Model ] );
        }
    }
}

ReloadFile( )
{
    new g_szFile[ 128 ]
    
    get_configsdir( g_szFile, charsmax( g_szFile ) );
    add( g_szFile, charsmax( g_szFile ), "/CustomModels.ini" )
    
    new iFile = fopen( g_szFile, "rt" );
    
    if( iFile )
    {
        new szData[ 512 ], szFlags[ 22 ];
        
        while( fgets( iFile, szData, charsmax( szData ) ) )
        {    
            trim( szData );
            
            switch( szData[ 0 ] )
            {
                case EOS, ';', '#', '/': continue;
                default:
                {
                    szFlags[ 0 ] = ADMIN_ALL;
                    
                    parse( szData, eData[ Player_SteamID ], charsmax( eData[ Player_SteamID ] ), eData[ Player_Model ], charsmax( eData[ Player_Model ] ), szFlags, charsmax( szFlags ) ) 
                    
                    if( eData[ Player_SteamID ][ 0 ] )
                    {
                        precache_player_model( eData[ Player_Model ] );
                        eData[ Player_Flags ] = read_flags( szFlags );
                        TrieSetArray( g_tModels, eData[ Player_SteamID ], eData, sizeof eData );
                    }
                    
                    arrayset( eData, 0, sizeof( eData ) );
                }
            } 
        } 
        fclose( iFile );
    }
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
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang3073\\ f0\\ fs16 \n\\ par }
*/
