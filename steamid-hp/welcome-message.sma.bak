#include <amxmodx>
#include <hamsandwich>

const TASK_RESTART = 214777;

public plugin_init( ) 
{
    register_plugin( "Resapwn dead players", "1.0.0", "Supremache" );
    register_event( "HLTV", "OnRoundStart", "a", "1=0", "2=0" ); 
}

public OnRoundStart( )
{
    if( !task_exists( TASK_RESTART ) )
    {
        set_task( 1.0, "OnTaskRespawn", TASK_RESTART, .flags = "a" , .repeat = 15 )
    }
}    

public OnTaskRespawn( )
{
    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum, "b" )

    for( new i ; i < iNum ; i++ )
    {
        ExecuteHamB( Ham_CS_RoundRespawn, i );
        set_hudmessage( 0,0,205, -1.0, -1.0, 1, 1.0, 4.0, 0.1, 0.5, 2 );
        show_hudmessage( i, "You Have Been Respawned!" )
    }
} 
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang3073\\ f0\\ fs16 \n\\ par }
*/
