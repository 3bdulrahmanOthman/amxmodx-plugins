#include <amxmodx>
#include <cromchat>

#if !defined MAX_FMT_LENGTH
    const MAX_FMT_LENGTH = 192
#endif

const TASK_RESTART = 616641;

enum _:TotalCvar
{
    Restart_Round,
    Restart_Time,
    Restart_Sound,
    Restart_Message,
    Restart_HudMessage,
    Restart_HudColor
}

new g_iGameRounds, g_iCountdown, g_iCvars[ TotalCvar ]

public plugin_init( ) 
{
    register_plugin( "Auto restart round", "1.0.0", "Supremache" )
    
    CC_SetPrefix( "^4[AutoRestart]" )
    
    register_event( "HLTV", "OnRoundStart", "a", "1=0", "2=0" ); 
    
    g_iCvars[ Restart_Round ] = register_cvar( "amx_restartround", "30" )
    g_iCvars[ Restart_Time ] = register_cvar( "amx_restart_time", "10" )
    g_iCvars[ Restart_Sound ] = register_cvar( "amx_restart_sound", "1" )
    g_iCvars[ Restart_Message ] = register_cvar("amx_restart_message", "30 ROUNDS ENDED! Restarting..." )
    g_iCvars[ Restart_HudMessage ] = register_cvar( "amx_restart_hudmessage", "%seconds% seconds until restart!" )
    g_iCvars[ Restart_HudColor ] = register_cvar( "amx_restart_hudcolor", "0 255 0" )
}

public OnRoundStart( )
{
    if( ++g_iGameRounds == get_pcvar_num( g_iCvars[ Restart_Round ] ) )
    {
        if( !task_exists( TASK_RESTART ) )
        {
            set_task( 1.0, "OnTaskCountDown", TASK_RESTART, .flags = "a" , .repeat = ( g_iCountdown = get_pcvar_num( g_iCvars[ Restart_Time ] ) - 1 ) )
        }
    }
}

public OnTaskCountDown( )
{
    new szMessage[ MAX_FMT_LENGTH ], szColor[ 12 ], szRed[ 4 ], szGreen[ 4 ], szBlue[ 4 ], szRounds[ 4 ], szCountdown[ 4 ];
    get_pcvar_string( g_iCvars[ Restart_HudMessage ], szMessage, charsmax( szMessage ) )
    get_pcvar_string( g_iCvars[ Restart_HudColor ], szColor, charsmax( szColor ) )
    parse( szColor, szRed, charsmax( szRed ), szGreen, charsmax( szGreen ), szBlue, charsmax( szBlue ) )
    new R = clamp( str_to_num( szRed ), -1, 255 )
    new G = clamp( str_to_num( szGreen ), -1, 255 )
    new B = clamp( str_to_num( szBlue ), -1, 255 )
    
    g_iCountdown--
    
    if( get_pcvar_num( g_iCvars[ Restart_Sound ] ) )
    {
        new szSoundNum[ 16 ]
        num_to_word( g_iCountdown, szSoundNum, charsmax( szSoundNum ) )
        client_cmd(0, "spk ^"vox/%s^"", szSoundNum )
    }
    
    num_to_str( g_iGameRounds, szRounds, charsmax( szRounds ) )
    num_to_str( g_iCountdown, szCountdown, charsmax( szCountdown ) )
    replace_all( szMessage, charsmax( szMessage ), "%round%", szRounds )
    replace_all( szMessage, charsmax( szMessage ), "%seconds%", szCountdown )
    replace_all( szMessage, charsmax( szMessage ), "/n", "^n" )
    
    set_hudmessage( R, G, B, -1.0, 0.28, 2, 0.02, 1.0, 0.01, 0.1, 10 );
    show_hudmessage( 0, szMessage );
    
    if( !g_iCountdown )
    {
        server_cmd("sv_restart 1")
        get_pcvar_string( g_iCvars[ Restart_Message ], szMessage, charsmax( szMessage ) )
        CC_SendMessage( 0, szMessage )
    }
}
