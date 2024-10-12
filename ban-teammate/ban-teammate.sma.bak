#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <nvault>
#include <sqlx>
#include <cromchat>

/* You can make this plugin work with Ammo Packs,
 * BaseBuilder Credits, JBPacks, Points and more */

#define get_cash(%1) cs_get_user_money(%1)
#define set_cash(%1,%2) cs_set_user_money(%1, %2) 

#if !defined client_disconnected
	#define client_disconnected client_disconnect
#endif

#if !defined MAX_PLAYERS
	const MAX_PLAYERS = 32
#endif

#if !defined MAX_MENU_LENGTH
	const MAX_MENU_LENGTH = 512
#endif

#if !defined MAX_NAME_LENGTH
	const MAX_NAME_LENGTH = 32
#endif

#if !defined MAX_AUTHID_LENGTH
	const MAX_AUTHID_LENGTH = 64
#endif

#if !defined MAX_IP_LENGTH
	const MAX_IP_LENGTH = 16
#endif
  
const MAX_QUERY_LENGTH = 256;
const MAX_CASH_LENGTH = 16;

new const g_iFile[ ] = "BankSystem.ini";
new const Version[ ] = "2.0";

enum _:SaveTypes
{
	NICKNAME,
	IP,
	STEAMID
}

enum _:SaveMethods
{
	Nvault,
	MySQL,
	SQLite
}

enum eSettings
{
	PREFIX_CHAT[ MAX_NAME_LENGTH ],
	SQL_HOST[ MAX_NAME_LENGTH ],
	SQL_USER[ MAX_NAME_LENGTH ],
	SQL_PASS[ MAX_NAME_LENGTH ],
	SQL_DATABASE[ MAX_NAME_LENGTH ],
	SQL_TABLE[ MAX_NAME_LENGTH ],
	NVAULT_DATABASE[ MAX_NAME_LENGTH ],
	USE_SQL,
	SAVE_TYPE,
	MAX_CASH,
	MAX_CASH_SAVE,
	MENU_DONATE_ACCESS,
	MENU_RESET_ACCESS,
}

enum PlayerData
{
	SaveInfo[ MAX_AUTHID_LENGTH ],
	Bank,
	Donate,
	bool:BotOrHLTV
}

new g_iPlayer[ MAX_PLAYERS + 1 ][ PlayerData ],
	g_iSettings[ eSettings ],
	g_iFUserNameChanged,
	Handle:g_SQLTuple,
	g_szSQLError[ MAX_QUERY_LENGTH ],
	g_iVault;
	
public plugin_init( ) 
{
	register_plugin( "Bank System", Version, "Supremache" );
	register_cvar( "BankSystem", Version, FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED );
	
	register_clcmd( "EnterAmount", "@OnPlayerDonations" );
	register_clcmd( "DepositCash", "@OnDepositCash" );
	register_clcmd( "TakeCash", "@OnWithdrawCash" );
	
	register_event( "SayText", "OnSayText", "a", "2=#Cstrike_Name_Change" )
	
	ReadFile( );
	
	switch( g_iSettings[ USE_SQL ] )
	{
		case Nvault:
		{
			if ( ( g_iVault = nvault_open( g_iSettings[ NVAULT_DATABASE ] ) ) == INVALID_HANDLE )
				set_fail_state("BANK: Failed to open the vault.");
		}
		case MySQL, SQLite: 
		{
			if( g_iSettings[ USE_SQL ] == SQLite )
				SQL_SetAffinity( "sqlite" );
				
			g_SQLTuple = SQL_MakeDbTuple( g_iSettings[ SQL_HOST ], g_iSettings[ SQL_USER ], g_iSettings[ SQL_PASS ], g_iSettings[ SQL_DATABASE ] );
			    
			new szQuery[ MAX_QUERY_LENGTH ], Handle:SQLConnection, iErrorCode;
			SQLConnection = SQL_Connect( g_SQLTuple, iErrorCode, g_szSQLError, charsmax( g_szSQLError ) );
			    
			if( SQLConnection == Empty_Handle )
				set_fail_state( g_szSQLError );
	
			formatex( szQuery, charsmax( szQuery ), "CREATE TABLE IF NOT EXISTS `%s` (`Player` VARCHAR(%i) NOT NULL,\
			`Cash` INT(%i) NOT NULL, PRIMARY KEY(Player));", g_iSettings[ SQL_TABLE ], MAX_AUTHID_LENGTH, MAX_CASH_LENGTH );
			
			RunQuery( SQLConnection, szQuery, g_szSQLError, charsmax( g_szSQLError ) );
		}
	}
}

public OnSayText( iMsg, iDestination, iEntity )
{
	g_iFUserNameChanged = register_forward(FM_ClientUserInfoChanged, "OnNameChange", 1 )
}

public OnNameChange( id )
{
	if( !is_user_connected( id ) )
	{
		return;
	}

	new szName[ MAX_NAME_LENGTH ]
	get_user_name( id, szName, charsmax( szName ) )

	if( g_iSettings[ SAVE_TYPE ] == NICKNAME )
	{
		ReadData( id );
		copy( g_iPlayer[ id ][ SaveInfo ], charsmax( g_iPlayer[ ][ SaveInfo ] ), szName )

		if( g_iSettings[ USE_SQL ] != Nvault )
		{
			ResetData( id )
		}

		ReadData( id, false );
	}

	unregister_forward( FM_ClientUserInfoChanged, g_iFUserNameChanged , 1 )
}

public client_connect( id )
{
	if ( !( g_iPlayer[ id ][ BotOrHLTV ] = bool:( is_user_bot( id ) || is_user_hltv( id ) ) ) )
	{
		ResetData( id )
		
		switch( g_iSettings[ SAVE_TYPE ] )
		{
			case NICKNAME: get_user_name( id, g_iPlayer[ id ][ SaveInfo ], charsmax( g_iPlayer[ ][ SaveInfo ] ) )
			case IP:       get_user_ip( id, g_iPlayer[ id ][ SaveInfo ], charsmax( g_iPlayer[ ][ SaveInfo ]), 1 )
			case STEAMID:  get_user_authid( id, g_iPlayer[ id ][ SaveInfo ], charsmax( g_iPlayer[ ][ SaveInfo ] ) )
		}
		
		ReadData( id, false );
	}
}

public client_disconnected( id )
{
	if ( !g_iPlayer[ id ][ BotOrHLTV ] )
	{
		ReadData( id );
	}
}

@BankMenu( id )
{
	new iMenu = menu_create( "\yBank System: \r[Protected]", "@BankHandler" );
	
	menu_additem( iMenu, "Deposit" );
	menu_additem( iMenu, "Deposit All^n" );
	menu_additem( iMenu, "Withdraw" );
	menu_additem( iMenu, "Withdraw All^n" );
	menu_additem( iMenu, "Bank balance" );
	menu_additem( iMenu, "Donate" );
	menu_additem( iMenu, "Reset Bank" );
	
	menu_display(id, iMenu)
	return PLUGIN_HANDLED;
}

@BankHandler( id, iMenu, iItem ) 
{
	if( iItem != MENU_EXIT ) 
	{
		switch(iItem) 
		{
			case 0: 
			{
				client_cmd( id, "messagemode DepositCash" );
				set_hudmessage( 255, 255, 85, 0.01, 0.18, 2, 0.5, 6.0, 0.05, 0.05, -1 );
				show_hudmessage(id, " Type how much you want to deposit." );
			}
			case 1: @OnDepositAllCash( id );
			case 2: 
			{
				client_cmd( id, "messagemode TakeCash" );
				set_hudmessage( 255, 255, 85, 0.01, 0.18, 2, 0.5, 6.0, 0.05, 0.05, -1 );
				show_hudmessage( id, "Type how much you want to withdraw." );
			}
			case 3: @OnWithdrawAllCash( id );
			case 4: CC_SendMessage( id,"Your Cash is:^4 %d", g_iPlayer[ id ][ Bank ] );
			case 5: @DonateMenu( id );
			case 6: @ResetMenu( id );
		}
	}
	menu_destroy( iMenu );
	return PLUGIN_HANDLED;
}

@DonateMenu( id )
{		
	if( ~get_user_flags( id ) & g_iSettings[ MENU_DONATE_ACCESS ] )
	{
		CC_SendMessage(id, "You don't have access to this command.");
		return PLUGIN_HANDLED;
	}
		
	new szPlayers[ MAX_PLAYERS ], iNum, szID[ MAX_PLAYERS ], szName[ MAX_NAME_LENGTH ];
			
	new iMenu = menu_create( "Players List:", "@DonateHandler" );
	get_players( szPlayers, iNum, "ch" );
	
	for( new iPlayer, i; i < iNum; i++ )
	{
		if( ( iPlayer = szPlayers[ i ] ) != id )
		{
			num_to_str( iPlayer, szID, charsmax( szID ) );
			get_user_name( iPlayer, szName, charsmax( szName ) );
			menu_additem( iMenu, szName, szID )
		}
	}
	menu_display( id, iMenu );
	return PLUGIN_HANDLED;
}

@DonateHandler( id, iMenu, iItem ) 
{
	if(iItem != MENU_EXIT) 
	{
		new szData[ 10 ], iUnused;
		menu_item_getinfo( iMenu, iItem, iUnused, szData, charsmax( szData ), .callback = iUnused )
		
		g_iPlayer[ id ][ Donate ] = find_player( "k", str_to_num( szData ) ); 

		if ( ! g_iPlayer[ id ][ Donate ] )
		{
			CC_SendMessage( id,"This player does not exist." );
			return PLUGIN_HANDLED;
		}
		
		client_cmd(id, "messagemode EnterAmount");
		
		set_hudmessage( 255, 255, 85, 0.01, 0.18, 2, 0.5, 6.0, 0.05, 0.05, -1 );
		show_hudmessage( id, "Type how much you want to give." );
	}
	menu_destroy(iMenu);
	return PLUGIN_HANDLED;
}

@OnPlayerDonations( id )
{
	new szValue[ MAX_CASH_LENGTH ], szPlayerName[ MAX_NAME_LENGTH ], szTargetName[ MAX_NAME_LENGTH ];
	read_argv( 1, szValue, charsmax( szValue ) );
	
	new iValue = str_to_num( szValue ), iCash = get_cash( id ), iPlayer = g_iPlayer[ id ][ Donate ]; 

	if( iCash < iValue || iValue <= 0 )
	{
		CC_SendMessage( id,"You do not have enough cash or invalid value." );
		return PLUGIN_CONTINUE;
	}
	
	if( !iPlayer )
	{
		CC_SendMessage( id,"This player does not exist." );
		return PLUGIN_CONTINUE;
	}
	
	get_user_name( id, szPlayerName, charsmax( szPlayerName ) );
	get_user_name( iPlayer, szTargetName, charsmax( szTargetName ) );
	
	set_cash( id, iCash - iValue )
	set_cash( iPlayer, get_cash( iPlayer ) + iValue )
	
	CC_SendMessage(0,"Player^4 %s^1 donated^4 $%d^1 for^4 %s.", szPlayerName, iValue, szTargetName );
	client_cmd(iPlayer, "spk ^"items/9mmclip1.wav^"")
	ReadData( id );
	
	return PLUGIN_HANDLED;
} 

@ResetMenu( id )
{		
	if( ~get_user_flags( id ) & g_iSettings[ MENU_RESET_ACCESS ] )
	{
		CC_SendMessage(id, "You don't have access to this command.");
		return PLUGIN_HANDLED;
	}
		
	new szPlayers[ MAX_PLAYERS ], iNum, szID[ MAX_PLAYERS ], szName[ MAX_NAME_LENGTH ];
			
	new iMenu = menu_create( "Players List:", "@ResetHandler" );
	get_players( szPlayers, iNum, "ch" );
	
	for( new iPlayer, i; i < iNum; i++ )
	{
		if( ( iPlayer = szPlayers[ i ] ) != id )
		{
			num_to_str( iPlayer, szID, charsmax( szID ) );
			get_user_name( iPlayer, szName, charsmax( szName ) );
			menu_additem( iMenu, szName, szID )
		}
	}
	menu_display( id, iMenu );
	return PLUGIN_HANDLED;
}

@ResetHandler( id, iMenu, iItem ) 
{
	if(iItem != MENU_EXIT) 
	{
		new szData[ 10 ], iUnused, szPlayerName[ MAX_NAME_LENGTH ], szTargetName[ MAX_NAME_LENGTH ];
		menu_item_getinfo( iMenu, iItem, iUnused, szData, charsmax( szData ), .callback = iUnused )
		
		new iPlayer = find_player( "k", str_to_num( szData ) ); 
		
		if( !iPlayer )
		{
			CC_SendMessage( id,"This player does not exist." );
			return PLUGIN_HANDLED;
		}
		
		get_user_name( id, szPlayerName, charsmax( szPlayerName ) );
		get_user_name( iPlayer, szTargetName, charsmax( szTargetName ) );
	
		g_iPlayer[ iPlayer ][ Bank ] = 0;
		CC_SendMessage( 0,"[ADMIN]^4 %s:^1 reset bank of^4 %s.", szPlayerName, szTargetName );
		ReadData( id );
	}
	menu_destroy(iMenu);
	return PLUGIN_HANDLED;
}

@OnDepositAllCash( id ) 
{
	new iCash = clamp( get_cash( id ), 0, g_iSettings[ MAX_CASH_SAVE ] );
	
	if( iCash <= 0)
	{
		CC_SendMessage(id,"You do not have enough cash or invalid value.");
		return PLUGIN_CONTINUE;
	}
	
	if( g_iPlayer[ id ][ Bank ] > g_iSettings[ MAX_CASH_SAVE ] )
	{
		CC_SendMessage( id,"Your bank is full." );
		return PLUGIN_CONTINUE;
	}

	g_iPlayer[ id ][ Bank ] += iCash;
	set_cash(id, iCash - get_cash( id ) );
	CC_SendMessage( id,"You have deposit^4 %i", iCash );
	ReadData( id );
	return PLUGIN_HANDLED;
}

@OnWithdrawAllCash( id )
{
	new iCash = get_cash( id );
	
	if( g_iPlayer[ id ][ Bank ] <= 0 )
	{
		CC_SendMessage(id,"You do not have enough cash or invalid value.");
		return PLUGIN_CONTINUE;
	}
	
	new iMax = max( iCash, g_iSettings[ MAX_CASH ] );
	
	if( g_iSettings[ MAX_CASH ] && g_iPlayer[ id ][ Bank ] > iMax )
	{
		set_cash(id, iCash + iMax );
		g_iPlayer[ id ][ Bank ] -= iMax;
		CC_SendMessage( id,"You have withdraw^4 %i", iMax );
	}
	else
	{
		CC_SendMessage( id,"You have withdraw^4 %i", g_iPlayer[ id ][ Bank ] );
		set_cash( id, iCash + g_iPlayer[ id ][ Bank ] );
		g_iPlayer[ id ][ Bank ] = 0;
	}
	
	ReadData( id );

	return PLUGIN_HANDLED;
}

@OnDepositCash( id ) 
{
	new szValue[ MAX_CASH_LENGTH ];
	read_argv( 1, szValue, charsmax( szValue ) );
	new iValue = clamp( str_to_num( szValue ), 0, g_iSettings[ MAX_CASH_SAVE ] ), iCash = get_cash( id );
	
	if( iCash < iValue || iValue <= 0)
	{
		CC_SendMessage(id,"You do not have enough cash or invalid value.");
		return PLUGIN_CONTINUE;
	}

	if( g_iPlayer[ id ][ Bank ] > g_iSettings[ MAX_CASH_SAVE ] )
	{
		CC_SendMessage( id,"Your bank is full." );
		return PLUGIN_CONTINUE;
	}
	
	g_iPlayer[ id ][ Bank ] += iValue;
	set_cash( id, iCash - iValue );
	CC_SendMessage(id,"You have deposit^4 %i", iValue );
	ReadData( id );
	
	return PLUGIN_HANDLED;
}

@OnWithdrawCash( id )
{
	new szValue[ MAX_CASH_LENGTH ];
	read_argv( 1, szValue, charsmax( szValue ) );
	new iValue = g_iSettings[ MAX_CASH ] ? clamp( str_to_num( szValue ), 0, g_iSettings[ MAX_CASH ] ) : str_to_num( szValue )
	new iCash = get_cash( id );
	
	if( g_iPlayer[ id ][ Bank ] < iValue || iValue <= 0 )
	{
		CC_SendMessage(id,"You do not have enough cash or invalid value.");
		return PLUGIN_CONTINUE;
	}
	
	g_iPlayer[ id ][ Bank ] -= iValue;
	set_cash( id, iCash + iValue );
	CC_SendMessage( id,"You have withdraw^4 %i", iValue );
	ReadData( id );
	
	return PLUGIN_HANDLED;
}

ReadFile( )
{
	new szConfings[ 128 ], szFile[ 128 ];
	get_configsdir( szConfings, charsmax( szConfings ) )
	formatex( szFile, charsmax( szFile ), "%s/%s", szConfings, g_iFile );
	
	new iFile = fopen( szFile, "rt" );
	
	if( iFile )
	{
		new szData[ 256 ], szKey[ 32 ], szValue[ 128 ];
			
		while( fgets( iFile, szData, charsmax( szData ) ) )
		{
			trim( szData );
			
			switch( szData[ 0 ] )
			{
				case EOS, '#', ';', '/', '[': continue;
				default:
				{
					strtok( szData, szKey, charsmax( szKey ), szValue, charsmax( szValue ), '=' );
					trim( szKey ); trim( szValue );
                            
					if( !szValue[ 0 ] || !szKey[ 0 ] )
						continue;
						
					if( equal( szKey, "BANK_MENU" ) )
					{
						while( szValue[ 0 ] != 0 && strtok( szValue, szKey, charsmax( szKey ), szValue, charsmax( szValue ), ',' ) )
						{
							trim( szKey ); trim( szValue );
							register_clcmd( szKey, "@BankMenu" );
						}
					}
					else if( equal( szKey, "PREFIX_CHAT" ) )
					{
						copy( g_iSettings[ PREFIX_CHAT ], charsmax( g_iSettings[ PREFIX_CHAT ] ), szValue );
					}
					else if(equal(szKey, "SQL_HOST"))
					{
						copy( g_iSettings[SQL_HOST], charsmax( g_iSettings[SQL_HOST] ), szValue );
					}
					else if(equal(szKey, "SQL_USER"))
					{
						copy( g_iSettings[ SQL_USER ], charsmax( g_iSettings[ SQL_USER ] ), szValue );
					}
					else if(equal(szKey, "SQL_PASS"))
					{
						copy( g_iSettings[ SQL_PASS ], charsmax( g_iSettings[ SQL_PASS ] ), szValue );
					}
					else if(equal(szKey, "SQL_DATABASE"))
					{
						copy( g_iSettings[ SQL_DATABASE ], charsmax( g_iSettings[ SQL_DATABASE ] ), szValue );
					}
					else if(equal(szKey, "SQL_TABLE"))
					{
						copy( g_iSettings[ SQL_TABLE ], charsmax( g_iSettings[ SQL_TABLE ] ), szValue );
					}
					else if(equal(szKey, "NVAULT_DATABASE"))
					{
						copy( g_iSettings[ NVAULT_DATABASE ], charsmax( g_iSettings[ NVAULT_DATABASE ] ), szValue );
					}
					else if( equal(szKey, "SAVE_METHOD") )
					{
						g_iSettings[ USE_SQL ] = clamp( str_to_num( szValue ), Nvault, SQLite );
					}
					else if( equal( szKey, "SAVE_TYPE" ) )
					{
						g_iSettings[ SAVE_TYPE ] = clamp( str_to_num( szValue ), NICKNAME, STEAMID );
					}
					else if( equal( szKey, "MAX_CASH" ) )
					{
						g_iSettings[ MAX_CASH ] = str_to_num( szValue );
					}
					else if( equal( szKey, "MAX_CASH_SAVE" ) )
					{
						g_iSettings[ MAX_CASH_SAVE ] = str_to_num( szValue );
					}
					else if( equal( szKey, "MENU_RESET_ACCESS" ) )
					{
						g_iSettings[ MENU_RESET_ACCESS ] = szValue[ 0 ] == '0' ? ADMIN_ALL : read_flags( szValue );
					}
					else if( equal( szKey, "MENU_DONATE_ACCESS" ) )
					{
						g_iSettings[ MENU_DONATE_ACCESS ] = szValue[ 0 ] == '0' ? ADMIN_ALL : read_flags( szValue );
					}
				}
			}
		}
		fclose( iFile )
	}
	else log_amx( "File %s does not exists", szFile )
	
	CC_SetPrefix( g_iSettings[ PREFIX_CHAT ] );
}

ReadData( id, bool:bSave = true )
{
	new szQuery[ MAX_QUERY_LENGTH ];

	if( bSave )
	{
		switch( g_iSettings[ USE_SQL ] )
		{
			case Nvault:
			{
				new szValue[ MAX_CASH_LENGTH ];
				num_to_str( g_iPlayer[ id ][ Bank ], szValue, charsmax( szValue ) )
				nvault_set( g_iVault, g_iPlayer[ id ][ SaveInfo ], szValue );
			}
			case MySQL, SQLite:
			{
				formatex( szQuery , charsmax( szQuery ), "REPLACE INTO `%s` (`Player`, `Cash`) VALUES ('%s', '%i');",\
				g_iSettings[ SQL_TABLE ], g_iPlayer[ id ][ SaveInfo ], g_iPlayer[ id ][ Bank ] );
				SQL_ThreadQuery( g_SQLTuple, "QueryHandle", szQuery );
			}
		}
	}
	else
	{
		switch( g_iSettings[ USE_SQL ] )
		{
			case Nvault: g_iPlayer[ id ][ Bank ] = nvault_get( g_iVault, g_iPlayer[ id ][ SaveInfo ] );
			case MySQL, SQLite:
			{
				formatex( szQuery , charsmax( szQuery ), "SELECT Cash FROM `%s` WHERE Player = '%s';",\
				g_iSettings[ SQL_TABLE ], g_iPlayer[ id ][ SaveInfo ] );
				new szData[ 1 ]; szData[ 0 ] = id
				SQL_ThreadQuery( g_SQLTuple, "QueryHandle", szQuery, szData, sizeof( szData ) );
			}
		}
	}
}

RunQuery( Handle:SQLConnection, const szQuery[ ], szSQLError[ ], iErrLen )
{
	new Handle:iQuery = SQL_PrepareQuery( SQLConnection , szQuery );
	
	if( !SQL_Execute( iQuery ) )
	{
		SQL_QueryError( iQuery, szSQLError, iErrLen );
		set_fail_state( szSQLError );
	}
	
	SQL_FreeHandle( iQuery );
}

public QueryHandle( iFailState, Handle:iQuery, const szError[ ], iErrCode, const szData[ ], iDataSize )
{
	switch( iFailState )
	{
		case TQUERY_CONNECT_FAILED: { log_amx( "[SQL Error] Connection failed (%i): %s", iErrCode, szError ); return; }
		case TQUERY_QUERY_FAILED: { log_amx( "[SQL Error] Query failed (%i): %s", iErrCode, szError ); return; }
	}
    
	if( SQL_NumResults( iQuery ) )
	{
		g_iPlayer[ szData[ 0 ] ][ Bank ] = SQL_ReadResult( iQuery , 0 );
	}
} 

ResetData( const id )
{
	g_iPlayer[ id ][ Bank ] = 0;
	g_iPlayer[ id ][ Donate ] = 0;
	g_iPlayer[ id ][ BotOrHLTV ] = false;
}

public plugin_natives( )
{
	register_library("Bank");
	register_native("get_user_bank", "_get_user_bank")
	register_native("set_user_bank", "_set_user_bank")
}

public _get_user_bank( iPlugin , iParams )
{
	return g_iPlayer[ get_param( 1 ) ][ Bank ]
}

public _set_user_bank( iPlugin , iParams )
{
	new id = get_param( 1 )
	g_iPlayer[ id ][ Bank ] = get_param( 2 );
	ReadData( id );
}

public plugin_end( )
{
	if( g_iSettings[ USE_SQL ] )
	{
		SQL_FreeHandle( g_SQLTuple );
	}
	else
	{
		nvault_close( g_iVault );
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ fbidis\\ ansi\\ ansicpg1252\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset0 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ ltrpar\\ lang3073\\ f0\\ fs16 \n\\ par }
*/
