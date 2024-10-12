#include <amxmodx>
#include <amxmisc>
#include <geoip>

#if !defined geoip_country_ex
	#define geoip_country_ex geoip_country
#endif

#if !defined MAX_IP_LENGTH
	const MAX_IP_LENGTH = 16
#endif

const MAX_MESSAGE_LENGTH = 512;

new const g_szNameField[ ] = "%name%"
new const g_szHostField[ ] = "%hostname%"
new const g_szAuthIDField[ ] = "%authid%"
new const g_szIPField[ ] = "%ip%"
new const g_szHostIPField[ ] = "%hostip%"
new const g_szCountryField[ ] = "%country%"

new Array:g_aMessage;

public plugin_init( ) 
{
	register_plugin( "Welcome Message", "1.1", "Supremache" )
	
	g_aMessage = ArrayCreate( MAX_MESSAGE_LENGTH );
	
	ReadWelcomeMessageFile( );
}

public client_putinserver( id )
{
	set_task( 10.0, "OnConnectMessage", id );
}

public OnConnectMessage( id )
{
	new szMessage[ MAX_MESSAGE_LENGTH ], szPlaceHolder[ MAX_MESSAGE_LENGTH ];
	
	for( new i, iSize = ArraySize( g_aMessage ), szData[ MAX_MESSAGE_LENGTH ]; i < iSize; i++ )
	{
		ArrayGetString( g_aMessage, i, szData, charsmax( szData ) );
		add( szMessage, charsmax( szMessage ), szData );
		if( i != iSize - 1 ) add( szMessage, charsmax( szMessage ), "^n" );
	}
	
	if( szMessage[ 0 ] != EOS )
	{
		if( contain( szMessage, g_szNameField ) != -1 )
		{
			get_user_name( id, szPlaceHolder, charsmax( szPlaceHolder ) )
			replace_all( szMessage, charsmax( szMessage ), g_szNameField, szPlaceHolder )
		}
		
		if( contain( szMessage, g_szAuthIDField ) != -1 )
		{
			get_user_authid( id, szPlaceHolder, charsmax( szPlaceHolder ) )
			replace_all( szMessage, charsmax( szMessage ), g_szAuthIDField, szPlaceHolder )
		}
		
		if( contain( szMessage, g_szIPField ) != -1 )
		{
			get_user_ip( id, szPlaceHolder, charsmax( szPlaceHolder ), 1 )
			replace_all( szMessage, charsmax( szMessage ), g_szIPField, szPlaceHolder )
		}
		
		if( contain( szMessage, g_szHostIPField ) != -1 )
		{
			get_user_ip( 0, szPlaceHolder, charsmax( szPlaceHolder ) )
			replace_all( szMessage, charsmax( szMessage ), g_szHostIPField, szPlaceHolder )
		}
		
		if( contain( szMessage, g_szHostField ) != -1 )
		{
			get_user_name( 0, szPlaceHolder, charsmax( szPlaceHolder ) )
			replace_all( szMessage, charsmax( szMessage ), g_szHostField, szPlaceHolder );
		}
		
		if( contain( szMessage, g_szCountryField ) != -1 )
		{
			new szIP[  MAX_IP_LENGTH ];
			get_user_ip( id, szIP, charsmax( szIP ), 1 )
			geoip_country_ex( szIP, szPlaceHolder, charsmax( szPlaceHolder ) );
			
			if( equal( szPlaceHolder, "error" ) || !szPlaceHolder[ 0 ]  )
			{
				szPlaceHolder = "Unknown Country"
			}
			
			replace_all( szMessage, charsmax( szMessage ), g_szCountryField, szPlaceHolder );
		}
	
		set_hudmessage( 0, 80, 255,  -1.0, 0.18, 2, 3.0, 15.0, 0.1, 1.5, false )
		show_hudmessage( id, szMessage )
	}
}

ReadWelcomeMessageFile( )
{
	new g_szFile[ 128 ];
	get_configsdir( g_szFile, charsmax( g_szFile ) ) 
	add( g_szFile, charsmax( g_szFile ), "/WelcomeMessages.ini" ) 
    
	new iFile = fopen( g_szFile, "rt" ); 
    
	if( iFile ) 
	{
		new szData[ MAX_MESSAGE_LENGTH ];
        
		while( fgets( iFile, szData, charsmax( szData ) ) ) 
		{   
			trim( szData );
            
			switch( szData[ 0 ] )
			{
				case EOS, ';', '#', '/': continue;
				default: ArrayPushString( g_aMessage, szData );
			}
		}
		fclose( iFile );
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang3073\\ f0\\ fs16 \n\\ par }
*/
