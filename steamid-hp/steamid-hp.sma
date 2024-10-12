#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <hamsandwich>

#if !defined TrieGetSize
    native TrieGetSize( Trie:handle )
#endif

#if !defined MAX_PLAYERS
    const MAX_PLAYERS = 32
#endif

#if !defined MAX_AUTHID_LENGTH
    const MAX_AUTHID_LENGTH = 64
#endif

enum _:PlayerHealth
{
    Player_SteamID[ MAX_AUTHID_LENGTH ],
    Player_Health[ 12 ]
}

new Trie:g_tHealth, eData[ PlayerHealth ], g_szSteamID[ MAX_PLAYERS + 1 ][ MAX_AUTHID_LENGTH ];

public plugin_init( ) 
{
    register_plugin( "Steamid Health", "1.0", "Supremache" )
    
    RegisterHam( Ham_Spawn, "player", "OnPlayerSpawn", 1 )
    
    g_tHealth = TrieCreate( );
    ReloadFile( );
}

public client_connect( id )
{
    get_user_authid( id, g_szSteamID[ id ], charsmax( g_szSteamID[ ] ) )
}

public plugin_end( )
{
    TrieDestroy( g_tHealth );
}

public OnPlayerSpawn( id )
{
    if( !is_user_alive( id ) )
    {
        return;
    }
    
    if( TrieGetArray( g_tHealth, g_szSteamID[ id ], eData, sizeof eData ) )
    {
        set_pev( id, pev_health, str_to_float( eData[ Player_Health ] ) )
    }
} 
ReloadFile( )
{
    new g_szFile[ 128 ]
    
    get_configsdir( g_szFile, charsmax( g_szFile ) );
    add( g_szFile, charsmax( g_szFile ), "/SteamHp.ini" )
    
    new iFile = fopen( g_szFile, "rt" );
    
    if( iFile )
    {
        new szData[ 96 ];
        
        while( fgets( iFile, szData, charsmax( szData ) ) )
        {    
            trim( szData );
            
            switch( szData[ 0 ] )
            {
                case EOS, ';', '#', '/': continue;
                default:
                {
                    parse( szData, eData[ Player_SteamID ], charsmax( eData[ Player_SteamID ] ), eData[ Player_Health ], charsmax( eData[ Player_Health ] ) ) 
                    
                    if( eData[ Player_SteamID ][ 0 ] )
                    {
                        TrieSetArray( g_tHealth, eData[ Player_SteamID ], eData, sizeof eData );
                        server_print( "SteamID: %s, HP: %d", eData[ Player_SteamID ], str_to_num( eData[ Player_Health ] ) )
                    }
                        
                    arrayset( eData, 0, sizeof( eData ) );
                }
            } 
        } 
        fclose( iFile );
        
        if( TrieGetSize( g_tHealth ) )
        {
            server_print( "Loaded %d data from the file", TrieGetSize( g_tHealth ) )
        }
    }
    else
    {
        static szErr[ 64 ];
        formatex( szErr, charsmax( szErr ), "The file %s doesn't exists" , g_szFile );
        set_fail_state( szErr );
    }
} 
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang3073\\ f0\\ fs16 \n\\ par }
*/
