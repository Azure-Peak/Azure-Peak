SUBSYSTEM_DEF(hunting)
	name = "Hunting"
	wait = 5 MINUTES
	runlevels = RUNLEVEL_GAME
	flags = SS_NO_INIT
	/// List of landmark objects waiting to spawn a new trail
	var/list/active_spawners = list()

// Uncomment debug comments to debug!
/datum/controller/subsystem/hunting/fire(resumed = 0)
	if(!(SSticker.current_state == GAME_STATE_PLAYING && active_spawners.len > 0))
		return
	//to_chat(world, span_alert("SSHunting: Firing. Managing [active_spawners.len] spawner landmarks."))

	var/amount_to_respawn = max(1, round(active_spawners.len * 0.25))

	for(var/i in 1 to amount_to_respawn)
		var/obj/effect/landmark/hunting_spawner/JS = pick(active_spawners)
		if(!JS || QDELETED(JS))
			active_spawners -= JS
			continue

		//to_chat(world, span_alert("SSHunting: Spawning new trail at [JS.x], [JS.y]."))
		JS.respawn_trail()
