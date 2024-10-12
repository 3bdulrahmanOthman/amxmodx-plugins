#include <amxmodx>
#include <amxmisc>
#include <fakemeta>

#if !defined MAX_AUTHID_LENGTH
const MAX_AUTHID_LENGTH = 64
#endif

#if !defined MAX_PLAYERS
const MAX_PLAYERS = 32
#endif

new Array:g_aBanTeam

public plugin_init( ) 
{
    register_plugin( "AMX Ban Team", "1.0", "Supremache" )
    register_cvar("AMXBanTeam", "1.0", FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED )
    
    g_aBanTeam = ArrayCreate( MAX_AUTHID_LENGTH );
    
    register_concmd( "amx_banct", "@BanTeam");
    register_concmd( "amx_bant", "@BanTeam" );
    register_concmd( "amx_unbanct", "@UnBanTeam" );
    register_concmd( "amx_unbant", "@UnBanTeam" );
}

public plugin_end( )
{
    ArrayDestroy( g_aBanTeam );
}

@BanTeam( id )
{
    new szCommand[ 10 ], szTeam[ 10 ], szValue[ 3 ], iPlayers[ MAX_PLAYERS ], iPnum;
    read_argv( 0, szCommand, charsmax( szCommand ) )
    read_argv( 1, szValue, charsmax( szValue ) )
    copy( szTeam, charsmax( szTeam ), szCommand[ 7 ] == 'c' ? "CT" : "TERRORIST" )
    
    get_players( iPlayers, iPnum, "e", szTeam )
        
    for( new i, iPlayer; i < iPnum; i++ )
    {
        iPlayer = iPlayers[ i ];
        client_cmd( id, "amx_ban ^"#%d^" ^"%i^"", get_user_userid( iPlayer ), str_to_num( szValue ) )
        ReadFile( iPlayer, szTeam, 1 )
        client_print( id, print_chat, "banned" )
    }
    
    return PLUGIN_HANDLED;
}

@UnBanTeam( id )
{
    
    static szSteamID[ MAX_AUTHID_LENGTH ], szCommand[ 10 ], szTeam[ 10 ];
    read_argv( 0, szCommand, charsmax( szCommand ) )
    copy( szTeam, charsmax( szTeam ), szCommand[ 9 ] == 'c' ? "CT" : "TERRORIST" )
    
    ReadFile( 0, szTeam )
    
    for( new i; i < ArraySize( g_aBanTeam ); i++ )
    {
        ArrayGetString( g_aBanTeam, i, szSteamID, charsmax( szSteamID ) );
        
        client_cmd( id, "amx_unban ^"%s^"", szSteamID )
        ReadFile( 0, szTeam, 2 )
        client_print( id, print_chat, "unbanned" )
    }
    
    return PLUGIN_HANDLED;
}

ReadFile( id = -1, const szTeam[ ] = "", iType = 0)
{
    new szConfigs[ 64 ], szFile[ 96 ], szData[ MAX_AUTHID_LENGTH ], iFile;
    get_configsdir( szConfigs, charsmax( szConfigs ) )
    formatex( szFile, charsmax( szFile ), "%s/BanList_%s.ini", szConfigs, szTeam )
    
    switch( iType )
    {
        case 0:
        {
            iFile = fopen( szFile, "rt" );
    
            if( iFile )
            {
                while( fgets( iFile, szData, charsmax( szData ) ) )
                {   
                    trim( szData );
                
                    switch( szData[ 0 ] )
                    {
                        case EOS, ';', '#', '/': continue;
                        default: ArrayPushString( g_aBanTeam, szData );
                    }
                }
                fclose( iFile );
            }
        }
        
        case 1:
        {
            iFile = fopen( szFile, "wt")
        
            if( iFile && pev_valid( id ) ) 
            {       
                get_user_authid( id, szData, charsmax( szData ) )
                fprintf( iFile, "%s^n", szData )

                fclose( iFile );
            }
        }
        case 2: delete_file( szConfigs );
    }
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang3073\\ f0\\ fs16 \n\\ par }
*/
