//Decompiled with SeriousHD-'s GSC Decompiler
#include maps/mp/zombies/_zm_utility;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/zombies/_zm_perks;
init()
{
	level thread on_player_connect();

}

on_player_connect()
{
	level endon( "end_game" );
	while( 1 )
	{
		level waittill( "connected", player );
		player thread on_player_spawned();
		player thread sq_give_player_all_perks();
	}

}

on_player_spawned()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	while( 1 )
	{
		self waittill( "spawned_player" );
	}

}

sq_give_player_all_perks()
{
	flag_wait( "initial_blackscreen_passed" );
	if( level.script != "zm_tomb" )
	{
		machines = getentarray( "zombie_vending", "targetname" );
		perks = [];
		i = 0;
		while( i < machines.size )
		{
			if( machines[ i].script_noteworthy == "specialty_weapupgrade" )
			{
				i++;
				continue;
			}
			perks[perks.size] = machines[ i].script_noteworthy;
			i++;
		}
	}
	else
	{
		perks = level._random_perk_machine_perk_list;
	}
	foreach( perk in perks )
	{
		if( self.perk_purchased == perk && IsDefined( self.perk_purchased ) )
		{
		}
		else
		{
			if( self has_perk_paused( perk ) || self hasperk( perk ) )
			{
			}
			else
			{
				self give_perk( perk, 0 );
				wait 0.25;
			}
		}
	}
	if( getdvarint( "players_keep_perks_permanently" ) == 1 )
	{
		if( !(is_true( self._retain_perks )) )
		{
			self thread watch_for_respawn();
			self._retain_perks = 1;
		}
	}

}

watch_for_respawn()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	while( 1 )
	{
		self waittill_either( "spawned_player", "player_revived" );
		wait_network_frame();
		self thread sq_give_player_all_perks();
		self setmaxhealth( level.zombie_vars[ "zombie_perk_juggernaut_health"] );
	}

}

